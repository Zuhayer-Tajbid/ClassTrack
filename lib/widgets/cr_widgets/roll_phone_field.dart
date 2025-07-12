import 'package:flutter/material.dart';

class RollPhoneField extends StatelessWidget {
  const RollPhoneField({
    super.key,
    required this.controller,
    required this.text,
  });
  final TextEditingController controller;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          height: 60,

          child: TextField(
            style: TextStyle(fontSize: 20),
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: text,

              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(19),

              labelStyle: TextStyle(color: Colors.black, fontSize: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey, width: 3),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.black, width: 3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
