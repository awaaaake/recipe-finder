import 'package:flutter/material.dart';

class Mypage extends StatefulWidget {
  Mypage({Key? key}) : super(key: key);

  @override
  State<Mypage> createState() => _SearchState();
}

class _SearchState extends State<Mypage> {
  var mypage_menu = ElevatedButton.styleFrom(
    backgroundColor: Color(0xffdddddd),
    minimumSize: Size(420, 50),
    elevation: 0.0,
  );

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
                        horizontal: 15.0, vertical: 15.0), //좌우, 상하 여백 설정
                    height: 240.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/cover.jpg'),
                          fit: BoxFit.cover), //Container의 배경 이미지
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
                        Text('김급식',
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
                                  minimumSize: Size(200, 50),
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
                                  minimumSize: Size(200, 50),
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
              child: TabBarScreen())
          ],
        ),
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

class Recipes extends StatelessWidget {
  Recipes({Key? key}) : super(key: key);

  List<Map> recipes = [
    {
      'name': '비빔밥',
      'imageUrl': 'assets/recipe/recipe1.jpg',
    },
    {
      'name': '갈비찜',
      'imageUrl': 'assets/recipe/recipe2.jpg',
    },
    {
      'name': '소고기 무국',
      'imageUrl': 'assets/recipe/recipe3.jpg',
    },
    {
      'name': '스파게티',
      'imageUrl': 'assets/recipe/recipe4.jpg',
    },
    {
      'name': '토마토 샐러드',
      'imageUrl': 'assets/recipe/recipe5.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: recipes.length,
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
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              recipes[i]['imageUrl'],
              //이미지 크기설정?
            ),
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
      'imageUrl': 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fj2mart.tistory.com%2F137&psig=AOvVaw0bqX2UbyHry0ah1S_Uih6Z&ust=1696853325030000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCLiRwLG15oEDFQAAAAAdAAAAABAD',
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
      'imageUrl': 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fkr%2F%25EC%2582%25AC%25EC%25A7%2584%2F%25EC%2596%2591%25ED%258C%258C%25ED%2598%2595-%25EC%25A0%2584%25EA%25B5%25AC%25EB%25A5%25BC-gm513920379-47419460&psig=AOvVaw13fOVcppntP-PafOyQvmmd&ust=1696853434663000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCLjX4-O15oEDFQAAAAAdAAAAABAD',
    },
    {
      'name': '떡국떡',
      'imageUrl': 'https://www.google.com/url?sa=i&url=https%3A%2F%2Flottemart.lotteon.com%2Fm%2Fproduct%2FLM8801165013728%3FsitmNo%3DLM8801165013728_001%26ch_no%3D100220%26ch_dtl_no%3D1000660%26entryPoint%3Dpcs%26dp_infw_cd%3DCHT&psig=AOvVaw3iL30zJGLRfG4DG-H53BFT&ust=1696853479313000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNjj0fm15oEDFQAAAAAdAAAAABAD',
    },
    {
      'name': '팽이버섯',
      'imageUrl': 'https://static.megamart.com/product/image/0206/02063027/02063027_6_960.jpg',
    },
    {
      'name': '된장',
      'imageUrl': 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fm.acemall.asia%2Fshop%2Fview.php%3Findex_no%3D813&psig=AOvVaw19weoR_pbR4FmNy94bGWYJ&ust=1696853554689000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCPDQvJ225oEDFQAAAAAdAAAAABAD',
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
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(//나중에 asset으로 변경
              fooditems[i]['imageUrl'],
              //이미지 크기설정?
            ),
          ),
        );
      },
    );
  }
}
