import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import './kakao_login.dart';
import 'package:http/http.dart' as http;

class MainViewModel {
  String? baseurl = dotenv.env['API_BASE_URL'];

  final KakaoLogin _kakaoLogin;
  bool isLoggedIn = false;
  User? user;

  MainViewModel(this._kakaoLogin);

  Future<bool> sendUserInfoToServer() async {
      String? nickname = user?.properties?['nickname'];
      String? profileImageUrl = user?.properties?['profile_image'] ?? '';
      String? phoneNumber = user?.kakaoAccount?.phoneNumber ?? '';

      try {
        var response = await http.post(
          Uri.parse('$baseurl/users/sns'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: {
            'nickname': nickname,
            'profileImageUrl': profileImageUrl,
            'phoneNumber': phoneNumber,
          },
        );

        if (response.statusCode == 200) {
          Map responseData = json.decode(response.body);
          bool isSuccess = responseData['isSuccess'];
          int code = responseData['code'];
          if (isSuccess || code == 2012) {
            print('사용자 정보 전송 성공');
            return true;
          } else {
            return false;
          }
        } else {
          print('사용자 정보 전송 실패 - 응답 코드: ${response.statusCode}');
          return false;
        }
      } catch (error) {
        print('사용자 정보 전송 실패 $error');
        return false;
      }
  }

  Future<bool> login() async {
    isLoggedIn = await _kakaoLogin.login();
    if (isLoggedIn) {
      try {
        // bool userInfoSent = await sendUserInfoToServer();
        return true;
      } catch (error) {
        print('사용자 정보 요청 실패 $error');
        return false;
      }
    } else {
      return false;
    }
  }

  Future logout() async {
    await _kakaoLogin.logout();
    isLoggedIn = false;
    user = null;
  }
}
