import 'package:flutter/material.dart';
import './mypage.dart';
import './search.dart';
import './board.dart';
import './Ingredient_scanner.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _tab=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:[Search(), Board(), Scanner(), Mypage()][_tab], //list에서 자료뽑는 문법
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            _tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '검색'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize),
              label: '게시판'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: '마이페이지'
          ),
        ],
      ),
    );
  }
}


class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key}) : super(key: key);

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,

    /// 탭 변경 애니메이션 시간
    animationDuration: const Duration(milliseconds: 300),
  );

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _tabBar(),
        Container(
          constraints: BoxConstraints(
            maxHeight: 400.0, // constraints 속성으로 최대 높이 지정
          ),
          child: _tabBarView(),
        )
      ],
    );
  }

  Widget _tabBar() {
    return TabBar(
      controller: tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      labelStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      /// 기본 인디캐이터의 컬러
      indicatorColor: Color(0xFF242760),
      indicatorWeight: 2,
      tabs: const [
        Tab(text: "레시피"),
        Tab(text: "식자재"),
      ],
    );
  }

  Widget _tabBarView() {
    return TabBarView(
      controller: tabController,
      children: [
        Recipes(),
        FoodItems(),
      ],
    );
  }
}