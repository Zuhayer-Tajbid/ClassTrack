import 'package:class_management/colors.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/widgets/add_student_info_widgets/remarks_filed.dart';
import 'package:class_management/widgets/appbar/appbar_widget_roll.dart';
import 'package:class_management/widgets/common/notification.dart';
import 'package:class_management/widgets/common/save_button_style.dart';
import 'package:class_management/widgets/common/save_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemarksPage extends StatefulWidget {
  const RemarksPage({super.key, required this.student});
  final Student student;

  @override
  State<RemarksPage> createState() => _RemarksPageState();
}

class _RemarksPageState extends State<RemarksPage> {
  TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRemarks();
  }

  void getRemarks() {
    if (widget.student.remarks != null) {
      remarkController.text = widget.student.remarks!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppbarWidgetRoll(student: widget.student),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: bodyC1,
          child: Column(
            children: [
              const SizedBox(height: 40),
              RemarksFiled(remarkController: remarkController),
              const SizedBox(height: 180),
              ElevatedButton(
                style: SaveButton(),
                onPressed: () async {
                  final db = context.read<ClassProvider>().db;
                  if (remarkController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('add remarks')));
                    return;
                  }
                  bool check = await db.updateStudentInfo(
                    widget.student.id!,
                    widget.student.name,
                    remarkController.text,
                  );
                  if (check) {
                    showNotification(context, 'Remarks Added');
                    print('${remarkController.text}');
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: saveText(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
