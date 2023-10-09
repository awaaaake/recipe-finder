// import 'package:flutter/material.dart';
// import './main.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(Duration(seconds: 2), (){
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       width: size.width,
//       height: size.height,
//       color: Colors.white,
//       child: Center(
//         child: SvgPicture.asset('assets/splash.svg', width: size.width-300,),
//       ),
//     );
//   
// }
