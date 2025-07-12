import 'package:class_management/colors.dart';
import 'package:class_management/model/student_model.dart';
import 'package:flutter/material.dart';

class NameBar extends StatelessWidget {
  const NameBar({
    super.key,
    required this.student,
    required this.width,
    required this.height,
    required this.fontSize,
  });
  final double width;
  final double height;
  final double fontSize;

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: mainC2,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          student.name ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'font1',
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
