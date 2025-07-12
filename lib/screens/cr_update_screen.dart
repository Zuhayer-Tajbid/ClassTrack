import 'package:class_management/colors.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/widgets/appbar/appbar_widget.dart';
import 'package:class_management/widgets/common/notification.dart';
import 'package:class_management/widgets/common/save_button_style.dart';
import 'package:class_management/widgets/common/save_text.dart';
import 'package:class_management/widgets/cr_widgets/roll_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrUpdateScreen extends StatefulWidget {
  const CrUpdateScreen({
    super.key,
    required this.cr,
    required this.studentList,
  });

  final Student cr;
  final List<Student> studentList;
  @override
  State<CrUpdateScreen> createState() => _CrUpdateScreenState();
}

class _CrUpdateScreenState extends State<CrUpdateScreen> {
  TextEditingController roll1Controller = TextEditingController();
  TextEditingController phone1Controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    roll1Controller.text = widget.cr.roll.toString();
    phone1Controller.text = widget.cr.phone!;
  }

  Future<void> saveCrInfo() async {
    final db = await context.read<ClassProvider>().db;

    // Get and validate roll numbers
    int? roll1 = int.tryParse(roll1Controller.text.trim());

    String phone1 = phone1Controller.text.trim();

    if (roll1 != null && phone1.isNotEmpty) {
      final cr1 = widget.studentList.firstWhere(
        (s) => s.roll == roll1,
        orElse: () => Student(classId: -1, roll: -1),
      );

      if (cr1.classId != -1 && cr1.id != null) {
        await db.updateStudentPhone(cr1.id!, phone1);

        // Only clear old CR if the roll is different
        if (cr1.id != widget.cr.id) {
          await db.updateStudentPhone(widget.cr.id!, null);
        }
      }
    }

    showNotification(context, 'CR Info Updated');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppbarWidget(text: 'CR Info Update'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30),
        child: Container(
          color: bodyC1,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 50),

              RollPhoneField(controller: roll1Controller, text: 'Roll Number'),
              const SizedBox(height: 30),

              RollPhoneField(
                controller: phone1Controller,
                text: 'Phone Number',
              ),
              const SizedBox(height: 430),

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
