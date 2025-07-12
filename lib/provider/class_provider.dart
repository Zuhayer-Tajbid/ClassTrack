import 'package:class_management/data/dummy_data.dart';
import 'package:class_management/database/database_helper.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/model/student_model.dart';
import 'package:flutter/material.dart';

class ClassProvider extends ChangeNotifier {
  List<ClassModel> classList = [];
  List<Student> studentList = [];
  final DBHelper db = DBHelper.getInstance;

  //initial class
  Future<void> getInitialClasses() async {
    classList = await db.getAllClass();

    if (classList.isEmpty) {
      print('No class found. Inserting dummy...');
      bool check = await db.addClass(dummyClass);

      if (check) {
        classList = await db.getAllClass();
        print('Dummy inserted. Class count: ${classList.length}');
      }
    } else {
      print('Found existing classes: ${classList.length}');
    }

    notifyListeners();
  }

  //add class
  Future<void> addClasses(ClassModel classmodel) async {
    bool check = await db.addClass(classmodel);
    if (check) {
      classList = await db.getAllClass();
    }
    notifyListeners();
  }

  //delete class
  Future<void> deleteClasses(int id) async {
    bool check = await db.deleteClass(id: id);
    if (check) {
      classList = await db.getAllClass();
    }
    notifyListeners();
  }

  //update class
  Future<void> updateClasses(ClassModel updatedModel) async {
    final dbHelper = await db.getDB();

    // Fetch old class data
    final existingClass = classList.firstWhere((c) => c.id == updatedModel.id);

    // Update class in DB
    bool updated = await db.updateClass(updatedModel);

    if (updated) {
      // CASE 1: If count or section changed significantly
      bool sectionChanged =
          (existingClass.section == null && updatedModel.section != null) ||
          (existingClass.section != null && updatedModel.section == null);
      bool countChanged = existingClass.noOfStudent != updatedModel.noOfStudent;

      if (sectionChanged || countChanged) {
        // Delete old students
        await dbHelper.delete(
          DBHelper.STUDENT_TABLE_TITLE,
          where: '${DBHelper.CLASS_ID} = ?',
          whereArgs: [updatedModel.id],
        );

        // Generate new students
        int startRoll = 1;
        if (updatedModel.section != null) {
          if (updatedModel.section == 'B')
            startRoll = 61;
          else if (updatedModel.section == 'C')
            startRoll = 121;
        }

        List<Student> dummyStudents = List.generate(updatedModel.noOfStudent, (
          index,
        ) {
          return Student(classId: updatedModel.id!, roll: startRoll + index);
        });

        for (final student in dummyStudents) {
          await db.addStudent(student);
        }
      } else {
        // CASE 2: Only section changed but student count same
        await db.updateStudentRollsByClass(updatedModel);
      }

      classList = await db.getAllClass();
      notifyListeners();
    }
  }

  //initial students
  Future<void> getInitialStudents(ClassModel classModel) async {
    studentList = await db.getAllStudent(classID: classModel.id!);
    bool check = true;

    if (studentList.isEmpty) {
      int startRoll = 1;
      if (classModel.section != null) {
        if (classModel.section == 'B') {
          startRoll = 61;
        } else if (classModel.section == 'C') {
          startRoll = 121;
        }
      }

      List<Student> dummyStudents = List.generate(classModel.noOfStudent, (
        index,
      ) {
        return Student(classId: classModel.id!, roll: startRoll + index);
      });
      print('No student found. Inserting dummy...');
      for (final student in dummyStudents) {
        check = await db.addStudent(student);
        if (!check) {
          break;
        }
      }

      if (check) {
        studentList = await db.getAllStudent(classID: classModel.id!);
        print('Dummy inserted. student count: ${studentList.length}');
      }
    } else {
      print('Found existing student: ${studentList.length}');
    }
    notifyListeners();
  }

  //delete attendance
  Future<void> deleteAttendanceDate(int classId, String date) async {
    await db.deleteAttendanceByDate(classId, date);
    notifyListeners();
  }

  Future<void> updateAttendances(
    List<Student> studentList,
    String date,
    List<bool> isPresent,
  ) async {
    if (studentList.length != isPresent.length) {
      throw ArgumentError("Lists must be of equal length");
    }

    final dbInstance = await db.getDB();

    for (int i = 0; i < studentList.length; i++) {
      final student = studentList[i];
      final present = isPresent[i];

      // First try to update
      final count = await dbInstance.update(
        DBHelper.ATTENDANCE_TABLE_TITLE,
        {DBHelper.ISPRESENT: present ? 1 : 0},
        where: '${DBHelper.STUDENT_ID}= ? AND ${DBHelper.DATE} = ?',
        whereArgs: [student.id!, date],
      );

      // If update did not affect any rows, insert instead
      if (count == 0) {
        await dbInstance.insert(DBHelper.ATTENDANCE_TABLE_TITLE, {
          DBHelper.STUDENT_ID: student.id!,
          DBHelper.DATE: date,
          DBHelper.ISPRESENT: present ? 1 : 0,
        });
      }
    }

    notifyListeners();
  }
}
