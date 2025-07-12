import 'package:class_management/colors.dart';
import 'package:class_management/model/attendance_model.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/widgets/appbar/appbar_widget_roll.dart';
import 'package:class_management/widgets/ct_marks_page_widgets/header_text.dart';
import 'package:class_management/widgets/student_profile_widget/attendance_circle.dart';
import 'package:class_management/widgets/student_profile_widget/mark_column.dart';
import 'package:class_management/widgets/student_profile_widget/remark_box.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key, required this.student});

  final Student student;

  Map<String, dynamic> calculateAttendanceStats(List<Attendance> list) {
    if (list.isEmpty) return {'percentage': 0.0, 'mark': 0};

    int total = list.length;
    int present = list.where((e) => e.isPresent).length;
    double percentage = (present / total) * 100;

    int mark;
    if (percentage >= 90) {
      mark = 10;
    } else if (percentage >= 85) {
      mark = 9;
    } else if (percentage >= 80) {
      mark = 8;
    } else if (percentage >= 75) {
      mark = 7;
    } else if (percentage >= 70) {
      mark = 6;
    } else if (percentage >= 65) {
      mark = 5;
    } else if (percentage >= 60) {
      mark = 4;
    } else if (percentage >= 50) {
      mark = 3;
    } else if (percentage >= 40) {
      mark = 2;
    } else if (percentage >= 30) {
      mark = 1;
    } else {
      mark = 0;
    }

    return {'percentage': percentage, 'mark': mark};
  }

  int ctAvg(List<int> ctMarks) {
    ctMarks.sort((a, b) => b.compareTo(a));

    double avgDouble = (ctMarks[0] + ctMarks[1] + ctMarks[2]) / 3;

    int avg = avgDouble.ceil();

    return avg;
  }

  @override
  Widget build(BuildContext context) {
    var stats = calculateAttendanceStats(student.attendanceList);
    var color = bodyC1;
    var fontC = Colors.black;

    if (stats['mark'] == 0 && student.attendanceList.isNotEmpty) {
      color = Colors.red;
      fontC = Colors.white;
    }
    return Scaffold(
      appBar: AppbarWidgetRoll(student: student),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Attendance',
              style: TextStyle(
                fontFamily: 'font1',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 140, // control size here
                  height: 140,
                  decoration: BoxDecoration(
                    color: color,

                    shape: BoxShape.circle,
                  ),

                  child: Center(
                    child: AttendanceCircle(
                      text:
                          'Percentage\n${stats['percentage'].toStringAsFixed(2)}%',
                      color: color,
                      fontC: fontC,
                    ),
                  ),
                ),

                Container(
                  width: 140, // control size here
                  height: 140,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),

                  child: Center(
                    child: AttendanceCircle(
                      text: 'Marks\n${stats['mark']}',
                      color: color,
                      fontC: fontC,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MarkColumn(
                  text: '${student.ctMarks[0]}',
                  color: bodyC1,
                  fontC: Colors.black,
                  headerText: 'CT 1',
                ),
                MarkColumn(
                  text: '${student.ctMarks[1]}',
                  color: bodyC1,
                  fontC: Colors.black,
                  headerText: 'CT 2',
                ),
                MarkColumn(
                  text: '${student.ctMarks[2]}',
                  color: bodyC1,
                  fontC: Colors.black,
                  headerText: 'CT 2',
                ),
                MarkColumn(
                  text: '${student.ctMarks[3]}',
                  color: bodyC1,
                  fontC: Colors.black,
                  headerText: 'CT 4',
                ),
                MarkColumn(
                  headerText: 'Average',
                  text: '${ctAvg(student.ctMarks)}',
                  color: mainC2,
                  fontC: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'Remarks',
              style: TextStyle(
                fontFamily: 'font1',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            student.remarks != null && student.remarks!.trim().isNotEmpty
                ? RemarkBox(text: student.remarks!)
                : Container(
                  height: 270,
                  width: 330,
                  decoration: BoxDecoration(
                    color: bodyC1,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(padding: const EdgeInsets.all(15)),
                ),
          ],
        ),
      ),
    );
  }
}
