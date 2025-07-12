import 'package:class_management/colors.dart';
import 'package:flutter/material.dart';

class RemarkBox extends StatelessWidget {
  const RemarkBox({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      width: 330,
      decoration: BoxDecoration(
        color: bodyC1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'font1',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
