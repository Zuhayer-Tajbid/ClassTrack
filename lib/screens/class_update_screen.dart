import 'package:class_management/colors.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/widgets/class_add_page_widgets/number_of_student_button.dart';
import 'package:class_management/widgets/class_add_page_widgets/section_button.dart';
import 'package:class_management/widgets/class_add_page_widgets/subject_field.dart';
import 'package:class_management/widgets/common/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassUpdateScreen extends StatefulWidget {
  const ClassUpdateScreen({super.key, required this.classModel});

  final ClassModel classModel;

  @override
  State<ClassUpdateScreen> createState() => _ClassUpdateScreenState();
}

class _ClassUpdateScreenState extends State<ClassUpdateScreen> {
  late bool is180;
  late int studentCount;
  late String? section;
  TextEditingController subjectController = TextEditingController();
  List<bool> isNumSelected = [false, false, false];
  List<bool> isSecSelected = [false, false, false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    is180 = (widget.classModel.section) != null;
    studentCount = widget.classModel.noOfStudent;
    section = widget.classModel.section;
    subjectController.text = widget.classModel.subjectName;
    loadNumSecSelected(studentCount, section);
  }

  void loadNumSecSelected(int studentCount, String? section) {
    if (studentCount == 30 && section == null) {
      isNumSelected[2] = true;
      isNumSelected[0] = false;
      isNumSelected[1] = false;
    } else if (studentCount == 60 && section == null) {
      isNumSelected[1] = true;
      isNumSelected[2] = false;
      isNumSelected[0] = false;
    } else {
      isNumSelected[0] = true;
      isNumSelected[1] = false;
      isNumSelected[2] = false;
    }

    if (section != null) {
      if (section == 'A') {
        isSecSelected[0] = true;
        isSecSelected[1] = false;
        isSecSelected[2] = false;
      } else if (section == 'B') {
        isSecSelected[0] = false;
        isSecSelected[1] = true;
        isSecSelected[2] = false;
      } else {
        isSecSelected[0] = false;
        isSecSelected[1] = false;
        isSecSelected[2] = true;
      }
    }
  }

  void onIsNumSelected(int n) {
    if (n == 180) {
      isNumSelected[0] = true;
      isNumSelected[1] = false;
      isNumSelected[2] = false;
    } else if (n == 60) {
      isNumSelected[0] = false;
      isNumSelected[1] = true;
      isNumSelected[2] = false;
    } else {
      isNumSelected[0] = false;
      isNumSelected[1] = false;
      isNumSelected[2] = true;
    }
    setState(() {});
  }

  void onIsSecSelected(bool is180, String sectionName) {
    if (is180) {
      if (sectionName == 'A') {
        isSecSelected[0] = true;
        isSecSelected[1] = false;
        isSecSelected[2] = false;
      } else if (sectionName == 'B') {
        isSecSelected[0] = false;
        isSecSelected[1] = true;
        isSecSelected[2] = false;
      } else {
        isSecSelected[0] = false;
        isSecSelected[1] = false;
        isSecSelected[2] = true;
      }
    }
    setState(() {});
  }

  // to check if 180 and store student count
  void is180func(int n) {
    if (n == 180) {
      is180 = true;
    } else {
      is180 = false;
      section = null;
    }

    if (n == 30) {
      studentCount = 30;
    } else {
      studentCount = 60;
    }
    setState(() {});
  }

  //select section
  void onSectionSelect(String sec) {
    setState(() {
      section = sec;
    });
  }

  //update class
  void onUpdateClass() async {
    if (subjectController.text.isEmpty ||
        studentCount == null ||
        (is180 && section == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the required fields')),
      );
      return;
    }

    final updatedClass = ClassModel(
      id: widget.classModel.id, // must preserve ID
      subjectName: subjectController.text,
      noOfStudent: studentCount!,
      section: section,
    );

    await context.read<ClassProvider>().updateClasses(updatedClass);
    showNotification(context, 'Class Updated');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Class Update Page',
          style: TextStyle(
            fontFamily: 'font1',
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: mainC1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 60),
              SubjectField(subjectName: subjectController),
              const SizedBox(height: 50),
              Text(
                'Number of students',
                style: TextStyle(fontFamily: 'font1', fontSize: 30),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumberOfStudentButton(
                    is180: is180,
                    number: 180,
                    is180func: is180func,
                    onIsNumSelected: onIsNumSelected,
                    isNumSelected: isNumSelected[0],
                  ),
                  NumberOfStudentButton(
                    is180: is180,
                    number: 60,
                    is180func: is180func,
                    onIsNumSelected: onIsNumSelected,
                    isNumSelected: isNumSelected[1],
                  ),
                  NumberOfStudentButton(
                    is180: is180,
                    number: 30,
                    is180func: is180func,
                    onIsNumSelected: onIsNumSelected,
                    isNumSelected: isNumSelected[2],
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Text(
                'Section',
                style: TextStyle(fontFamily: 'font1', fontSize: 30),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SectionButton(
                    section: 'A',
                    onSectionSelect: is180 ? onSectionSelect : null,
                    is180: is180,
                    isSecSelected: isSecSelected[0],
                    onIsSecSelected: onIsSecSelected,
                  ),
                  SectionButton(
                    section: 'B',
                    onSectionSelect: is180 ? onSectionSelect : null,
                    is180: is180,
                    isSecSelected: isSecSelected[1],
                    onIsSecSelected: onIsSecSelected,
                  ),
                  SectionButton(
                    section: 'C',
                    onSectionSelect: is180 ? onSectionSelect : null,
                    is180: is180,
                    isSecSelected: isSecSelected[2],
                    onIsSecSelected: onIsSecSelected,
                  ),
                ],
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: mainC2,
                ),
                onPressed: onUpdateClass,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Update class',
                    style: TextStyle(
                      fontFamily: 'font1',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
