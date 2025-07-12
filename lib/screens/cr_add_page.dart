import 'package:class_management/colors.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/model/cr_model.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/widgets/appbar/appbar_widget.dart';
import 'package:class_management/widgets/common/notification.dart';
import 'package:class_management/widgets/common/save_button_style.dart';
import 'package:class_management/widgets/common/save_text.dart';
import 'package:class_management/widgets/cr_widgets/roll_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrAddPage extends StatefulWidget {
  const CrAddPage({super.key, required this.classModel});
  final ClassModel classModel;

  @override
  State<CrAddPage> createState() => _CrAddPageState();
}

class _CrAddPageState extends State<CrAddPage> {
  TextEditingController roll1Controller = TextEditingController();
  TextEditingController phone1Controller = TextEditingController();
  TextEditingController roll2Controller = TextEditingController();
  TextEditingController phone2Controller = TextEditingController();

  List<Student> studentList = [];

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    final db = await context.read<ClassProvider>().db;
    studentList = await db.getAllStudent(classID: widget.classModel.id!);
    setState(() {});
  }

  Future<void> saveCrInfo() async {
    final db = await context.read<ClassProvider>().db;

    // Get and validate roll numbers
    int? roll1 = int.tryParse(roll1Controller.text.trim());
    int? roll2 = int.tryParse(roll2Controller.text.trim());
    String phone1 = phone1Controller.text.trim();
    String phone2 = phone2Controller.text.trim();

    if (roll1 != null && phone1.isNotEmpty) {
      final cr1 = studentList.firstWhere(
        (s) => s.roll == roll1,
        orElse: () => Student(classId: -1, roll: -1),
      );
      if (cr1.classId != -1 && cr1.id != null) {
        await db.updateStudentPhone(cr1.id!, phone1);
      }
    }

    if (roll2 != null && phone2.isNotEmpty) {
      final cr2 = studentList.firstWhere(
        (s) => s.roll == roll2,
        orElse: () => Student(classId: -1, roll: -1),
      );
      if (cr2.classId != -1 && cr2.id != null) {
        await db.updateStudentPhone(cr2.id!, phone2);
      }
    }

    showNotification(context, 'CR info saved');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppbarWidget(text: 'CR Info Add'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30),
        child: Container(
          color: bodyC1,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                '1st 30 CR',
                style: TextStyle(
                  fontFamily: 'font1',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              RollPhoneField(controller: roll1Controller, text: 'Roll Number'),
              const SizedBox(height: 30),

              RollPhoneField(
                controller: phone1Controller,
                text: 'Phone Number',
              ),
              const SizedBox(height: 60),
              Text(
                '2nd 30 CR',
                style: TextStyle(
                  fontFamily: 'font1',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              RollPhoneField(controller: roll2Controller, text: 'Roll Number'),
              const SizedBox(height: 30),

              RollPhoneField(
                controller: phone2Controller,
                text: 'Phone Number',
              ),
              const SizedBox(height: 110),
              ElevatedButton(
                style: SaveButton(),
                onPressed: saveCrInfo,
                child: Padding(padding: EdgeInsets.all(12), child: saveText()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
