import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var title = '';
  var content = '';

  Future<void> addPost() async {
    final response = await http.post(
      Uri.parse('http://15.164.139.103:8080/board/add'),
      headers: <String, String>{
        'X-ACCESS-TOKEN': "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJpZCI6MTIwLCJpYXQiOjE3MDAxMTUyMTksImV4cCI6MTcwMTU4NjQ0OH0.FsQdpZtDtb0S3E_fWLnJM42TGmL4D7eMt7yJYfkoPYw",
      },
      body: <String, String>{
        'title': title,
        'content': content,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시글이 성공적으로 등록되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시글 등록에 실패하였습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("새 게시글 작성"),
        backgroundColor: Color(0xFFFFB01D),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '제목',
                ),
                onSaved: (String? value) {
                  title = value ?? '';
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '내용',
                ),
                onSaved: (String? value) {
                  content = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFB01D)),
                ),
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
