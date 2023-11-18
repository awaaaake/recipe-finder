import 'package:flutter/material.dart';
<<<<<<< HEAD
import './mypage.dart';
import './search.dart';
import './board.dart';
import './Ingredient_scanner.dart';
=======
import 'tab/mypage.dart';
import './tab/search.dart';
import 'tab/menu.dart';
import './tab/Ingredient_scanner.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
>>>>>>> c03ac470a81da73dc28af92deec7b1bf6c1e6917

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _tab=2;

  //로그인 여부 확인
  isLoggedIn() async {
    final storage = FlutterSecureStorage();
    String? jwtToken = await storage.read(key: 'jwt');
    // user의 정보가 있다면 첫 페이지로 이동
    if (jwtToken == null) {
      Navigator.pushNamed(context, '/login');
    } else {
      print('토큰있음 ${jwtToken}');
    }
  }

  @override
  void initState() {
    super.initState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      body:[Search(), Board(), Scanner(), Mypage()][_tab], //list에서 자료뽑는 문법
=======
      body:[Search(), Scanner(), Menu(), Mypage()][_tab], //list에서 자료뽑는 문법
>>>>>>> c03ac470a81da73dc28af92deec7b1bf6c1e6917
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 아이콘 간격을 일정하게
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            _tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.grey[600]),
              label: '검색'
          ),
          BottomNavigationBarItem(
<<<<<<< HEAD
              icon: Icon(Icons.dashboard_customize),
              label: '게시판'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
=======
              icon: Icon(Icons.add_circle, color: Colors.grey[600]),
              label: '재료스캐너'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.grey[600]),
>>>>>>> c03ac470a81da73dc28af92deec7b1bf6c1e6917
              label: '홈'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: Colors.grey[600]),
              label: '마이페이지'
          ),
        ],
      ),
    );
  }
}