import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String? baseurl = dotenv.env['API_BASE_URL'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var title = '';
  var content = '';

  Future<void> addPost() async {
    final storage = FlutterSecureStorage();
    String? jwtToken = await storage.read(key: 'jwt');
    if (jwtToken == null) {
      print('jwt토큰이 존재하지 않습니다');
      //로그인해주십시오
      return;
    }

    final response = await http.post(
      Uri.parse('$baseurl/board/add'),
      headers: <String, String>{
        'X-ACCESS-TOKEN': jwtToken,
      },
      body: <String, String>{
        'title': title,
        'content': content,
      },
    );

    if (response.statusCode == 200) {
      Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
      bool isSuccess = responseData['isSuccess'];
      if (isSuccess) {
        Navigator.of(context).pop('post_update');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('게시글이 성공적으로 등록되었습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('게시글 등록에 실패하였습니다.')),
        );
      }
    } else {
      print('Failed to post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '새 게시글 작성',
          style: TextStyle(
              color: Color(0xffACACAC),
              fontSize: 15.0,
              fontWeight: FontWeight.w400),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffACACAC),
          ), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // 원하는 색상으로 변경
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey), // 포커스가 있는 상태의 색상
                  ),
                  hintText: '제목',
                ),
                onSaved: (String? value) {
                  title = value ?? '';
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 6,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // 원하는 색상으로 변경
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey), // 포커스가 있는 상태의 색상
                  ),
                  hintText: '내용',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
                ),
                onSaved: (String? value) {
                  content = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFB01D),
                    minimumSize: Size(150, 50),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                child: Text('게시글 등록'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    addPost();
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
