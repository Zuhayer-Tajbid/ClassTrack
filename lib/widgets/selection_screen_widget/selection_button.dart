import 'package:class_management/colors.dart';
import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  final String text;
  final Widget Function() destinationBuilder;

  const SelectionButton({
    super.key,
    required this.text,
    required this.destinationBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: mainC2,
        fixedSize: Size(270, 90),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationBuilder()),
        );
      },
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'font1',
          fontSize: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
