import 'package:class_management/colors.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NumberOfStudentButton extends StatelessWidget {
  const NumberOfStudentButton({
    super.key,
    required this.is180,
    required this.number,
    required this.is180func,
    required this.onIsNumSelected,
    required this.isNumSelected,
  });

  final bool is180;
  final int number;
  final void Function(int number) is180func;
  final void Function(int number) onIsNumSelected;
  final bool isNumSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        is180func(number);
        onIsNumSelected(number);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isNumSelected ? mainC1 : bodyC1,
        fixedSize: Size(80, 80),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          fontFamily: 'font1',
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: isNumSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
