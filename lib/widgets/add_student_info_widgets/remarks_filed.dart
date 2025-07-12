import 'package:flutter/material.dart';

class RemarksFiled extends StatelessWidget {
  const RemarksFiled({super.key, required this.remarkController});

  final TextEditingController remarkController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: remarkController,
        minLines: 10,
        maxLines: null,
        style: TextStyle(
          fontFamily: 'font1',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: 'Write remarks',
          labelText: 'Remarks',
          alignLabelWithHint: true,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          labelStyle: TextStyle(fontSize: 20, color: Colors.black),
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(color: Colors.black, width: 3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(color: Colors.grey, width: 3),
          ),
        ),
      ),
    );
  }
}
