import 'package:flutter/material.dart';
import 'package:instagram/login/login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import './style.dart' as style;
import './signup/additional_info.dart';
import 'login/start.dart';
import './Recipe/RecipeDetailPage.dart';
import 'Recipe/RecipePage.dart';
import './review/Review.dart';
import './home.dart';
import 'tab/Ingredient_scanner.dart';
import './user_setting/step1.dart';
import './user_setting/step2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './tab/menu.dart';
import 'object_detection/views/HomeScreen.dart';
import 'provider/user_preferences_provider.dart';
import'signup/signup.dart';
import './tab/search.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var theme; //변수 중복 문제

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  String? _nativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];
  String? _javaScriptAppKey = dotenv.env['KAKAO_JAVASCRIPT_APP_KEY'];

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: _nativeAppKey,
    javaScriptAppKey: _javaScriptAppKey,
  );

  runApp(
      ChangeNotifierProvider(
        create: (context) => UserPrefer(), // UserPrefer 객체를 제공
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: style.theme,
          initialRoute: '/',
          routes: {
            '/': (context) => MyApp(),
            '/login': (context) => Login(),
            '/home' : (context) => Home(),
            '/menu': (context) => Menu(),
          },
        ),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data =[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Login(),
    );
  }
}

