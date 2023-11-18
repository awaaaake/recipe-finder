import 'package:flutter/material.dart';
import './home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './RecipeDetailPage.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final _mainTitleStyle = TextStyle(
      fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black);
  var filter = ['평점', '가격', '보유재료', '난이도 낮은 순', '조리시간 짧은 순', '비건'];
  List<bool> isSelected = List<bool>.filled(6, false);

  //레시피 리스트 더미데이터
  final List<Map> _recipes = [
    {
      'menuName': '스파게티 볼로네즈',
      'rating': '4.5',
      'price': '12.99',
      'mainIngredient': '파스타',
      'ingredients': ['파스타면','베이컨','양파','새송이버섯','슬라이스치즈','마늘','새우(생략가능)'],
      'cookingTime' : '10',
      'recipeDescription' : [
        '재료 준비','요리 시작','맛있게 먹어'
      ],
      'imageUrl': 'https://www.google.com/url?sa=i&url=http%3A%2F%2Fm.blog.naver.com%2Fjenkong07%2F221183772157&psig=AOvVaw2TZhc-WBZMlN-Tijc8qDdJ&ust=1696865090776000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCIjO4Zrh5oEDFQAAAAAdAAAAABAD'
    },
    {
      'menuName': '그릴드 샐러드',
      'rating': '4.2',
      'price': '8.99',
      'mainIngredient': '채소',
      'ingredients': ['케일 ','치커리','비타민채소 ','로메인 ','닭가슴살 '],
      'cookingTime' : '10',
      'recipeDescription' : [
        '재료 준비','요리 시작','맛있게 먹어'
      ],
      'imageUrl': 'https://2bob.co.kr/data/recipe/20211102200440-BHF25.jpg'
    },
    {
      'menuName': '치킨 파르마산',
      'rating': '4.7',
      'price': '14.99',
      'mainIngredient': '닭고기',
      'ingredients': ['순살치킨 ','양파','달걀 ','김가루 ','마요네즈 ','파'],
      'cookingTime' : '10',
      'recipeDescription' : [
        '재료 준비','요리 시작','맛있게 먹어'
      ],
      'imageUrl':'https://mblogthumb-phinf.pstatic.net/MjAyMDAyMTBfMTE2/MDAxNTgxMjY2MjgyOTYy.YSvcAD_ZGXllUDzHYseGjvjO2gcGBV4b_t2HRqknxnEg.eXQADo8KA-J1wHtVfXKEEpnutQDbucjF5Dw7eIZ5wrYg.JPEG.lilcomforts/23.jpg?type=w800'
    },
    {
      'menuName': '초콜릿 무스 케이크',
      'rating': '4.9',
      'price': '18.99',
      'mainIngredient': '초콜릿',
      'ingredients': ['달걀노른자','설탕 ','생크림  ','판젤라틴  ','다크초콜릿  ','생크림'],
      'cookingTime' : '10',
      'recipeDescription' : [
        '재료 준비','요리 시작','맛있게 먹어'
      ],
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRX8IC1T6-yTq5bphAARiXfpYBse-Z75A9EAQ&usqp=CAU'
    },
    {
      'menuName': '그릴드 스테이크',
      'rating': '4.8',
      'price': '22.99',
      'mainIngredient': '소고기',
      'ingredients': ['소고기','양파','표고버섯','통마늘','후추','버터'],
      'cookingTime' : '10',
      'recipeDescription' : [
        '재료 준비','요리 시작','맛있게 먹어'
      ],
      'imageUrl': 'https://www.cj.co.kr/images/theKitchen/PHON/0000002333/0000009819/0000002333.jpg'
    },
    {
      'menuName': '감바스',
      'rating': '4.3',
      'price': '16.99',
      'mainIngredient': '새우',
      'ingredients': ['냉동새우 ','소금 ','파슬리 ','페페론치노 ','올리브유 200ml~','깐마늘'],
      'cookingTime' : '10',
      'recipeDescription' : [
        '재료 준비','요리 시작','맛있게 먹어'
      ],
      'imageUrl': 'https://recipe1.ezmember.co.kr/cache/recipe/2020/02/12/4dcbfb78c01860edb1c97e3498c28ee11.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffACACAC),), // 뒤로가기 아이콘
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(///필요에따라 center로감싸기
          children: [
            Text('주어진 재료들로 만들 수 있는 메뉴 추천',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffACACAC))),
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Text(
                  '원하는 조건에 맞게',
                  style: _mainTitleStyle,
                ),
                Text(
                  '필터를 설정 해 보세요',
                  style: _mainTitleStyle,
                ),
              ],
            ),
            SizedBox(
              height: 35.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                direction: Axis.horizontal, // 나열 방향
                alignment: WrapAlignment.start,
                spacing: 15.0, // 버튼 사이의 간격
                runSpacing: 15.0, // 줄 사이의 간격
                children: List.generate(
                  filter.length,
                  (i) => ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSelected[i] = !isSelected[i];
                      });
                    },
                    child: Text(
                      filter[i],
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isSelected[i] ? Color(0xFFFFB01D) : Color(0xfff2f4f7),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  )
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true, // ListView의 높이를 자식 위젯에 맞게 조절
                  itemExtent: 100,
                  itemCount: _recipes.length,
                  itemBuilder: (context, i){
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(recipe: _recipes[i]),
                          ),
                        );
                      },
                      child: Container(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Image.network('assets/bus.jpg', width: 100, height: 100), //asset으로 변경필요
                            ),
                            SizedBox(width: 10.0,),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_recipes[i]['menuName'], style: TextStyle(fontSize:13.0,fontWeight:FontWeight.bold),),
                                  Text(_recipes[i]['mainIngredient'], style: TextStyle(color: Color(0xffACACAC)),),
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/star.svg', width: 10, height: 10,),
                                      SizedBox(width: 5.0,),
                                      Text(_recipes[i]['rating'], style: TextStyle(color: Color(0xffACACAC)),),
                                    ],
                                  ),
                                 SizedBox(height: 5.0,),
                                  Text(_recipes[i]['price'], style: TextStyle(color: Color(0xffFF7B2C)),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
