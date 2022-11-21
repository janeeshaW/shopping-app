import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DotWidget extends StatelessWidget{
  final int activeIndex;
  final int dotIndex;

  DotWidget({required this.activeIndex, required this.dotIndex});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(1.h),
      child: Container(
        height: 2.h,
        width: 2.h,
        decoration: BoxDecoration(
            color: (dotIndex == activeIndex ) ? Colors.black38 : Colors.grey[200],
            shape: BoxShape.circle
        ),
      ),
    );
  }
}