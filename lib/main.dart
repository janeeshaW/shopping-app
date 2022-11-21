import 'package:ShoppingApp/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main(){
  runApp(Main());
}

class Main extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        );
      }
    );
  }
}
