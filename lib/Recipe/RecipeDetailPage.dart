import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../review/review.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../provider/user_bookmarkedRecipes.dart';

class RecipeDetailPage extends StatefulWidget {
  final Map recipe;

  RecipeDetailPage({required this.recipe}); //recipe라는 이름의 매개변수를 받는 생성자

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  String? baseurl = dotenv.env['API_BASE_URL'];

  final storage = FlutterSecureStorage();
  List<bool> ingredientChecklist = [];
  List<String> ingredientList = [];
  List<String> descriptions = [];
  List<String> imageUrls = [];
  bool isSaved=false;
  late Future<List<dynamic>> reviews;
  List<int> myReviews = [];
  var count;
  var reviewAverage;
  PageController _pageController = PageController(); // 페이지 컨트롤러 추가

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkBookmarked(widget.recipe['rcpId']);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      checkAndSetBookmarkedStatus();
      initializeRecipeDetails();
    });

    // 재료 체크 상태 리스트를 초기화하고 모든 재료를 선택되지 않은 상태로 설정
    ingredientChecklist = List<bool>.filled(
        calculateIngredientCount(widget.recipe['rcpPartsDtls']), false);

    print('widget.recipe: ${widget.recipe['rcpId']}');
    reviews = fetchReviews(widget.recipe['rcpId']);

    getMyReviews();
  }

  Future<void> checkAndSetBookmarkedStatus() async {
    bool bookmarkedStatus = await checkBookmarked(widget.recipe['rcpId']);
    setState(() {
      isSaved = bookmarkedStatus;
    });
  }

  Future<bool> checkBookmarked(int rcpId) async {
    String? jwtToken = await storage.read(key: 'jwt');
    if (jwtToken == null) {
      print('jwt토큰이 존재하지 않습니다');
      return false; // 토큰이 없으면 찜 여부를 알 수 없으므로 false를 반환
    }

    final response = await http.get(
      Uri.parse('$baseurl/likes/check-recipe-like?rcpId=$rcpId'),
      headers: {'X-ACCESS-TOKEN': jwtToken},
    );

    if (response.statusCode == 200) {
      Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
      bool isSuccess = responseData['isSuccess'];
      print(responseData);
      return isSuccess;
    } else {
      throw Exception('Failed to check bookmark status');
    }
  }


  Future<List<dynamic>> fetchReviews(int rcpId) async {
    final response = await http
        .get(Uri.parse('$baseurl/review/recipe/$rcpId'));
    if (response.statusCode == 200) {
      Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
      bool isSuccess = responseData['isSuccess'];
      if (isSuccess) {
        setState(() {
          reviewAverage = responseData['result']['reviewAverage'];
          count = responseData['result']['count'];
        });
        return responseData['result']['reviews'];
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<void> getMyReviews() async {
    String? jwtToken = await storage.read(key: 'jwt');
    if (jwtToken == null) {
      print('jwt토큰이 존재하지 않습니다');
      return;
    }

    final response = await http.get(
        Uri.parse('$baseurl/review/users'),
        headers: {'X-ACCESS-TOKEN': jwtToken});
    if (response.statusCode == 200) {
      Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
      bool isSuccess = responseData['isSuccess'];
      List<dynamic> reviews = responseData['result']['reviews'];
      if (isSuccess) {
        setState(() {
          for (var review in reviews) {
            int reviewId = review['reviewId'];
            myReviews.add(reviewId);
          }
        });
      } else {
        print('Failed to load user reviews');
        return;
      }
    } else {
      throw Exception('Failed to load user reviews');
    }
  }

  Future<void> removeMyReviews(int reviewId) async {
    String? jwtToken = await storage.read(key: 'jwt');
    if (jwtToken == null) {
      print('jwt토큰이 존재하지 않습니다');
      return;
    }

    final response = await http.delete(
        Uri.parse('$baseurl/review/$reviewId'),
        headers: {'X-ACCESS-TOKEN': jwtToken});
    if (response.statusCode == 200) {
      Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
      bool isSuccess = responseData['isSuccess'];
      if (isSuccess) {
        setState(() {
          reviews = fetchReviews(widget.recipe['rcpId']);
        });
      } else {
        print('Failed to remove user reviews');
        return;
      }
    } else {
      throw Exception('Failed to remove user reviews');
    }
  }

  Future<void> toggleSaveStatus() async {
    String? jwtToken = await storage.read(key: 'jwt');
    if (jwtToken == null) {
      print('jwt토큰이 존재하지 않습니다');
      return;
    }

    bool addToFavorites = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSaved ? "찜 목록에서 삭제" : "찜 목록에 추가"),
          content: Text(
              isSaved ? "찜 목록에서 삭제하시겠습니까?" : "찜 목록에 추가하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("확인"),
            ),
          ],
        );
      },
    );

    if (addToFavorites == null || !addToFavorites) {
      return; // 사용자가 확인하지 않거나 취소한 경우
    }

    final response = isSaved
        ? await http.delete(
      Uri.parse('$baseurl/likes/recipe/delete?rcpId=${widget.recipe['rcpId']}'),
      headers: {'X-ACCESS-TOKEN': jwtToken},
    )
        : await http.post(
      Uri.parse('$baseurl/likes/recipe/add?rcpId=${widget.recipe['rcpId']}'),
      headers: {'X-ACCESS-TOKEN': jwtToken},
    );

    if (response.statusCode == 200) {
      Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
      bool isSuccess = responseData['isSuccess'];
      if (isSuccess) {
        setState(() {
          isSaved = !isSaved;
        });
      } else {
        print('Failed to toggle save status');
      }
    } else {
      print('Failed to toggle save status');
    }
  }

  void initializeRecipeDetails() {
    for (int i = 1; i <= 20; i++) {
      String manualKey = 'manual${i.toString().padLeft(2, '0')}';
      String imgKey = 'manualImg${i.toString().padLeft(2, '0')}';
      if (widget.recipe[manualKey] != '' && widget.recipe[imgKey] != '') {
        setState(() {
          descriptions.add(widget.recipe[manualKey]);
          imageUrls.add(widget.recipe[imgKey]);
          print('descriptions,imageUrls : ${descriptions}, ${imageUrls}');
        });
      }
    }
  }

  // 재료의 개수를 계산하는 함수
  int calculateIngredientCount(String ingredients) {
    setState(() {
      ingredientList = ingredients.length > 0
          ? ingredients.split(',')
          : []; // 재료들을 콤마와 공백을 기준으로 분리
      print(ingredientList);
    });
    return ingredientList.length; // 재료의 개수 반환
  }

  //ISO 8601형식의 날짜를 년월일 순의 문자열로 변환
  String convertIso8601ToDateString(String iso8601String) {
    DateTime dateTime = DateTime.parse(iso8601String);
    String formattedDate =
        "${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)}";
    return formattedDate;
  }

  //숫자가 10보다 작으면 왼쪽에 0을 추가하여 두 자리로 만드는 함수
  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.recipe['attFileNoMk'],
                    width: MediaQuery.of(context).size.width,
                    height: 300.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                widget.recipe['rcpNm'],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: 10.0),
              Text(
                '메인 재료: ${widget.recipe['rcpPartsDtls'] ?? ''}',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Share button tapped
                    },
                    child: SvgPicture.asset(
                      'assets/share.svg',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      toggleSaveStatus();
                    },
                    child: SvgPicture.asset(
                      isSaved ? 'assets/save.svg' : 'assets/notsave.svg',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Divider(
                color: Colors.grey,
                height: 2.0,
              ),
              SizedBox(height: 15.0),
              Text(
                '재료',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  calculateIngredientCount(widget.recipe['rcpPartsDtls']),
                  (index) => Row(
                    children: [
                      Checkbox(
                        activeColor: Color(0xff242760),
                        value: ingredientChecklist[index],
                        onChanged: (value) {
                          setState(() {
                            ingredientChecklist[index] = value!;
                          });
                        },
                      ),
                      Text(
                        '${ingredientList[index].trim()}',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Divider(
                color: Colors.grey,
                height: 2.0,
              ),
              SizedBox(height: 15.0),
              Text(
                '조리 방법',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: descriptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    imageUrls[index],
                                    width: constraints.maxWidth,
                                    // 48은 화살표 아이콘의 크기와 여백을 나타냅니다
                                    height: 280.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (index != 0)
                                  Positioned(
                                    left: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Colors.grey[700],
                                        size: 32.0,
                                      ),
                                      onPressed: () {
                                        _pageController.previousPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ),
                                if (index != descriptions.length - 1)
                                  Positioned(
                                    right: 10.0,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.grey[700],
                                        size: 32.0,
                                      ),
                                      onPressed: () {
                                        _pageController.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              descriptions[index],
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 2.0,
              ),
              SizedBox(height: 15.0),
              Text(
                '후기',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        reviewAverage != null ? reviewAverage.toString() : '0.0',
                        style: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        count != null ? '${count.toString()}개의 평가' : '0개의 평가',
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    children: [
                      RatingBar.builder(
                        initialRating: reviewAverage ?? 0.0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        ignoreGestures: true,
                        // 사용자가 조절하지 못하도록 설정
                        onRatingUpdate: (rating) {},
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Review(recipeId: widget.recipe['rcpId'])))
                              .then((value) {
                            if (value == 'reveiw_update') {
                              setState(() {reviews = fetchReviews(widget.recipe['rcpId']);
                              getMyReviews();
                              });
                            }
                          });
                        },
                        child: SizedBox(
                            width: 200,
                            height: 30,
                            child: Center(
                                child: Text(
                              '리뷰 작성하기',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400),
                            ))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF242760),
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              FutureBuilder<List<dynamic>>(
                future: reviews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<dynamic> reviewList = snapshot.data!;
                    bool hasReviews = reviewList.isNotEmpty;

                    if (hasReviews) {
                      return Container(
                        constraints: BoxConstraints(
                          maxHeight: 200.0,
                        ),
                        child: ListView.builder(
                          itemCount: reviewList.length,
                          itemBuilder: (BuildContext context, int index) {
                            String formattedDate = convertIso8601ToDateString(
                                reviewList[index]['reviewCreated']);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(reviewList[index]['nickName'], style: TextStyle(fontWeight: FontWeight.w600)),
                                        Icon(Icons.chevron_right, size: 20.0),
                                        SizedBox(width: 3.0),
                                        RatingBar.builder(
                                          initialRating: reviewList[index]
                                              ['reviewRating'],
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 18.0,
                                          itemPadding: EdgeInsets.fromLTRB(
                                              0, 2.0, 2.0, 2.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          ignoreGestures: true,
                                          onRatingUpdate: (rating) {},
                                        ),
                                      ],
                                    ),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(reviewList[index]['reviewContext']),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                        reviewList[index]['reviewImageUrl'] != null ? Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Image.network(
                                                // "localhost" 대신 서버의 IP 주소로 변경
                                                reviewList[index]
                                                        ['reviewImageUrl']
                                                    .replaceFirst('localhost',
                                                        '15.164.139.103'),
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.cover,
                                              )
                                        ): Container(),
                                    myReviews.contains(reviewList[index]['reviewId'])
                                        ? SizedBox(
                                            child: Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text("리뷰 삭제"),
                                                          content: Text("정말로 리뷰를 삭제하시겠습니까?"),
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
                                                                removeMyReviews(
                                                                    reviewList[index]['reviewId']);
                                                                reviews = fetchReviews(widget.recipe['rcpId']);
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    '삭제',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  style: TextButton.styleFrom(
                                                    minimumSize: Size.zero,
                                                    padding: EdgeInsets.zero,
                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Color(0xffACACAC),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 100.0,
                        child: Center(
                          child: Text(
                            '앗! 등록된 리뷰가 없네요.',
                            style: TextStyle(
                                color: Color.fromRGBO(148, 148, 148, 1.0)),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
