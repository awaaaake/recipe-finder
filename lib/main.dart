import 'package:flutter/material.dart';
import 'package:instagram/splash_screen.dart';
//다른파일에있는 변수, 함수를 쓰고 싶으면 import '파일경로'
import './style.dart' as style;
import 'login/login.dart';
import './RecipeDetailPage.dart';
import './RecipePage.dart';
import './home.dart';
import './Ingredient_scanner.dart';
import './Step1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter/rendering.dart';

var theme; //변수 중복 문제

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: style.theme,
        home: MyApp(),
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => MyApp(),
        //   '/login': (context) => Login(),
        // },
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data =[];
/*
  getData() async {
    var result = await http.get(
        Uri.parse('https://codingapple1.github.io/app/data.json')
    );
    if (result.statusCode == 200) {
      print( jsonDecode(result.body) );
      var result2=jsonDecode(result.body);
      setState(() {
        data=result2;
      });
    } else {
      throw Exception('실패함ㅅㄱ');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: Text('Instagram'),
      //     actions: [
      //       IconButton(
      //         onPressed: (){
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (c)//context를 하나 만들어줌 새롭게
      //               => Text('') //커스텀위젯
      //               )
      //           ); //Materialapp이 들어있는 context를 넣어야함
      //         },
      //         icon: Icon(Icons.add_box_outlined),
      //         iconSize: 30,
      //       )
      //     ]
      // ),
      body: Login(),
      // bottomNavigationBar: BottomNavigationBar(
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   onTap: (i){
      //     setState(() {
      //       tab=i;
      //     });
      //   },//onpressed와 거의 동일, 파라미터를 기본적으로 입력하게 돼있음, i는 지금 누른 버튼 번호임
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home_outlined),
      //         label:'홈'
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.shopping_bag_outlined),
      //         label:'샵'
      //     ),
      //   ],
      // ),
    );
  }
}

