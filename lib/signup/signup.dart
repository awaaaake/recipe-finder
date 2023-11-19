import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../login/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? baseurl = dotenv.env['API_BASE_URL'];

  // 유저의 아이디와 비밀번호의 정보 저장
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordVerifyingController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  //에러 메시지
  String Error = '';
  // String validationError = '';
  // String emailError = '';
  // String phoneError = '';
  // String nicknameError = '';
  String fieldsError = '';

  bool areAllFieldsFilled() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordVerifyingController.text.isNotEmpty &&
        nicknameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty;
  }

  String? getErrorMessage(int code) {
    switch (code) {
      case 2015:
        return '중복 이메일입니다.';
      case 2017:
        return '이미 사용 중인 이메일입니다.';
      case 2020:
        return '이미 사용 중인 전화번호입니다.';
      case 2024:
        return '이미 사용 중인 닉네임입니다.';
      default:
        return '서버 오류가 발생했습니다.';
    }
  }

  // Future<void> registerUser() async {
  Future<void> registerUser() async {
    try {
      String email = emailController.text;
      String password = passwordVerifyingController.text;
      String imageUrl = imageUrlController.text;
      String nickname = nicknameController.text;
      String phone = phoneController.text;

      Map<String, String> requestBody = {
        'email': email,
        'password': password,
        'imageUrl': imageUrl,
        'nickname': nickname,
        'phone': phone,
      };

      final response = await http.post(
        Uri.parse('$baseurl/users'), // API 엔드포인트를 입력하세요
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        Map responseData = json.decode(response.body);
        bool isSuccess = responseData['isSuccess'];
        int code = responseData['code'];
        print(code);
        if (isSuccess) {
          // 회원가입 성공 처리
          print('회원가입 성공');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {
          // API 응답 코드에 따라 에러 메시지 설정
          setState(() {
            Error = getErrorMessage(code) ?? '';
          });
        }
      } else {
        // 서버로부터 200 상태 코드 외의 응답이 왔을 때 처리
        print('서버 응답 실패: ${response.statusCode}');
      }
    } catch (error) {
      // 예외 처리
      print('오류 발생: $error');
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

  String? checkPassword() {
    if (passwordVerifyingController.text.isEmpty) return null;
    return passwordVerifyingController.text == passwordController.text ? null : "비밀번호가 일치하지 않습니다.";
  }

  @override
  void initState() {
    super.initState();
    // 각 입력 필드의 값이 변경될 때마다 에러 메시지 초기화
    nicknameController.addListener(_resetErrors);
    emailController.addListener(_resetErrors);
    passwordController.addListener(_resetErrors);
    passwordVerifyingController.addListener(_resetErrors);
    phoneController.addListener(_resetErrors);
  }

  // 에러 메시지 초기화 함수
  void _resetErrors() {
    setState(() {
      Error = '';
      fieldsError = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xffACACAC),), // 뒤로가기 아이콘
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
        body: Center(
          // 아이디 입력 텍스트필드
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '한 상',
                    style: TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'NanumMyeongjo-ExtraBold',
                        color: Color(0xFF242760)
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: nicknameController,
                      decoration: InputDecoration(
                        hintText: '닉네임',
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: _customBorder(2, Color(0xFFFFB01D)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: '아이디를 입력해주세요',
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: _customBorder(2, Color(0xFFFFB01D)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // 비밀번호 입력 텍스트필드
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '비밀번호를 입력해주세요',
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: _customBorder(2, Color(0xFFFFB01D)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // 비밀번호 재확인 텍스트필드
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: passwordVerifyingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '비밀번호를 다시 입력해주세요',
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: _customBorder(2, Color(0xFFFFB01D)),
                        errorBorder: _customBorder(2, Colors.red),
                        errorText: checkPassword(), // 이 부분을 추가해주어야 합니다.
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // phone 입력 텍스트필드
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: '전화번호',
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: _customBorder(2, Color(0xFFFFB01D)),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // 계정 생성 버튼
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        if(areAllFieldsFilled()) {
                          registerUser();
                          //회원가입을 완료하면 자동으로 로그인?
                        } else {
                          setState(() {
                            fieldsError = "필수사항을 모두 입력해주세요.";
                          });
                        }
                      },
                      child: Text(
                        '계정 생성',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF242760),
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    Error, // Display the error message here
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    fieldsError, // Display the error message here
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
