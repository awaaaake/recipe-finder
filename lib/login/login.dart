import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../step1.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/ingredients.png', width: 200, height: 200,),
              SizedBox(
                height: 30.0,
              ),
              Text('환영합니다', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),),
              SizedBox(
                height: 5.0, // 간격을 조절하려면 이 값을 조정하세요
              ),
              Text('로그인 하거나 회원가입 하세요', style: TextStyle(color: Color(0xffACACAC), fontWeight: FontWeight.w400),),
              SizedBox(
                height: 50.0,
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Step1()));
                  },
                  child: Container(
                      width: 350,
                      height: 50,
                      child: Center(
                          child: Text('시작하기', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w400),))
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF242760),
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      )
                  ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('or', style: TextStyle(color: Color(0xffACACAC)),),
                  ),
                  Expanded(child: Divider(),)
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                  onPressed: (){
                  },
                  child: Container(
                    width: 350,
                    height: 50,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/btn_naver.svg', width: 35, height: 35,),
                          Text('네이버로 시작하기', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w400),),
                        ],
                  ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF03C75A),
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                    )
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                  onPressed: (){
                  },
                  child: Container(
                    width: 350,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/btn_kakao.svg', width: 35, height: 35,),
                        Text('카카오로 시작하기', style: TextStyle(color: Color(0xff191919), fontSize: 15.0, fontWeight: FontWeight.w400),),
                      ],
                    ),
                  ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFEE500),
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  )
                ),
              ),
            ],
          ),
        )
      );
  }
}
