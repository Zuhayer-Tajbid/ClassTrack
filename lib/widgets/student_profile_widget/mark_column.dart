import 'package:class_management/colors.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/widgets/ct_marks_page_widgets/header_text.dart';
import 'package:flutter/material.dart';

class MarkColumn extends StatelessWidget {
  const MarkColumn({
    super.key,
    required this.headerText,
    required this.text,
    required this.color,
    required this.fontC,
  });
  final Color color;
  final Color fontC;
  final String text;
  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HeaderText(text: headerText),
        const SizedBox(height: 15),
        Card(
          elevation: 3,
          child: Container(
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'font1',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: fontC,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
