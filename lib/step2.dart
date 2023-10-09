import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './home.dart';

class Step2 extends StatefulWidget {
  Step2({Key? key}) : super(key: key);

  @override
  State<Step2> createState() => _Step1State();
}

class _Step1State extends State<Step2> {
  List<bool> isSelected=[];
  var ingredients = ['고구마', '단호박', '쌀', '콩가루', '부추', '떡국떡', '감자', '당근', '고추장', '된장', '고등어', '갈치', '새우', '오이', '호박', '양파', '대파', '마늘', '깻잎'];
  @override
  void initState() {
    super.initState();
    isSelected = List<bool>.filled(ingredients.length, false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step2', style: TextStyle(color: Color(0xffACACAC), fontSize: 15.0, fontWeight: FontWeight.w400),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffACACAC),), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.of(context).pop(); // 뒤로가기 기능 수행
          },
        ),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
              },
              child: Text('건너뛰기', style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400),))
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
                    'assets/fooditems.svg', // 이미지 파일 경로 또는 이미지 URL
                    width: 30, // 이미지의 너비
                    height: 30, // 이미지의 높이
                  ),
                ),
                Text('어떤 재료를 가지고 계신가요?', style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w400),),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Text('모두 골라주세요', style: TextStyle(color: Color(0xffACACAC), fontSize: 15.0, fontWeight: FontWeight.w400),),
            SizedBox(height: 20),
            Container(
              // height: MediaQuery.of(context).size.height*0.6,// 앱스크린 높이의 70%
              child: SingleChildScrollView(
                  child: Wrap(
                    direction: Axis.horizontal, // 나열 방향
                    alignment: WrapAlignment.start,
                    spacing: 10.0, // 버튼 사이의 간격
                    runSpacing: 15.0, // 줄 사이의 간격
                    children: List.generate(
                      ingredients.length,
                          (index) => ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                          });
                        },
                        child: Text(
                          ingredients[index],
                          style: TextStyle(
                            color: Colors.black,),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected[index]
                              ? Color(0xFFFFB01D)
                              : Color(0xfff2f4f7),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                      ),
                    ),
                  )
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
                  },
                  child: SizedBox(
                      width: 500,
                      height: 50,
                      child: Center(
                          child: Text('다음', style: TextStyle(
                              color: isSelected.every((element) => element == false)
                                  ? Colors.black: Colors.white,
                              fontSize: 15.0, fontWeight: FontWeight.w400),))
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected.every((element) => element == false)//아무것도 선택되지 않은경우
                          ? Color(0xffdddddd)
                          : Color(0xFF242760),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
