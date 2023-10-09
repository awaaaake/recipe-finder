import 'package:flutter/material.dart';
import './step2.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Step1 extends StatefulWidget {
  Step1({Key? key}) : super(key: key);

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  List<bool> isSelected=[];
  var menus = ['칼륨 듬뿍 고구마죽', '단호박 케일밥', '오색지라시 스시', '영양밥', '절편 떡국', '부추 콩가루 찜', '시금치 무침', '버섯 두부 찌개', '가지 토마토 덮밥', '콩국수', '해물 파전', '떡볶이'];

  @override
  void initState() {
    super.initState();
    isSelected = List<bool>.filled(menus.length, false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step1', style: TextStyle(color: Color(0xffACACAC), fontSize: 15.0, fontWeight: FontWeight.w400),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffACACAC),), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.of(context).pop(); // 뒤로가기 기능 수행
          },
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Step2()));
            },
            child: Text('건너뛰기', style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400),))
        ],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 2.0,
                color: Color(0xFF242760),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 2.0,
                color: Colors.grey.withOpacity(0.5),
              )
            ],
          )
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
                      'assets/bowl.svg', // 이미지 파일 경로 또는 이미지 URL
                      width: 30, // 이미지의 너비
                      height: 30, // 이미지의 높이
                    ),
                  ),
                  Text('어떤 메뉴를 좋아하시나요?', style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w400),),
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
                          menus.length,
                              (index) => ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isSelected[index] = !isSelected[index];
                              });
                            },
                            child: Text(
                              menus[index],
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Step2()));
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
