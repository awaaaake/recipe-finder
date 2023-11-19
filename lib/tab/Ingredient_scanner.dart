import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _Step1State();
}

class _Step1State extends State<Scanner> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '사진을 업로드 해 주세요',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 100.0,
              ),
              Row(
                //자식들은 row내에서 한번더 가운데 절렬
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {

                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/camera.svg',
                          width: 100,
                          height: 100,
                        ),
                        Text('촬영', style: TextStyle(fontSize: 15.0),),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70.0,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> ()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/gallery.svg',
                          width: 100,
                          height: 100,
                        ),
                        Text('업로드', style: TextStyle(fontSize: 15.0),),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
    );
  }
}
