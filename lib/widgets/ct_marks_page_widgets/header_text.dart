import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key,required this.text});

final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      fontFamily: 'font1',
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),);
  }
}