import 'package:class_management/colors.dart';
import 'package:class_management/database/database_helper.dart';
import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/screens/class_add_screen.dart';
import 'package:class_management/widgets/appbar/appbar_widget.dart';
import 'package:class_management/widgets/class_screen_widgets/class_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //DBHelper.getInstance.deleteDatabaseFile();
    getclasses();
  }

  void getclasses() async {
    await context.read<ClassProvider>().getInitialClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(text: 'Classes'),
      body: ClassList(),
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          backgroundColor: mainC2,
          elevation: 4,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClassAddScreen()),
            );
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
