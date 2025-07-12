import 'package:class_management/colors.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/screens/remarks_page.dart';
import 'package:class_management/widgets/add_student_info_widgets/namefield.dart';
import 'package:class_management/widgets/appbar/appbar_widget.dart';
import 'package:class_management/widgets/attendance_page_widgets/roll_circle.dart';
import 'package:class_management/widgets/common/notification.dart';
import 'package:class_management/widgets/common/save_button_style.dart';
import 'package:class_management/widgets/common/save_text.dart';
import 'package:class_management/widgets/ct_marks_page_widgets/header_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddInfoPage extends StatefulWidget {
  const AddInfoPage({super.key, required this.classModel});
  final ClassModel classModel;

  @override
  State<AddInfoPage> createState() => _AddInfoPageState();
}

class _AddInfoPageState extends State<AddInfoPage> {
  List<Student> studentList = [];
  List<TextEditingController> namecontroller = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudent();
  }

  void getStudent() async {
    final db = await context.read<ClassProvider>().db;
    studentList = await db.getAllStudent(classID: widget.classModel.id!);
    print('list size in ct page ${studentList.length}');

    namecontroller.clear();

    for (int i = 0; i < studentList.length; i++) {
      final student = studentList[i];

      namecontroller.add(TextEditingController(text: student.name));

      // Add listeners to update UI only when needed
      namecontroller[i].addListener(() => setState(() {}));
    }

    setState(() {}); // Refresh UI after data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppbarWidget(text: 'Add Student Info'),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(bottom: 50),
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
            Row(
              children: [
                const SizedBox(width: 25),
                HeaderText(text: 'Roll'),
                const SizedBox(width: 88),
                HeaderText(text: 'Name'),
                const SizedBox(width: 112),
                HeaderText(text: 'Remarks'),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: studentList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 45,
                          child: RollCircle(
                            student: studentList[index],
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Namefield(namecontroller: namecontroller[index]),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainC1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => RemarksPage(
                                      student: studentList[index],
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            'Remarks',
                            style: TextStyle(
                              fontFamily: 'font1',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: SaveButton(),
              onPressed: () async {
                final db = await context.read<ClassProvider>().db;
                for (int i = 0; i < studentList.length; i++) {
                  bool check = await db.updateStudentInfo(
                    studentList[i].id!,
                    namecontroller[i].text,
                    studentList[i].remarks,
                  );
                  if (!check) {
                    showNotification(context, 'Error In Saving');
                  }
                }
                studentList = await db.getAllStudent(
                  classID: widget.classModel.id!,
                );
                showNotification(context, 'Info Saved');
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
