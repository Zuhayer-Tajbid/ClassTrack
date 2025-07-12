import 'package:class_management/colors.dart';
import 'package:class_management/model/student_model.dart';
import 'package:flutter/material.dart';

class AppbarWidgetRoll extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidgetRoll({super.key, required this.student});
  final Student student;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: mainC1,
      title:
          student.name == null
              ? Text(
                '${student.roll}',
                style: TextStyle(
                  fontFamily: 'font1',
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
              : Text(
                '${student.name} - ${student.roll}',
                style: TextStyle(
                  fontFamily: 'font1',
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
