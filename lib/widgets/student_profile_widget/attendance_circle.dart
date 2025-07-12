import 'package:flutter/material.dart';

class AttendanceCircle extends StatelessWidget {
  const AttendanceCircle({
    super.key,
    required this.text,
    required this.color,
    required this.fontC,
  });
  final String text;
  final Color color;
  final Color fontC;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'font1',
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: fontC,
      ),
      textAlign: TextAlign.center,
    );
  }
}
