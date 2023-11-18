import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './RecipeDetailPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../home.dart';
import '../provider/user_preferences_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecipePage extends StatefulWidget {
  final bool keyword;

  RecipePage({required this.keyword});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  String? baseurl = dotenv.env['API_BASE_URL'];

  final _mainTitleStyle = TextStyle(
      fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black);
  var filter = ['평점높은 순', '칼로리낮은 순', '단백질높은 순', '재료적은 순'];
  List<dynamic> _recipes = [];
  var isSelected;
  List<String> user_allergies = [];
  List<String> user_likes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var userPrefer = Provider.of<UserPrefer>(context);
    user_allergies = userPrefer.userAllergies;
    user_likes = userPrefer.userLikes;
    print('유저가 좋아하는것 실헝하는것  : ${user_allergies}, ${user_likes}');

    if(widget.keyword) {
      keyword_searchRecipes();
    } else {
      review_searchRecipes();
    }
  }

  Future<void> keyword_searchRecipes() async {
    Map<String, List<String>> requestBody = {
      'user_allergies': user_allergies,
      'user_likes': user_likes,
    };

    final response = await http.post(
      Uri.parse('$baseurl/recommend-recipe'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      List<dynamic> dataList = jsonDecode(utf8.decode(response.bodyBytes));
      if (dataList.isNotEmpty && dataList[0] is Map<String, dynamic>) {
        setState(() {
          _recipes = dataList.cast<Map<String, dynamic>>(); // 리스트를 맵으로 변환
        });
      } else {
        throw Exception('Invalid API response format');
      }
    } else {
      throw Exception(
          'Failed to load recipes. Status code: ${response.statusCode}');
    }
  }

  Future<void> review_searchRecipes() async {
    final storage = FlutterSecureStorage();
    String? jwtToken = await storage.read(key: 'jwt');
    if (jwtToken == null) {
      print('jwt토큰이 존재하지 않습니다');
      return;
    }

    final response = await http.post(
        Uri.parse('$baseurl/recommend-user'),
        headers: {'X-ACCESS-TOKEN': jwtToken});

    if (response.statusCode == 200) {
      Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print(responseData);
      bool isSuccess = responseData['isSuccess'];
      if (isSuccess) {
        setState(() {
          _recipes = responseData['result'];
        });
      } else {
        print('Failed to load review_recipes.');
        return;
      }
    } else {
      throw Exception('Failed to load review_recipes. Status code: ${response.statusCode}');
    }
  }

  // 재료의 개수를 계산하는 함수
  int calculateIngredientCount(String ingredients) {
    List<String> ingredientList =
        ingredients.split(','); // 재료들을 콤마와 공백을 기준으로 분리
    return ingredientList.length; // 재료의 개수 반환
  }

  void filterRecipes() {
    if (isSelected == 0) {
      _recipes.sort((a, b) =>
          b['reviewAverge'].compareTo(a['reviewAverge']));
    }

    if (isSelected == 1) {
      _recipes.sort((a, b) =>
          double.parse(a['infoEng']).compareTo(double.parse(b['infoEng'])));
    }

    if (isSelected == 2) {
      _recipes.sort((a, b) =>
          double.parse(b['infoPro']).compareTo(double.parse(a['infoPro'])));
    }

    if (isSelected == 3) {
      _recipes.sort((a, b) =>
          calculateIngredientCount(a['rcpPartsDtls']).compareTo(calculateIngredientCount(b['rcpPartsDtls'])));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffACACAC),
          ), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.pushNamed(context, '/home');
            // Navigator.popUntil(context, (route) {
            //   // Step1Widget 화면까지 돌아가기
            //   return route.settings.name == '/menu';
            // });
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
        child: Column(
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.horizontal,
                  // 나열 방향
                  alignment: WrapAlignment.start,
                  spacing: 15.0,
                  // 버튼 사이의 간격
                  runSpacing: 15.0,
                  // 줄 사이의 간격
                  children: List.generate(
                      filter.length,
                      (i) => ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isSelected = i;
                              });
                              filterRecipes();
                            },
                            child: Text(
                              filter[i],
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected == i
                                  ? Color(0xFFFFB01D)
                                  : Color(0xfff2f4f7),
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                          )),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true, // ListView의 높이를 자식 위젯에 맞게 조절
                  itemExtent: 130,
                  itemCount: _recipes.length,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailPage(recipe: _recipes[i]),
                          ),
                        );
                      },
                      child: Container(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Image.network(_recipes[i]['attFileNoMk'],
                                  width: 120, height: 120), //asset으로 변경필요
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _recipes[i]['rcpNm'] ?? '',
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                  ),
                                  Text(
                                    '재료 : ${calculateIngredientCount(_recipes[i]['rcpPartsDtls'])}개',
                                    style: TextStyle(color: Color(0xffACACAC)),
                                  ),
                                  Text(
                                    '조리방식 : ${_recipes[i]['rcpWay2']}',
                                    style: TextStyle(color: Color(0xffACACAC)),
                                  ),
                                  Text(
                                    _recipes[i]['hashTag'] != ''
                                        ? '# ${_recipes[i]['hashTag']}'
                                        : '',
                                    style: TextStyle(color: Color(0xffACACAC)),
                                  ),
                                  SizedBox(
                                    height: 2.0,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _recipes[i]['infoEng'] != ''
                                            ? '${_recipes[i]['infoEng']}kcal'
                                            : '',
                                        style:
                                            TextStyle(color: Color(0xffACACAC)),
                                      ),
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                      Text(
                                        _recipes[i]['infoPro'] != ''
                                            ? '/${_recipes[i]['infoPro']}g'
                                            : '',
                                        style:
                                            TextStyle(color: Color(0xffACACAC)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/star.svg',
                                        width: 10,
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        _recipes[i]['reviewAverge'].toString(),
                                        style:
                                            TextStyle(color: Color(0xffACACAC)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
