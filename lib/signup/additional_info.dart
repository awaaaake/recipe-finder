// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
// import 'dart:convert';
// import '../home.dart';
// import '../login/kakao_login.dart';
// import '../login/login.dart';
// import '../login/main_view_model..dart';
//
// class AdditionalInfo extends StatefulWidget {
//   const AdditionalInfo({Key? key}) : super(key: key);
//
//   @override
//   State<AdditionalInfo> createState() => _AdditionalInfoState();
// }
//
// class _AdditionalInfoState extends State<AdditionalInfo> {
//   String? baseurl = dotenv.env['API_BASE_URL'];
//   final TextEditingController nicknameController = TextEditingController();
//   String email = '';
//   String imageUrl = '';
//   String phone = '';
//   String Error = '';
//   String fieldsError = '';
//
//   // MainViewModel 객체 생성
//   MainViewModel mainViewModel = MainViewModel(KakaoLogin());
//
//   bool areAllFieldsFilled() {
//     return nicknameController.text.isNotEmpty;
//   }
//
//   String? getErrorMessage(int code) {
//     switch (code) {
//       case 2025:
//         return '닉네임은 2 ~ 20자 사이로 입력해주세요.';
//       default:
//         return '회원가입에 실패하였습니다.';
//     }
//   }
//
//   Future<void> registerUser() async {
//     try {
//       String nickname = nicknameController.text;
//
//       Map<String, String> requestBody = {
//         'imageUrl': imageUrl,
//         'nickname': nickname,
//         'phone': phone,
//       };
//
//       final response = await http.post(
//         Uri.parse('$baseurl/users/sns'),
//         headers: {'Content-Type': 'application/json; charset=UTF-8'},
//         body: json.encode(requestBody),
//       );
//
//       if (response.statusCode == 200) {
//         Map responseData = json.decode(response.body);
//         bool isSuccess = responseData['isSuccess'];
//         int code = responseData['code'];
//         print(code);
//         if (isSuccess || code == 2012) {
//           // 회원가입 성공 처리
//           print('회원가입 성공 or 이미 존재하는 유저');
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => Home()));
//         } else {
//           // API 응답 코드에 따라 에러 메시지 설정
//           setState(() {
//             Error = getErrorMessage(code) ?? '';
//           });
//         }
//       } else {
//         // 서버로부터 200 상태 코드 외의 응답이 왔을 때 처리
//         print('서버 응답 실패: ${response.statusCode}');
//       }
//     } catch (error) {
//       // 예외 처리
//       print('오류 발생: $error');
//     }
//   }
//
//   InputBorder _customBorder(double width, Color color) {
//     return UnderlineInputBorder(
//       borderSide: BorderSide(
//         width: width,
//         color: color,
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     nicknameController.addListener(_resetErrors);
//   }
//
//   Future<void> _loadUserData() async {
//     User? user = await mainViewModel.login();
//     if (user != null) {
//       setState(() {
//         email = user?.kakaoAccount?.email ?? '';
//         imageUrl = user?.kakaoAccount?.profile?.profileImageUrl ?? '';
//         phone = user?.kakaoAccount?.phoneNumber ?? '';
//       });
//     } else {
//       // 로그인 실패 처리
//       setState(() {
//         fieldsError = '로그인 실패. 다시 시도해주세요.';
//       });
//     }
//   }
//
//   // 에러 메시지 초기화 함수
//   void _resetErrors() {
//     setState(() {
//       Error = '';
//       fieldsError = '';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Color(0xffACACAC),
//           ), // 뒤로가기 아이콘
//           onPressed: () {
//             Navigator.of(context).pop(); // 뒤로가기 기능 수행
//           },
//         ),
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(10.0),
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: 2.0,
//             color: Colors.grey.withOpacity(0.5),
//           ),
//         ),
//       ),
//       body: Center(
//         // 아이디 입력 텍스트필드
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   '한 상',
//                   style: TextStyle(
//                       fontSize: 40.0,
//                       fontFamily: 'NanumMyeongjo-ExtraBold',
//                       color: Color(0xFF242760)),
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 SizedBox(
//                   width: 350,
//                   child: TextFormField(
//                     controller: nicknameController,
//                     decoration: InputDecoration(
//                       hintText: '닉네임',
//                       hintStyle: TextStyle(color: Colors.grey),
//                       focusedBorder: _customBorder(2, Color(0xFFFFB01D)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 SizedBox(
//                     width: 350,
//                     child: Text(
//                       email,
//                       style: TextStyle(color: Colors.grey),
//                     )),
//                 SizedBox(height: 20),
//                 // phone 입력 텍스트필드
//                 SizedBox(
//                     width: 350,
//                     child: Text(
//                       phone,
//                       style: TextStyle(color: Colors.grey),
//                     )),
//                 SizedBox(height: 40),
//                 // 계정 생성 버튼
//                 SizedBox(
//                   width: 350,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (areAllFieldsFilled()) {
//                           // 로그인 성공한 경우 사용자 정보를 이용하여 회원가입 진행
//                           registerUser();
//                       } else {
//                         setState(() {
//                           fieldsError = "필수사항을 모두 입력해주세요.";
//                         });
//                       }
//                     },
//                     child: Text(
//                       '계정 생성',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 15.0,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF242760),
//                         elevation: 1.0,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0))),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 5.0,
//                 ),
//                 Text(
//                   Error, // Display the error message here
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
