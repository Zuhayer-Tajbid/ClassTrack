import 'package:class_management/colors.dart';
import 'package:flutter/material.dart';

class SubjectField extends StatelessWidget {
  const SubjectField({super.key, required this.subjectName});

  final TextEditingController subjectName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          controller: subjectName,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey, width: 3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black, width: 3),
            ),
            filled: true,

            hintText: 'Enter subject name',
            hintStyle: TextStyle(fontSize: 23),
            labelText: 'Subject name',
            labelStyle: TextStyle(color: Colors.black),
          ),
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'font1',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
