// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// Future<List<dynamic>> fetchReviews(int rcpId) async {
//   final response = await http
//       .get(Uri.parse('http://15.164.139.103:8080/review/recipe/$rcpId'));
//   if (response.statusCode == 200) {
//     Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
//     bool isSuccess = responseData['isSuccess'];
//     if (isSuccess) {
//       setState(() {
//         reviewAverage = responseData['result']['reviewAverage'];
//         count = responseData['result']['count'];
//       });
//       return responseData['result']['reviews'];
//     } else {
//       return [];
//     }
//   } else {
//     throw Exception('Failed to load reviews');
//   }
// }
//
// Future<void> getMyReviews() async {
//   final storage = FlutterSecureStorage();
//   String? jwtToken = await storage.read(key: 'jwt');
//   if (jwtToken == null) {
//     print('jwt토큰이 존재하지 않습니다');
//     return;
//   }
//
//   final response = await http.get(
//       Uri.parse('http://15.164.139.103:8080/review/users'),
//       headers: {'X-ACCESS-TOKEN': jwtToken});
//   if (response.statusCode == 200) {
//     Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
//     bool isSuccess = responseData['isSuccess'];
//     List<dynamic> reviews = responseData['result']['reviews'];
//     if (isSuccess) {
//       setState(() {
//         for (var review in reviews) {
//           int reviewId = review['reviewId'];
//           myReviews.add(reviewId);
//         }
//       });
//     } else {
//       print('Failed to load user reviews');
//       return;
//     }
//   } else {
//     throw Exception('Failed to load user reviews');
//   }
// }
//
// Future<void> removeMyReviews(int reviewId) async {
//   final storage = FlutterSecureStorage();
//   String? jwtToken = await storage.read(key: 'jwt');
//   if (jwtToken == null) {
//     print('jwt토큰이 존재하지 않습니다');
//     return;
//   }
//
//   final response = await http.delete(
//       Uri.parse('http://15.164.139.103:8080/review/$reviewId'),
//       headers: {'X-ACCESS-TOKEN': jwtToken});
//   if (response.statusCode == 200) {
//     Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
//     bool isSuccess = responseData['isSuccess'];
//     if (isSuccess) {
//       setState(() {
//         reviews = fetchReviews(widget.recipe['rcpId']);
//       });
//     } else {
//       print('Failed to remove user reviews');
//       return;
//     }
//   } else {
//     throw Exception('Failed to remove user reviews');
//   }
// }