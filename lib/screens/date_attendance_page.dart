import 'dart:io';

import 'package:class_management/colors.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/widgets/appbar/appbar_widget_section.dart';
import 'package:class_management/widgets/attendance_page_widgets/name_bar.dart';
import 'package:class_management/widgets/attendance_page_widgets/roll_circle.dart';
import 'package:class_management/widgets/common/notification.dart';
import 'package:class_management/widgets/common/save_button_style.dart';
import 'package:class_management/widgets/common/save_text.dart';
import 'package:class_management/widgets/ct_marks_page_widgets/header_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateAttendancePage extends StatefulWidget {
  const DateAttendancePage({
    super.key,
    required this.classModel,
    required this.date,
    required this.studentList,
  });
  final ClassModel classModel;
  final String date;
  final List<Student> studentList;

  @override
  State<DateAttendancePage> createState() => _DateAttendancePageState();
}

class _DateAttendancePageState extends State<DateAttendancePage> {
  List<bool>? isPresent; // nullable

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  void loadAttendance() async {
    final db = await context.read<ClassProvider>().db;
    final attendanceMap = await db.getAttendanceForDateAndClass(
      widget.classModel.id!,
      widget.date,
    );

    setState(() {
      isPresent =
          widget.studentList.map((student) {
            return attendanceMap[student.id] ?? true;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isPresent == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: mainC1,
          title: Text(
            '${widget.classModel.subjectName}',
            style: TextStyle(
              fontFamily: 'font1',
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    print("Student list length: ${widget.studentList.length}");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppbarWidgetSection(classModel: widget.classModel),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(bottom: 55),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20),
                color: bodyC1,
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              child: Text(
                '${widget.date}',
                style: TextStyle(
                  fontFamily: 'font1',
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 28),
                SizedBox(width: 60, child: HeaderText(text: 'Roll')),
                const SizedBox(width: 70),
                HeaderText(text: 'Name'),
                const SizedBox(width: 102),
                HeaderText(text: 'Attendance'),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: widget.studentList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 16,
                    ),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 45,
                          child: RollCircle(
                            student: widget.studentList[index],
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        NameBar(
                          student: widget.studentList[index],
                          width: 215,
                          height: 50,
                          fontSize: 20,
                        ),

                        const SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            backgroundColor:
                                isPresent![index] ? bodyC2 : Colors.red,
                          ),

                          onPressed: () {
                            setState(() {
                              isPresent![index] = !isPresent![index];
                            });
                          },
                          child: Text(
                            isPresent![index] ? 'P' : 'A',
                            style: TextStyle(
                              fontFamily: 'font1',
                              color:
                                  isPresent![index]
                                      ? Colors.black
                                      : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: SaveButton(),
              onPressed: () async {
                await context.read<ClassProvider>().updateAttendances(
                  widget.studentList,
                  widget.date,
                  isPresent!,
                );
                showNotification(context, 'Attendance Saved');
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: saveText(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
