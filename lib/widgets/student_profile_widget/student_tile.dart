import 'package:class_management/colors.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/screens/student_page.dart';
import 'package:flutter/material.dart';

class StudentTile extends StatelessWidget {
  const StudentTile({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(15),
          color: mainC1,
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentPage(student: student),
              ),
            );
          },
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 30, color: mainC2),
          ),
          title:
              (student.name == null || student.name!.trim().isEmpty)
                  ? Text(
                    '${student.roll}',
                    style: TextStyle(
                      fontFamily: 'font1',
                      fontSize: 27,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  : Text(
                    '${student.name} - ${student.roll}',
                    style: TextStyle(
                      fontFamily: 'font1',
                      fontSize: 27,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }
}
