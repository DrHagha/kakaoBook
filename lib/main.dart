import 'package:flutter/material.dart';

import 'KakaoHttpApp.dart';

//kakao에서 책을 가져오는
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: KakaoHttpApp()
    );
  }
}