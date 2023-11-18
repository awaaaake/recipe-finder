import 'package:flutter/material.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image(image:AssetImage('assets/logo.jpg'), width: 150),
                    Text('아,', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, fontFamily: 'NanumMyeongjo-ExtraBold'),),
                    SizedBox(
                      height: 8.0, // 간격을 조절하려면 이 값을 조정하세요
                    ),
                    Text('오늘은', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, fontFamily: 'NanumMyeongjo-ExtraBold'),),
                    SizedBox(
                      height: 8.0, // 간격을 조절하려면 이 값을 조정하세요
                    ),
                    Text('뭐먹지?', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, fontFamily: 'NanumMyeongjo-ExtraBold'),),
                  ],
                ),
                SizedBox(
                  height: 80.0,
                ),
                ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/home');
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
              ],
            ),
          ),
        )
      );
  }
}
