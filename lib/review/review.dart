import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class Review extends StatefulWidget {
  final int recipeId;

  Review({required this.recipeId});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  String? baseurl = dotenv.env['API_BASE_URL'];
  double _rating = 0;
  String _review = '';
  TextEditingController _controller = TextEditingController();

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  Future<bool> getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
    // } else if (status.isDenied) {
    //   return false;
    // }
  }

  Future<void> sendReviewToServer(int recipeId, String reviewContext, double reviewRating, File imageFile) async {
    final storage = FlutterSecureStorage();
    String? jwtToken = await storage.read(key: 'jwt');
    print('jwtToken : ${jwtToken}');
    if (jwtToken == null) {
      print('jwt토큰이 존재하지 않습니다');
      //로그인해주십시오
      return;
    }

    // Dio 클라이언트 생성
    Dio dio = Dio();

    // JWT 토큰을 헤더에 추가
    dio.options.headers['X-ACCESS-TOKEN'] = jwtToken;
    dio.options.contentType = 'multipart/form-data';

    // FormData를 생성하고 이미지 파일을 추가
    FormData formData = FormData();

    if (imageFile.path.isNotEmpty) {
      formData.files.add(MapEntry('images', await MultipartFile.fromFile(imageFile.path, filename: 'image.jpg')));
    }

    // 쿼리 파라미터를 포함한 URL 생성
    String urlWithParams = '$baseurl/review?recipeId=$recipeId&reviewContext=$reviewContext&reviewRating=$reviewRating';

    try {
      Response response = await dio.post(urlWithParams, data: formData);
      print('reviewRating  ${reviewRating}');
      print('formData ${formData}');
      print(response);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = response.data;
        bool isSuccess = responseBody['isSuccess'];
        if (isSuccess) {
          print('Review posted successfully');
          Navigator.of(context).pop('reveiw_update');
        } else {
          print('$responseBody Failed to post review.');
        }
      } else {
        print('Failed to post review. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending review: $error');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffACACAC),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 2.0,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _image != null
                      ? Image.file(
                          File(_image!.path),
                          height: 300,
                          width: MediaQuery.of(context).size.width - 40,
                          fit: BoxFit.cover,
                        )
                      : IconButton(
                        icon: Icon(
                          Icons.queue,
                          color: Colors.grey,
                          size: 50.0,
                        ),
                        onPressed: () async {
                          bool isPermissionGranted = await getPermission();
                          if(isPermissionGranted) {
                            getImage(ImageSource.gallery);
                          } else {
                            Permission.contacts.request();
                          }
                        },
                      ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 30.0,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            TextField(
                              maxLines: 4,
                              onChanged: (value) {
                                setState(() {
                                  _review = value;
                                });
                              },
                              controller: _controller,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                hintText: '리뷰를 작성해주세요...',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 15.0),
                                border: InputBorder.none,
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ElevatedButton(
                        onPressed: () {
                          File imageFile;
                          print('_image ${_image}');
                          if (_image == null) {
                            imageFile = File(''); // Empty file
                          } else {
                            imageFile = File(_image!.path); // Use selected image file
                          }

                          showDialog(
                            context: context,
                            builder: (BuildContext
                            context) {
                              return AlertDialog(
                                title: Text("리뷰 등록"),
                                content: Text("정말로 리뷰를 등록하시겠습니까?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("취소"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("확인"),
                                    onPressed: () {
                                      sendReviewToServer(widget.recipeId , _review, _rating, imageFile);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF242760),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
