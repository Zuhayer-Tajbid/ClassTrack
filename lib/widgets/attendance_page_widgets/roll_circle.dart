import 'package:class_management/colors.dart';
import 'package:class_management/model/student_model.dart';
import 'package:flutter/material.dart';

class RollCircle extends StatelessWidget {
  const RollCircle({super.key, required this.student, required this.fontSize});
  final double fontSize;

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: bodyC1, shape: BoxShape.circle),
      //padding: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            student.roll.toString(),
            style: TextStyle(
              fontFamily: 'font1',
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
