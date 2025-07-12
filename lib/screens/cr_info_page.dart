import 'package:class_management/colors.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/model/cr_model.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/screens/cr_add_page.dart';
import 'package:class_management/screens/cr_update_screen.dart';
import 'package:class_management/widgets/appbar/appbar_widget.dart';
import 'package:class_management/widgets/common/notification.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrInfoPage extends StatefulWidget {
  const CrInfoPage({super.key, required this.classModel});

  final ClassModel classModel;
  @override
  State<CrInfoPage> createState() => _CrInfoPageState();
}

class _CrInfoPageState extends State<CrInfoPage> {
  List<Student> studentList = [];
  List<Student> crList = [];
  // Student? cr1;
  // Student? cr2;

  void initState() {
    // TODO: implement initState
    super.initState();
    getStudent();
  }

  void getStudent() async {
    final db = await context.read<ClassProvider>().db;
    studentList = await db.getAllStudent(classID: widget.classModel.id!);
    crList =
        studentList
            .where((s) => s.phone != null && s.phone!.trim().isNotEmpty)
            .toList();
    print('cr list size ${crList.length}');

    setState(() {}); // Refresh UI after data is loaded
  }

  Widget buildCrTile(Student cr) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
          decoration: BoxDecoration(
            color: bodyC1,
            // border: Border.all(color: Colors.black,width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          CrUpdateScreen(cr: cr, studentList: studentList),
                ),
              );
              getStudent(); // Now this will refresh the list after coming back
            },
            title:
                (cr.name == null || cr.name!.trim().isEmpty)
                    ? Text(
                      '${cr.roll}',
                      style: TextStyle(
                        fontFamily: 'font1',
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : Text(
                      '${cr.name} - ${cr.roll}',
                      style: TextStyle(
                        fontFamily: 'font1',
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            subtitle: Text(
              'Number : ${cr.phone}',
              style: TextStyle(
                fontFamily: 'font1',
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: IconButton(
              onPressed: () async {
                final confirm = await showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        backgroundColor: bodyC2,
                        title: Text(
                          'Delete CR Info',
                          style: TextStyle(
                            fontFamily: 'font1',
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to delete info of CR?',
                          style: TextStyle(
                            fontFamily: 'font1',
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: mainC2,
                            ),
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'font1',
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: mainC2,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                fontFamily: 'font1',
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                );
                if (confirm == true) {
                  final db = await context.read<ClassProvider>().db;
                  await db.updateStudentPhone(cr.id!, null);
                  showNotification(context, 'CR Info Deleted');
                  getStudent();
                }
              },
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete, color: mainC2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(text: 'CR Info'),
      body: Container(
        width: double.infinity,
        child: ListView(
          children: [
            if (crList.isEmpty)
              Center(
                child: Text(
                  'No CR info added yet',
                  style: TextStyle(fontFamily: 'font1', fontSize: 25),
                ),
              ),
            if (crList.length > 0) buildCrTile(crList[0]),
            //Crtile(cr: crList[0],),
            if (crList.length > 1) buildCrTile(crList[1]),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,

        child: FloatingActionButton(
          backgroundColor: mainC2,
          elevation: 4,

          onPressed: () async {
            if (crList.length == 2) {
              showNotification(context, 'Maximum two CRs');
              return;
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CrAddPage(classModel: widget.classModel),
                ),
              );
            }
            // Reload data when returning from CrAddPage
            getStudent();
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(Icons.add, size: 35, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
