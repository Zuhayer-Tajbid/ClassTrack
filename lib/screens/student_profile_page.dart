import 'package:class_management/colors.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/screens/student_page.dart';
import 'package:class_management/widgets/appbar/appbar_widget.dart';
import 'package:class_management/widgets/student_profile_widget/student_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key, required this.classModel});
  final ClassModel classModel;

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  List<Student> studentList = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    getStudent();
  }

  void getStudent() async {
    final db = await context.read<ClassProvider>().db;
    studentList = await db.getAllStudent(classID: widget.classModel.id!);

    setState(() {}); // Refresh UI after data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(text: 'Student Profile'),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20),
                color: bodyC1,
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              child:
                  widget.classModel.section == null
                      ? Text(
                        '${widget.classModel.subjectName}',
                        style: TextStyle(
                          fontFamily: 'font1',
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      : Text(
                        '${widget.classModel.subjectName} (Sec - ${widget.classModel.section})',
                        style: TextStyle(
                          fontFamily: 'font1',
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: ListView.builder(
                itemCount: studentList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    child: StudentTile(student: studentList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
