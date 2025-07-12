import 'package:flutter/material.dart';

class CtMarksField extends StatelessWidget {
  const CtMarksField({super.key, required this.ct});

  final TextEditingController ct;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 43,
      child: TextField(
        controller: ct,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
