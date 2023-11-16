import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Recipe/RecipeDetailPage.dart';

class Mypage extends StatefulWidget {
  Mypage({Key? key}) : super(key: key);

  @override
  State<Mypage> createState() => _SearchState();
}

class _SearchState extends State<Mypage> {
  String? baseurl = dotenv.env['API_BASE_URL'];
  final storage = FlutterSecureStorage();
  var _user = {};
  List<dynamic> _userBookmarked = [];
  var mypage_menu = ElevatedButton.styleFrom(
    backgroundColor: Color(0xffdddddd),
    minimumSize: Size(420, 50),
    elevation: 0.0,
  );

  Future<void> getUserData() async {
    String? jwtToken = await storage.read(key: 'jwt');

    if (jwtToken == null) {
      print('로그인해주세요');
    }

    final response = await http.get(
        Uri.parse('$baseurl/mypage'),
        headers: {'X-ACCESS-TOKEN': jwtToken ?? ''}
    );

    if (response.statusCode == 200) {
      Map responseData =  jsonDecode(utf8.decode(response.bodyBytes));
      bool isSuccess = responseData['isSuccess'];
      print('responseData ${responseData}');
      if (isSuccess) {
        setState(() {
          _user = responseData['result'];
        });
      } else {
        print('유저 정보를 조회할 수 없습니다.');
      }
    } else {
      throw Exception('Failed to load mypage');
    }
  }

  Future<void> getUserBookmarked() async {
    final storage = FlutterSecureStorage();
    String? jwtToken = await storage.read(key: 'jwt');

    if (jwtToken == null) {
      print('로그인해주세요');
      return;
    }

    final response = await http.get(
      Uri.parse('$baseurl/likes/users-recipe'),
      headers: {'X-ACCESS-TOKEN': jwtToken ?? ''},
    );

    if (response.statusCode == 200) {
      Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
      bool isSuccess = responseData['isSuccess'];
      print('responseData ${responseData}');
      if (isSuccess) {
        setState(() {
          _userBookmarked = responseData['result'];
        });
      } else {
        print('Failed to load bookmarkedRecipes');
      }
    } else {
      print('Failed to load bookmarkedRecipes');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getUserBookmarked();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 500.0,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    height: 240.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/cover.jpg'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10.0),
                    ), //Container의 스타일 및 배경 이미지
                  ),
                  Positioned(
                    top: 180,
                    left: 0.0,
                    right: 0.0,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/profile.jpg'),
                          radius: 70.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(_user['nickname'] ?? '',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold)),
                        Text('학생',
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on),
                            Text('부산광역시, 남구',
                                style: TextStyle(
                                    fontSize: 13.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                '프로필 수정',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF242760),
                                  minimumSize: Size(150, 50),
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0))),
                            ),
                            SizedBox(width: 20), // 간격을 조절하기 위한 SizedBox 위젯 추가
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                '친구 추가',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF242760),
                                  minimumSize: Size(150, 50),
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0))),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Divider(),
            ),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.local_grocery_store,
                    color: Color(0xFF242760),
                  ),
                  label: Text(
                    '내가 사용한 레시피',
                    style: TextStyle(
                        color: Color(0xFF242760), fontWeight: FontWeight.bold),
                  ),
                  style: mypage_menu,
                ),
                SizedBox(height: 10), // 간격을 조절하기 위한 SizedBox 위젯 추가
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.book,
                    color: Color(0xFF242760),
                  ),
                  label: Text(
                    '내가 사용한 레시피',
                    style: TextStyle(
                        color: Color(0xFF242760), fontWeight: FontWeight.bold),
                  ),
                  style: mypage_menu,
                ),
                SizedBox(height: 10), // 간격을 조절하기 위한 SizedBox 위젯 추가
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                    color: Color(0xFF242760),
                  ),
                  label: Text(
                    '계정 관리',
                    style: TextStyle(
                        color: Color(0xFF242760), fontWeight: FontWeight.bold),
                  ),
                  style: mypage_menu,
                ),
              ],
            ),
          Container(
              margin: EdgeInsets.all(15.0),
              child: TabBarScreen(userBookmarked: _userBookmarked))
          ],
        ),
      ),
    );
  }
}

class TabBarScreen extends StatefulWidget {
  final List userBookmarked;

  TabBarScreen({Key? key, required this.userBookmarked}) : super(key: key); //recipe라는 이름의 매개변수를 받는 생성자

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
        Recipes(userBookmarked: widget.userBookmarked),
        FoodItems(),
      ],
    );
  }
}

class Recipes extends StatefulWidget {
  final List userBookmarked;

  Recipes({Key? key, required this.userBookmarked}) : super(key: key);

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.userBookmarked.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 7.0,
        crossAxisSpacing: 7.0,
      ),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i){
        return InkWell(
          onTap: () {
            print(widget.userBookmarked[i]);
            Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetailPage(recipe: widget.userBookmarked[i]),),);
          },
          child: Image.network(
            widget.userBookmarked[i]['attFileNoMk'],
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

class FoodItems extends StatelessWidget {
  FoodItems({Key? key}) : super(key: key);

  List<Map> fooditems = [
    {
      'name': '당면',
      'imageUrl': 'https://sitem.ssgcdn.com/20/65/74/item/1000004746520_i1_750.jpg',
    },
    {
      'name': '어묵',
      'imageUrl': 'https://j2mart.net/data/item/8803125300008/1.jpg',
    },
    {
      'name': '대파',
      'imageUrl': 'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/vendor_inventory/e255/b573606d84a0e81307354e35e05b0914b50a7ef3a10f48fa6dd59be5f8b2.jpg',
    },
    {
      'name': '양파',
      'imageUrl': 'https://img-cf.kurly.com/shop/data/goodsview/20210225/gv00000161144_1.jpg',
    },
    {
      'name': '떡국떡',
      'imageUrl': 'https://img1.tmon.kr//cdn3/deals/2020/01/14/2961135302/2961135302_summary_11578965256_4ff31.jpg',
    },
    {
      'name': '팽이버섯',
      'imageUrl': 'https://static.megamart.com/product/image/0206/02063027/02063027_6_960.jpg',
    },
    {
      'name': '된장',
      'imageUrl': 'https://cdn-acemall.bizhost.kr/files/goods/813/1565064869_2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: fooditems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 7.0,
        crossAxisSpacing: 7.0,
      ),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i){
        return InkWell(
          onTap: () {

          },
          child: ClipRRect(
            child: Image.network(//나중에 asset으로 변경
              fooditems[i]['imageUrl'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
