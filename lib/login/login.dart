import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON Encode, Decode를 위한 패키지
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // flutter_secure_storage 패키지
import './kakao_login.dart';
import './main_view_model..dart';
import '../home.dart';
import '../signup/signup.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? baseurl = dotenv.env['API_BASE_URL'];

  //viewmodel 객체 생성
  final viewModel = MainViewModel(KakaoLogin()); //카카오 로그인 객체 전달

  // 아이디와 비밀번호 정보
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final storage = FlutterSecureStorage();
  String errorMessage = '';

  Future<void> login() async {
    try {
      String email = userIdController.text;
      String password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        print('이메일과 비밀번호를 모두 입력해주세요.');
        return;
      }

      Map<String, String> requestBody = {
        'email': email,
        'password': password,
      };

      final response = await http.post(
        Uri.parse('$baseurl/users/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestBody), // Map을 JSON 문자열로 변환하여 전송
      );

      if (response.statusCode == 200) {
        Map responseData = json.decode(response.body);
        bool isSuccess = responseData['isSuccess'];
        if (isSuccess) {
          // 로그인 성공 처리
          print('로그인 성공');
          String jwtToken = responseData['result']['jwt']; // API 응답에서 JWT 토큰 추출
          String nickname = responseData['result']['nickname'];
          //storage에 토큰 및 사용자 정보 저장
          await storage.write(key: 'jwt', value: jwtToken);
          await storage.write(key: 'nickname', value: nickname);

          print('jwtToken : ${jwtToken}');
          print('nickname : ${nickname}');

          //메인 페이지로 이동
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          // 로그인 실패 처리
          setState(() {
            errorMessage = '이메일 혹은 비밀번호가 일치하지 않습니다';
          });
          print('로그인 실패: ${responseData['message']}');
        }
      } else {
        // 서버 오류 처리
        print('서버 오류: ${response.statusCode}');
      }
    } catch (error) {
      // 예외가 발생했을 때 처리
      print('에러 발생: $error');
    }
  }

  InputBorder _customBorder(double width, Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: color,
      ),
    );
  }

  // String? checkErrorText() {
  //   if (userIdController.text.isEmpty) return null;
  //   return userIdController.text.length >= 6 ? null : "6글자 이상 입력해주세요.";
  // }

  @override
  void initState() {
    super.initState();
    // userIdController의 값이 변경될 때마다 에러 메시지 초기화
    userIdController.addListener(_resetErrorMessage);
    // passwordController의 값이 변경될 때마다 에러 메시지 초기화
    passwordController.addListener(_resetErrorMessage);
  }

  // 에러 메시지 초기화 함수
  void _resetErrorMessage() {
    setState(() {
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xffACACAC),
            ), // 뒤로가기 아이콘
            onPressed: () {
              Navigator.of(context).pop(); // 뒤로가기 기능 수행
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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/logo.jpg',
                    //   width: 150,
                    //   height: 150,
                    // ),
                    Text(
                      '한 상',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'NanumMyeongjo-ExtraBold',
                        color: Color(0xFF242760)
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    // ID 입력 텍스트필드
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: userIdController,
                        decoration: InputDecoration(
                          labelText: 'email',
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: _customBorder(2, Color(0xFFFFB01D)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // 비밀번호 입력 필드
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'password',
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: _customBorder(2, Color(0xFFFFB01D)),
                        ),
                      ),
                    ),
                    Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: login,
                        child: Text(
                          '로그인',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF242760),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool loginSuccess = await viewModel.login();
                          if(loginSuccess) {
                            Navigator.pushNamed(context, '/home');
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('에러'),
                                  content: Text('카카오 로그인에 실패하였습니다.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('확인'),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // 경고창 닫기
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/btn_kakao.svg',
                                width: 35,
                                height: 35,
                              ),
                              Text(
                                '카카오로 로그인',
                                style: TextStyle(
                                    color: Color(0xff191919),
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFEE500),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('회원이 아니신가요?',
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(
                              width: 3.0,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15.0,
                              color: Colors.grey,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            )));
  }
}
