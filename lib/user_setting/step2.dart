import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/Recipe/RecipePage.dart';
import 'package:provider/provider.dart';
import '../provider/user_preferences_provider.dart';

class Step2 extends StatefulWidget {
  Step2({Key? key}) : super(key: key);

  @override
  State<Step2> createState() => _Step1State();
}

class _Step1State extends State<Step2> {
  TextEditingController _controller = TextEditingController();

  Map<String, bool> ingredientMap = {
    '우유': false,
    '달걀': false,
    '땅콩': false,
    '새우': false,
    '게': false,
    '밀가루': false,
  }; // 재료와 선택 여부를 저장

  @override
  void initState() {
    super.initState();
    UserPrefer userPrefer = UserPrefer();
    userPrefer.resetUserAllergies();
  }

  void _addToUserAllergies(String keyword, UserPrefer userPrefer) {
    userPrefer.addUserAllergies(keyword);
    print('userAllergies :  ${userPrefer.userAllergies}');
  }

  void _removeUserAllergies(String keyword, UserPrefer userPrefer) {
    userPrefer.removeUserAllergies(keyword);
    print('userAllergies :  ${userPrefer.userAllergies}');
  }

  @override
  Widget build(BuildContext context) {
    UserPrefer userPrefer = Provider.of<UserPrefer>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Step2',
          style: TextStyle(
              color: Color(0xffACACAC),
              fontSize: 15.0,
              fontWeight: FontWeight.w400),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffACACAC),
          ), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.of(context).pop(); // 뒤로가기 기능 수행
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RecipePage(keyword: true,)));
              },
              child: Text(
                '건너뛰기',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400),
              ))
        ],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 2.0,
            color: Color(0xFF242760),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    'assets/allergy.svg', // 이미지 파일 경로 또는 이미지 URL
                    width: 30, // 이미지의 너비
                    height: 30, // 이미지의 높이
                  ),
                ),
                Text(
                  '알러지가 있다면 선택해주세요.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              controller: _controller,
              cursorColor: Colors.grey,
              onSubmitted: (String keyword) {
                _addToUserAllergies(keyword, userPrefer);
                setState(() {
                  ingredientMap[keyword] = true;
                });
                _controller.clear(); // 입력 필드 비우기
              },
              decoration: InputDecoration(
                hintText: '키워드를 입력하세요',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFFFB01D), width: 2.0),
                    // 포커스를 받았을 때의 테두리 색상 설정
                    borderRadius: BorderRadius.circular(30.0)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              '모두 골라주세요',
              style: TextStyle(
                  color: Color(0xffACACAC),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            Container(
              child: SingleChildScrollView(
                  child: Wrap(
                direction: Axis.horizontal,
                // 나열 방향
                alignment: WrapAlignment.start,
                spacing: 10.0,
                // 버튼 사이의 간격
                runSpacing: 15.0,
                // 줄 사이의 간격
                children: List.generate(ingredientMap.length, (index) {
                  String ingredient = ingredientMap.keys.elementAt(index);
                  bool isIngredientSelected = ingredientMap[ingredient] ?? false; // null일 경우 false로 설정

                  return ElevatedButton(
                    onPressed: () {
                      if (isIngredientSelected == false) {
                        _addToUserAllergies(ingredient, userPrefer);
                      } else {
                        _removeUserAllergies(ingredient, userPrefer);
                      }
                      setState(() {
                        ingredientMap[ingredient] = !isIngredientSelected; // 값을 할당할 때 null이 아님을 확인하고 할당
                      });
                    },
                    child: Text(
                      ingredient,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isIngredientSelected
                          ? Color(0xFFFFB01D)
                          : Color(0xfff2f4f7),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  );
                }),
              )),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    if (!ingredientMap.values.every((value) => value == false)) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecipePage(keyword: true)));
                    }
                  },
                  child: SizedBox(
                      width: 500,
                      height: 50,
                      child: Center(
                          child: Text(
                        '다음',
                        style: TextStyle(
                            color:
                            ingredientMap.values.every((value) => value == false)
                                    ? Colors.black
                                    : Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400),
                      ))),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ingredientMap.values.every((value) => value == false) //아무것도 선택되지 않은경우
                          ? Color(0xffdddddd)
                          : Color(0xFF242760),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
