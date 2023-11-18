//소셜로그인 클래스
//기능은 로그인하고 로그아웃 2개에서
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLogin {
  String? baseurl = dotenv.env['API_BASE_URL'];

  final storage = FlutterSecureStorage();

  Future<bool> login() async {
    //카카오로그인 로직
    try {
      bool isInstalled = await isKakaoTalkInstalled(); //카카오톡 설치 여부 확인
      if (isInstalled) {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk(); //카카오톡으로 로그인
          print('카카오톡으로 로그인 성공 ${token.accessToken}');
          bool result = await _sendTokenToServer(token.accessToken);
          return result; //_send~의 결과값을 바로 반환
        } catch (e) {
          //뒤로가기 등 카카오 오륵인이 안됐을경우
          print('카카오톡으로 로그인 실패 $e');
          return false;
        }
      } else {
        //카카오톡 설치하지 않았을 시
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount(); //카카오 계정으로 로그인 유도
          print('카카오계정으로 로그인 성공 ${token.accessToken}');
          bool result = await _sendTokenToServer(token.accessToken);
          return result;
        } catch (e) {
          //뒤로가기 등 카카오 로그인이 안됐을경우
          print('카카오계정으로 로그인 실패 $e');
          return false;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> _sendTokenToServer(String accessToken) async {
    try {
      String apiUrl = '$baseurl/oauth/kakao';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, String> body = {
        'access_token': accessToken,
      };
      String jsonBody = json.encode(body);

      var response = await http.post(Uri.parse(apiUrl), headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        Map responseData = json.decode(response.body);
        bool isSuccess = responseData['isSuccess'];
        if (isSuccess) {
          // 로그인 성공 처리
          print('로그인 성공');
          String jwtToken = responseData['result']['jwt']; // API 응답에서 JWT 토큰 추출

          // storage에 토큰 저장
          await storage.write(key: 'jwt', value: jwtToken);

          print('jwtToken : ${jwtToken}');

          return true;
        } else {
          // 로그인 실패 처리
          print('로그인 실패: ${responseData['message']}');
          return false;
        }
      } else {
        // 서버 오류 처리
        print(json.decode(response.body));
        print('서버 오류: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('토큰 전송 중 오류 발생 $e');
      return false;
    }
  }

}