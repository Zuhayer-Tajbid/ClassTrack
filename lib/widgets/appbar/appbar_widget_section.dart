import 'package:class_management/colors.dart';
import 'package:class_management/model/class_model.dart';
import 'package:flutter/material.dart';

class AppbarWidgetSection extends StatelessWidget
    implements PreferredSizeWidget {
  const AppbarWidgetSection({super.key, required this.classModel});

  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: mainC1,
      title:
          classModel.section == null
              ? Text(
                '${classModel.subjectName}',
                style: TextStyle(
                  fontFamily: 'font1',
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
              : Text(
                '${classModel.subjectName} (Sec - ${classModel.section})',
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
