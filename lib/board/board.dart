import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './addpost.dart';
import '../style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  String? baseurl = dotenv.env['API_BASE_URL'];
  var data = [];
  var responselength = 0;

  getBoardAll() async {
    var response = await http.get(Uri.parse('$baseurl/board/list'));
    Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      responselength = responseData["result"].length;
      data = responseData["result"];
    });
  }

  searchBoard(String keyword) async {
    var response = await http.get(
        Uri.parse('$baseurl/board/search-board-of-content?keyword=$keyword'));
    Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
    print(responseData);
    setState(() {
      responselength = responseData["result"].length;
      data = responseData["result"];
    });
  }

  InputBorder _customBorder(double width, Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: color,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getBoardAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '게시판',
          style: TextStyle(
              color: Color(0xffACACAC),
              fontSize: 15.0,
              fontWeight: FontWeight.w400),
        ),
        elevation: 1,
        // backgroundColor: Color(0xFFFFB01D),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  String keyword = ''; // 검색 키워드를 저장할 변수를 추가합니다.
                  return AlertDialog(
                    title: const Text('게시물 검색'),
                    content: TextField(
                      onChanged: (value) {
                        keyword = value; // 검색 키워드를 변수에 저장합니다.
                      },
                      decoration: InputDecoration(
                        hintText: '검색 키워드를 입력하세요',
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: _customBorder(2, Color(0xFFFFB01D)),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('완료', style: TextStyle(
                          color: Colors.black
                        ),),
                        onPressed: () {
                          searchBoard(keyword); // 검색 키워드로 게시물을 검색합니다.
                          Navigator.pop(context); // AlertDialog를 닫습니다.
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: responselength,
          itemBuilder: (c, i) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(data[i]["title"],
                    style: TextStyle(color: Colors.black)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data[i]["nickname"],
                        style: TextStyle(color: Colors.grey)),
                    Text(data[i]["content"],
                        style: TextStyle(color: Colors.black54)),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.thumb_up, color: Colors.grey, size: 20),
                        Text(" " + data[i]["likeCnt"].toString()),
                        SizedBox(width: 10),
                        Icon(Icons.comment, color: Colors.grey, size: 20),
                        Text(" " + data[i]["commentCnt"].toString()),
                        SizedBox(width: 10),
                        Icon(Icons.remove_red_eye,
                            color: Colors.grey, size: 20),
                        Text(" " + data[i]["hits"].toString()),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPost()))
              .then((value) {
            if (value == 'post_update') {
              setState(() {
                getBoardAll();
              });
            }
          });
        },
        child: Icon(Icons.add),
        elevation: 0,
        backgroundColor: Color(0xFFFFB01D),
      ),
    );
  }
}
