import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Recipe/RecipeDetailPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? baseurl = dotenv.env['API_BASE_URL'];
  TextEditingController _controller = TextEditingController();
  List<Map> _recipes = [];
  var filter = ['평점높은 순', '칼로리낮은 순', '단백질높은 순', '재료적은 순'];
  var isSelected;
  bool _showNoResults = false;

  Future<void> _searchRecipes(String keyword) async {
    final response = await http.get(Uri.parse(
        '$baseurl/recipe/search-recipe-of?keyword=$keyword'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['isSuccess'] == true) {
        setState(() {
          _recipes = List<Map>.from(data['result']);
          _showNoResults = false;
        });

        print(List<Map>.from(data['result']));
      } else {
        // 서버에서 isSuccess가 true가 아닌 경우 에러 처리
        setState(() {
          _showNoResults = true;
        });
        throw Exception('Failed to load recipes: ${data['errorMessage']}');
      }
    } else {
      // 서버 응답이 200이 아닌 경우 에러 처리
      throw Exception(
          'Failed to load recipes. Status code: ${response.statusCode}');
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
        automaticallyImplyLeading: false,
        title: Text(
          '레시피 검색',
          style: TextStyle(
              color: Color(0xffACACAC),
              fontSize: 15.0,
              fontWeight: FontWeight.w400),
        ),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              cursorColor: Colors.grey,
              onSubmitted: (String keyword) {
                _searchRecipes(keyword); // 검색어를 이용하여 레시피 검색
              },
              decoration: InputDecoration(
                hintText: '키워드를 입력하세요',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xFFFFB01D),
                      width: 2.0), // 포커스를 받았을 때의 테두리 색상 설정
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey, // 아이콘 색상을 여기서 설정합니다.
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
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
              child: _showNoResults
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/difficult_expression.svg',
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          '앗! 찾으시는 검색 결과가 없네요.',
                          style: TextStyle(
                              color: Color.fromRGBO(148, 148, 148, 1.0)),
                        )
                      ],
                    )
                  : ListView.builder(
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
                                  child: Image.network(
                                      _recipes[i]['attFileNoMk'],
                                      width: 120 ,
                                      height: 120), //asset으로 변경필요
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 180,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style:
                                            TextStyle(color: Color(0xffACACAC)),
                                      ),
                                      Text(
                                        '조리방식 : ${_recipes[i]['rcpWay2']}',
                                        style:
                                            TextStyle(color: Color(0xffACACAC)),
                                      ),
                                      Text(
                                        _recipes[i]['hashTag'] != ''
                                            ? '# ${_recipes[i]['hashTag']}'
                                            : '',
                                        style:
                                            TextStyle(color: Color(0xffACACAC)),
                                      ),
                                      SizedBox(height: 2.0,),
                                      Row(
                                        children: [
                                          Text(_recipes[i]['infoEng'] !='' ? '${_recipes[i]['infoEng']}kcal' : '', style: TextStyle(color: Color(0xffACACAC)),),
                                          SizedBox(width: 2.0,),
                                          Text(_recipes[i]['infoPro'] !='' ? '/${_recipes[i]['infoPro']}g' : '', style:TextStyle(color: Color(0xffACACAC)),),
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
                                            style: TextStyle(
                                                color: Color(0xffACACAC)),
                                          ),
                                        ],
                                      ),
                                      // Text('${_recipes[i]['rcpNaTip'] ?? ''}', style: TextStyle(color: Color(0xffACACAC)),),

                                      // SizedBox(height: 5.0,),
                                      // Text(_recipes[i]['price'] ?? '00원', style: TextStyle(color: Color(0xffFF7B2C)),),
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
