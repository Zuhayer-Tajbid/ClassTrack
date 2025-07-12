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
import 'package:class_management/widgets/ct_marks_page_widgets/ct_marks_field.dart';
import 'package:class_management/widgets/ct_marks_page_widgets/header_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CtMarksScreen extends StatefulWidget {
  const CtMarksScreen({super.key, required this.classModel});
  final ClassModel classModel;

  @override
  State<CtMarksScreen> createState() => _CtMarksScreenState();
}

class _CtMarksScreenState extends State<CtMarksScreen> {
  List<Student> studentList = [];
  List<TextEditingController> ct1 = [];
  List<TextEditingController> ct2 = [];
  List<TextEditingController> ct3 = [];
  List<TextEditingController> ct4 = [];
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

    ct1.clear();
    ct2.clear();
    ct3.clear();
    ct4.clear();

    for (int i = 0; i < studentList.length; i++) {
      final student = studentList[i];

      ct1.add(TextEditingController(text: student.ctMarks[0].toString()));
      ct2.add(TextEditingController(text: student.ctMarks[1].toString()));
      ct3.add(TextEditingController(text: student.ctMarks[2].toString()));
      ct4.add(TextEditingController(text: student.ctMarks[3].toString()));

      // Add listeners to update UI only when needed
      ct1[i].addListener(() => setState(() {}));
      ct2[i].addListener(() => setState(() {}));
      ct3[i].addListener(() => setState(() {}));
      ct4[i].addListener(() => setState(() {}));
    }

    setState(() {}); // Refresh UI after data is loaded
  }

  int ctAvg(List<int> ctMarks) {
    ctMarks.sort((a, b) => b.compareTo(a));

    double avgDouble = (ctMarks[0] + ctMarks[1] + ctMarks[2]) / 3;

    int avg = avgDouble.ceil();

    return avg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppbarWidgetSection(classModel: widget.classModel),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(bottom: 50),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 12),
                HeaderText(text: 'Roll'),
                const SizedBox(width: 35),
                HeaderText(text: 'Name'),
                const SizedBox(width: 38),
                HeaderText(text: 'CT1'),
                const SizedBox(width: 25),
                HeaderText(text: 'CT2'),
                const SizedBox(width: 25),
                HeaderText(text: 'CT3'),
                const SizedBox(width: 25),
                HeaderText(text: 'CT4'),
                const SizedBox(width: 10),
                Text(
                  'Average\n Marks',
                  style: TextStyle(
                    fontFamily: 'font1',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            //const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: studentList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        RollCircle(student: studentList[index], fontSize: 17),
                        const SizedBox(width: 6),
                        NameBar(
                          student: studentList[index],
                          width: 93,
                          height: 70,
                          fontSize: 20,
                        ),
                        const SizedBox(width: 6),
                        CtMarksField(ct: ct1[index]),
                        const SizedBox(width: 6),
                        CtMarksField(ct: ct2[index]),
                        const SizedBox(width: 6),
                        CtMarksField(ct: ct3[index]),
                        const SizedBox(width: 6),
                        CtMarksField(ct: ct4[index]),
                        SizedBox(
                          width: widget.classModel.section == 'C' ? 4 : 7,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bodyC1,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              '${ctAvg([int.tryParse(ct1[index].text) ?? 0, int.tryParse(ct2[index].text) ?? 0, int.tryParse(ct3[index].text) ?? 0, int.tryParse(ct4[index].text) ?? 0])}',
                              style: TextStyle(
                                fontFamily: 'font1',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
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
                  bool check = await db.updateCTMarks(studentList[i].id!, [
                    int.tryParse(ct1[i].text) ?? 0,
                    int.tryParse(ct2[i].text) ?? 0,
                    int.tryParse(ct3[i].text) ?? 0,
                    int.tryParse(ct4[i].text) ?? 0,
                  ]);
                  if (!check) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('error')));
                    break;
                  }
                }
                studentList = await db.getAllStudent(
                  classID: widget.classModel.id!,
                );
                showNotification(context, 'CT Marks Saved');
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
