import 'package:flutter/material.dart';
import './step2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../provider/user_preferences_provider.dart';

class Step1 extends StatefulWidget {
  Step1({Key? key}) : super(key: key);

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserPrefer userPrefer = UserPrefer();// UserPrefer 클래스의 생성자를 호출하여 인스턴스 생성
    userPrefer.resetUserLikes();
  }

  // 사용자가 입력한 키워드를 UserPrefer Provider의 _userLikes 리스트에 추가하는 함수
  void _addToUserLikes(String keyword, UserPrefer userPrefer) {
    userPrefer.addUserLikes(keyword);
    print('userLikes : ${userPrefer.userLikes}');
  }

  @override
  Widget build(BuildContext context) {
    UserPrefer userPrefer = Provider.of<UserPrefer>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Step1', style: TextStyle(color: Color(0xffACACAC), fontSize: 15.0, fontWeight: FontWeight.w400),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffACACAC),), // 뒤로가기 아이콘
          onPressed: () {
            userPrefer.resetUserLikes();
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
                  Text('좋아하는 식자재를 입력해주세요!', style: TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w400),),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: _controller,
                cursorColor: Colors.grey,
                onSubmitted: (String keyword) {
                  _addToUserLikes(keyword, userPrefer);
                  _controller.clear(); // 입력 필드 비우기
                },
                decoration: InputDecoration(
                  hintText: '키워드를 입력하세요',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFB01D), width: 2.0 ), // 포커스를 받았을 때의 테두리 색상 설정
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text('입력한 식자재를 기반으로 맞춤 레시피를 추천해 드립니다.', style: TextStyle(color: Color(0xffACACAC), fontSize: 15.0, fontWeight: FontWeight.w400),),
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
                          userPrefer.userLikes.length,
                              (index) => ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              userPrefer.userLikes[index],
                              style: TextStyle(
                                  color: Colors.black,),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFB01D),
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
                        if(userPrefer.userLikes.length != 0) {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Step2()));
                        }
                      },
                    child: SizedBox(
                        width: 500,
                        height: 50,
                        child: Center(
                            child: Text('다음', style: TextStyle(
                                color: userPrefer.userLikes.length == 0 ? Colors.black: Colors.white,
                                fontSize: 15.0, fontWeight: FontWeight.w400),))
                    ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userPrefer.userLikes.length == 0 ? Color(0xffdddddd): Color(0xFF242760),
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
