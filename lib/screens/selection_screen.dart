import 'package:class_management/colors.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/screens/add_info_page.dart';
import 'package:class_management/screens/attendance_screen.dart';
import 'package:class_management/screens/cr_info_page.dart';
import 'package:class_management/screens/ct_marks_screen.dart';
import 'package:class_management/screens/student_profile_page.dart';
import 'package:class_management/widgets/selection_screen_widget/selection_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key, required this.classModel});

  final ClassModel classModel;

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudents();
  }

  void getStudents() async {
    await context.read<ClassProvider>().getInitialStudents(widget.classModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainC1,
        title:
            widget.classModel.section == null
                ? Text(
                  '${widget.classModel.subjectName}',
                  style: TextStyle(
                    fontFamily: 'font1',
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )
                : Text(
                  '${widget.classModel.subjectName} (Sec - ${widget.classModel.section})',
                  style: TextStyle(
                    fontFamily: 'font1',
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            SelectionButton(
              text: 'Attendance',
              destinationBuilder:
                  () => AttendanceScreen(classModel: widget.classModel),
            ),
            const SizedBox(height: 35),
            SelectionButton(
              text: 'CT Marks',
              destinationBuilder:
                  () => CtMarksScreen(classModel: widget.classModel),
            ),

            const SizedBox(height: 35),
            SelectionButton(
              text: 'Add Student Info',
              destinationBuilder:
                  () => AddInfoPage(classModel: widget.classModel),
            ),

            const SizedBox(height: 35),
            SelectionButton(
              text: 'Student Profile',
              destinationBuilder:
                  () => StudentProfilePage(classModel: widget.classModel),
            ),

            const SizedBox(height: 35),
            SelectionButton(
              text: 'CR Info',
              destinationBuilder:
                  () => CrInfoPage(classModel: widget.classModel),
            ),
          ],
        ),
      ),
    );
  }
}
