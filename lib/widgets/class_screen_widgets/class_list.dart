import 'package:class_management/colors.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/screens/class_update_screen.dart';
import 'package:class_management/screens/selection_screen.dart';
import 'package:class_management/widgets/common/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassList extends StatelessWidget {
  const ClassList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassProvider>(
      builder: (context, value, child) {
        if (value.classList.isEmpty) {
          return Center(child: Text('No classes added yet'));
        }
        return ListView.builder(
          padding: EdgeInsets.only(top: 20),
          itemCount: value.classList.length,
          itemBuilder: (context, index) {
            final classItem = value.classList[index];
            return Padding(
              padding: EdgeInsets.all(15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SelectionScreen(classModel: classItem),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(15),
                    color: mainC2,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 150,
                          width: 200,
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(15),
                            color: bodyC1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                classItem.subjectName,
                                style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: 'font1',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 7),
                              if (classItem.section != null &&
                                  classItem.section!.isNotEmpty)
                                Text(
                                  'Sec - ${classItem.section}',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'font1',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ClassUpdateScreen(
                                        classModel: classItem,
                                      ),
                                ),
                              );
                            },
                            icon: Icon(Icons.update, color: mainC2),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              final confirm = await showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      backgroundColor: bodyC2,
                                      title: Text(
                                        'Delete Class',
                                        style: TextStyle(
                                          fontFamily: 'font1',
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'Are you sure you want to delete ${classItem.subjectName}?',
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
                                value.deleteClasses(classItem.id!);
                                showNotification(context, 'Class Deleted');
                                // Refresh list
                              }
                            },
                            icon: Icon(Icons.delete, color: mainC2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
