import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tflite_v2/tflite_v2.dart';

import '../Recipe/RecipePage.dart';
import '../provider/user_preferences_provider.dart';

class Classifier extends StatefulWidget {
  Classifier({Key? key}) : super(key: key);

  @override
  State<Classifier> createState() => _ClassifierState();
}

class _ClassifierState extends State<Classifier> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  List<Map<dynamic, dynamic>> _recognitions = [];
  var v = "";

  // var dataList = [];
  @override
  void initState() {
    super.initState();
    print('_recognitions : $_recognitions');
    UserPrefer userPrefer = UserPrefer();
    userPrefer.resetUserLikes();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  void _addToUserLikes(UserPrefer userPrefer) {
    for (var recognition in _recognitions) {
      if (recognition.containsKey('label')) {
        String label = recognition['label'];
        userPrefer.addUserLikes(label);
      }
    }
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model/model_unquant.tflite",
      labels: "assets/model/labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _captureImage(UserPrefer userPrefer) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      await detectimage(file!);
      _addToUserLikes(userPrefer);
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future detectimage(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.3,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      if (recognitions != null && recognitions.isNotEmpty) {
        v = "";
        for (var result in recognitions) {
          if (result.containsKey('label')) {
            if (v.isNotEmpty) {
              v += ", "; // 결과를 쉼표로 구분
            }
            if (result['confidence'] >= 0.8) {
              String label = result['label'];
              // 정규 표현식을 사용하여 숫자를 제외한 텍스트만 추출
              String labelText = label.replaceAll(RegExp(r'\d+'), '').trim();
              v += labelText;
              print('result : $result');
              setState(() {
                _recognitions.add({'label': labelText, 'confidence': result['confidence']});
              });
            }
          } else {
            v += "라벨을 찾지 못했습니다!";
          }
        }
      } else {
        v = "결과값이 없습니다";
      }
    });

    print("//////////////////////////////////////////////////");
    print(_recognitions);
    print("//////////////////////////////////////////////////");
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  @override
  Widget build(BuildContext context) {
    UserPrefer userPrefer = Provider.of<UserPrefer>(context);

    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '식자재 인식',
          style: TextStyle(
              color: Color(0xffACACAC),
              fontSize: 15.0,
              fontWeight: FontWeight.w400),
        ),
        actions: _recognitions.isNotEmpty
            ? [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {
                _recognitions = [];
                v = "";
                _image = null;
              });
            },
          ),
        ] : [],
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Image.file(
                File(_image!.path),
                height: MediaQuery.of(context).size.height - 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )
            else
              Text('이미지를 선택해주세요'),
            SizedBox(height: 20),
            Text('📌  $v', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: (_recognitions.isNotEmpty)
                  ? ElevatedButton(
                      onPressed: () {
                        print('userPrefer.userLikes : ${userPrefer.userLikes}');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => RecipePage(keyword: true)));
                      },
                      child: Text(
                        '맞춤형 레시피 확인하기',
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
                    )
                  : ElevatedButton(
                      onPressed: (){
                        _captureImage(userPrefer);
                      },
                      child: Text(
                        '식자재 인식',
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
          ],
        ),
      ),
    );
  }
}
