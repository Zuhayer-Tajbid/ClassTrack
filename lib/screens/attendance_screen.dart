import 'package:class_management/colors.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/model/student_model.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/screens/date_attendance_page.dart';
import 'package:class_management/widgets/appbar/appbar_widget.dart';
import 'package:class_management/widgets/common/notification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key, required this.classModel});
  final ClassModel classModel;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<String> dateList = [];
  List<Student>? studentList;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final dbHelper = context.read<ClassProvider>().db;

    studentList = await dbHelper.getAllStudent(classID: widget.classModel.id!);
    dateList = await dbHelper.getDistinctAttendanceDatesForClass(
      widget.classModel.id!,
    );
    print("📅 Dates loaded: $dateList");
    setState(() {});
  }

  void onDatePick() async {
    if (studentList!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Student list not loaded yet!')));
      return;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      /// ✅ Use studentList.length, not classModel.noOfStudent
      List<bool> isPresent = List.generate(
        studentList!.length,
        (index) => true,
      );

      await context.read<ClassProvider>().updateAttendances(
        studentList!,
        formattedDate,
        isPresent,
      );

      dateList = await context
          .read<ClassProvider>()
          .db
          .getDistinctAttendanceDatesForClass(widget.classModel.id!);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(text: 'Attendance Page'),
      body: Container(
        child:
            dateList.isEmpty
                ? Center(
                  child: Text(
                    'No attendance added yet',
                    style: TextStyle(fontFamily: 'font1', fontSize: 30),
                  ),
                )
                : ListView.builder(
                  padding: EdgeInsets.only(top: 30),
                  itemCount: dateList.length,
                  itemBuilder: (context, index) {
                    // final reversedIndex = dateList.length - 1 - index;
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 13,
                      ), // Outer spacing
                      decoration: BoxDecoration(
                        color: bodyC1, // Background color
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: Colors.black12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ), // Inner padding
                        tileColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DateAttendancePage(
                                    classModel: widget.classModel,
                                    date: dateList[index],
                                    studentList: studentList!,
                                  ),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                        title: Text(
                          dateList[index],
                          style: TextStyle(
                            fontFamily: 'font1',
                            color: Colors.black,
                            fontSize: 30,
                          ),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.delete, color: mainC2),
                            onPressed: () async {
                              final confirm = await showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      backgroundColor: bodyC2,
                                      title: Text(
                                        'Delete Attendance',
                                        style: TextStyle(
                                          fontFamily: 'font1',
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'Are you sure you want to delete attendance for ${dateList[index]}?',
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
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
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
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
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
                                await context
                                    .read<ClassProvider>()
                                    .deleteAttendanceDate(
                                      widget.classModel.id!,
                                      dateList[index],
                                    );

                                // Refresh list
                                dateList = await context
                                    .read<ClassProvider>()
                                    .db
                                    .getDistinctAttendanceDatesForClass(
                                      widget.classModel.id!,
                                    );
                                showNotification(context, 'Attendance Deleted');
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          backgroundColor: mainC2,

          elevation: 4,
          onPressed: onDatePick,
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
