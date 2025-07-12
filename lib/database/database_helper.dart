import 'dart:io';
import 'package:class_management/model/attendance_model.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/model/cr_model.dart';
import 'package:class_management/model/student_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  Database? myDB;

  static final CLASS_TABLE_TITLE = 'class';
  static final SUBJECT_NAME = 'subject';
  static final CLASS_ID = 'classId';
  static final STUDENT_NUMBER = 'student_number';
  static final SECTION = 'section';

  static final STUDENT_TABLE_TITLE = 'student';
  static final STUDENT_NAME = 'name';
  static final STUDENT_ID = 'studentID';
  static final ROLL = 'roll';
  static final REMARKS = 'remarks';
  static final PHONE = 'phone';

  static final ATTENDANCE_TABLE_TITLE = 'attendance';
  static final ATTENDANCE_ID = 'attendanceID';
  static final DATE = 'date';
  static final ISPRESENT = 'isPresent';

  static final CT_TABLE_TITLE = 'ct';
  static final CT_ID = 'ctId';
  static final CT1 = 'ct1';
  static final CT2 = 'ct2';
  static final CT3 = 'ct3';
  static final CT4 = 'ct4';

  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    }

    myDB = await openDB();
    return myDB!;
  }

  //table creation
  Future<Database> openDB() async {
    Directory appDirr = await getApplicationDocumentsDirectory();

    String appPath = join(appDirr.path, 'classM.db');

    return await openDatabase(
      appPath,
      version: 1,
      onCreate: (db, version) async {
        //class table
        await db.execute('''
CREATE TABLE $CLASS_TABLE_TITLE(
$CLASS_ID INTEGER PRIMARY KEY AUTOINCREMENT,
$SUBJECT_NAME TEXT,
$STUDENT_NUMBER INTEGER,
$SECTION TEXT
)
''');

        //student table
        await db.execute('''
CREATE TABLE $STUDENT_TABLE_TITLE(
$STUDENT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
$CLASS_ID INTEGER,
$STUDENT_NAME TEXT,
$REMARKS TEXT,
$PHONE TEXT,
$ROLL INTEGER
)

''');

        //attendance table
        await db.execute('''
CREATE TABLE $ATTENDANCE_TABLE_TITLE(
$ATTENDANCE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
$STUDENT_ID INTEGER,
$DATE TEXT,
$ISPRESENT INTEGER
)
''');

        //ct marks table
        await db.execute('''
CREATE TABLE $CT_TABLE_TITLE(
  $CT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
  $STUDENT_ID INTEGER,
  $CT1 INTEGER,
  $CT2 INTEGER,
  $CT3 INTEGER,
  $CT4 INTEGER
)
''');
        await db.execute('''
  CREATE TABLE cr_table (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    $STUDENT_ID INTEGER,
    $CLASS_ID INTEGER,
    roll INTEGER,
    phone TEXT
  )
''');
      },
    );
  }

  //add class
  Future<bool> addClass(ClassModel classmodel) async {
    var db = await getDB();

    int rowsEffected = await db.insert(CLASS_TABLE_TITLE, {
      SUBJECT_NAME: classmodel.subjectName,
      STUDENT_NUMBER: classmodel.noOfStudent,
      SECTION: classmodel.section,
    });

    return rowsEffected > 0;
  }

  Future<bool> addStudent(Student student) async {
    final db = await getDB();

    // 1. Insert student and get the auto-generated ID
    int studentId = await db.insert(STUDENT_TABLE_TITLE, {
      CLASS_ID: student.classId,
      STUDENT_NAME: student.name,
      ROLL: student.roll,
      REMARKS: student.remarks,
      PHONE: student.phone ?? '',
    });

    // 2. Insert CT marks (safe default)
    int rowsEffected2 = await db.insert(CT_TABLE_TITLE, {
      STUDENT_ID: studentId,
      CT1: student.ctMarks.isNotEmpty ? student.ctMarks[0] : 0,
      CT2: student.ctMarks.length > 1 ? student.ctMarks[1] : 0,
      CT3: student.ctMarks.length > 2 ? student.ctMarks[2] : 0,
      CT4: student.ctMarks.length > 3 ? student.ctMarks[3] : 0,
    });

    // 3. Insert attendance (if any)
    int rowsEffected3 = 1;
    for (final att in student.attendanceList) {
      final result = await db.insert(ATTENDANCE_TABLE_TITLE, {
        STUDENT_ID: studentId,
        DATE: att.date,
        ISPRESENT: att.isPresent ? 1 : 0,
      });
      if (result <= 0) rowsEffected3 = 0;
    }

    return studentId > 0 && rowsEffected2 > 0 && rowsEffected3 > 0;
  }

  // get all classes
  Future<List<ClassModel>> getAllClass() async {
    var db = await getDB();
    final classModel = await db.query(CLASS_TABLE_TITLE);

    List<ClassModel> classList =
        classModel
            .map(
              (map) => ClassModel(
                subjectName: map[SUBJECT_NAME] as String,
                section: map[SECTION] as String?,
                noOfStudent: map[STUDENT_NUMBER] as int,
                id: map[CLASS_ID] as int,
              ),
            )
            .toList();
    return classList;
  }

  //get all attendance date
  Future<List<Attendance>> getAllAttendance() async {
    var db = await getDB();
    final attendanceModel = await db.query(ATTENDANCE_TABLE_TITLE);
    List<Attendance> attendanceList =
        attendanceModel
            .map(
              (map) => Attendance(
                date: map[DATE] as String,
                isPresent: map[ISPRESENT] as bool,
              ),
            )
            .toList();
    return attendanceList;
  }

  //get all student
  Future<List<Student>> getAllStudent({required int classID}) async {
    List<Student> students = [];
    var db = await getDB();
    final allStudent = await db.query(
      STUDENT_TABLE_TITLE,
      where: '$CLASS_ID = ?',
      whereArgs: [classID],
    );

    for (final student in allStudent) {
      final studentID = student[STUDENT_ID] as int;
      final attendanceOneStudent = await db.query(
        ATTENDANCE_TABLE_TITLE,
        where: '$STUDENT_ID = ?',
        whereArgs: [studentID],
      );

      final attendanceList =
          attendanceOneStudent
              .map(
                (map) => Attendance(
                  date: map[DATE] as String,
                  isPresent: (map[ISPRESENT] as int) == 1,
                ),
              )
              .toList();

      final ctRows = await db.query(
        CT_TABLE_TITLE,
        where: '$STUDENT_ID = ?',
        whereArgs: [studentID],
      );

      List<int> ctMarks = [0, 0, 0, 0];

      if (ctRows.isNotEmpty) {
        final row = ctRows.first;
        ctMarks = [
          row[CT1] as int,
          row[CT2] as int,
          row[CT3] as int,
          row[CT4] as int,
        ];
      }

      students.add(
        Student(
          classId: student[CLASS_ID] as int,
          roll: student[ROLL] as int,
          attendanceList: attendanceList,
          ctMarks: ctMarks,
          id: studentID,
          name: student[STUDENT_NAME] as String?,
          remarks: student[REMARKS] as String?,
          phone: student[PHONE] as String?,
        ),
      );
    }

    return students;
  }

  //update class
  Future<bool> updateClass(ClassModel classmodel) async {
    final db = await getDB();
    int rowsEffected = await db.update(
      CLASS_TABLE_TITLE,
      {
        SUBJECT_NAME: classmodel.subjectName,
        SECTION: classmodel.section,
        STUDENT_NUMBER: classmodel.noOfStudent,
      },
      where: '$CLASS_ID = ?',
      whereArgs: [classmodel.id],
    );
    return rowsEffected > 0;
  }

  //update student name and info
  Future<bool> updateStudentInfo(
    int studentId,
    String? name,
    String? remarks,
  ) async {
    final db = await getDB();
    final rowsEffected = await db.update(
      STUDENT_TABLE_TITLE,
      {STUDENT_NAME: name, REMARKS: remarks},
      where: '$STUDENT_ID = ?',
      whereArgs: [studentId],
    );
    return rowsEffected > 0;
  }

  //update ct marks
  Future<bool> updateCTMarks(int studentId, List<int> marks) async {
    final db = await getDB();
    return await db.update(
          CT_TABLE_TITLE,
          {CT1: marks[0], CT2: marks[1], CT3: marks[2], CT4: marks[3]},
          where: '$STUDENT_ID = ?',
          whereArgs: [studentId],
        ) >
        0;
  }

  //update attendance
  Future<bool> updateAttendance(
    int studentId,
    String date,
    bool isPresent,
  ) async {
    final db = await getDB();

    final existing = await db.query(
      ATTENDANCE_TABLE_TITLE,
      where: '$STUDENT_ID = ? AND $DATE = ?',
      whereArgs: [studentId, date],
    );

    if (existing.isNotEmpty) {
      // Update if exists
      return await db.update(
            ATTENDANCE_TABLE_TITLE,
            {ISPRESENT: isPresent ? 1 : 0},
            where: '$STUDENT_ID = ? AND $DATE = ?',
            whereArgs: [studentId, date],
          ) >
          0;
    } else {
      // Insert if not exists
      return await db.insert(ATTENDANCE_TABLE_TITLE, {
            STUDENT_ID: studentId,
            DATE: date,
            ISPRESENT: isPresent ? 1 : 0,
          }) >
          0;
    }
  }

  //delete class
  Future<bool> deleteClass({required int id}) async {
    final db = await getDB();
    int rowsEffected = await db.delete(
      CLASS_TABLE_TITLE,
      where: '$CLASS_ID = ?',
      whereArgs: [id],
    );

    return rowsEffected > 0;
  }

  //delete day attendance
  Future<bool> deleteAttendance(String date) async {
    final db = await getDB();
    int rowsEffected = await db.delete(
      ATTENDANCE_TABLE_TITLE,
      where: '$DATE = ?',
      whereArgs: [date],
    );
    return rowsEffected > 0;
  }

  //filter attendance date
  Future<List<String>> getDistinctAttendanceDatesForClass(int classId) async {
    final db = await getDB();

    final result = await db.rawQuery(
      '''
    SELECT DISTINCT a.$DATE
    FROM $ATTENDANCE_TABLE_TITLE a
    JOIN $STUDENT_TABLE_TITLE s ON a.$STUDENT_ID = s.$STUDENT_ID
    WHERE s.$CLASS_ID = ?
    ORDER BY a.$DATE DESC
  ''',
      [classId],
    );

    return result.map((e) => e[DATE] as String).toList();
  }

  //update roll
  Future<void> updateStudentRollsByClass(ClassModel classModel) async {
    final db = await getDB();

    final students = await getAllStudent(classID: classModel.id!);
    int startRoll = 1;
    if (classModel.section != null) {
      if (classModel.section == 'B') {
        startRoll = 61;
      } else if (classModel.section == 'C') {
        startRoll = 121;
      }
    }

    for (int i = 0; i < students.length; i++) {
      int newRoll = startRoll + i;

      await db.update(
        STUDENT_TABLE_TITLE,
        {'$ROLL': newRoll},
        where: '$STUDENT_ID = ?',
        whereArgs: [students[i].id],
      );
    }
  }

  //delete attendance
  Future<int> deleteAttendanceByDate(int classId, String date) async {
    final db = await getDB();

    // Delete using a subquery to filter students of this class
    return await db.delete(
      ATTENDANCE_TABLE_TITLE,
      where: '''
      $DATE = ? AND $STUDENT_ID IN (
        SELECT $STUDENT_ID FROM $STUDENT_TABLE_TITLE
        WHERE $CLASS_ID = ?
      )
    ''',
      whereArgs: [date, classId],
    );
  }

  //get attendance
  Future<Map<int, bool>> getAttendanceForDateAndClass(
    int classId,
    String date,
  ) async {
    final db = await getDB();

    final results = await db.rawQuery(
      '''
    SELECT a.$STUDENT_ID, a.$ISPRESENT
    FROM $ATTENDANCE_TABLE_TITLE a
    JOIN $STUDENT_TABLE_TITLE s ON a.$STUDENT_ID = s.$STUDENT_ID
    WHERE s.$CLASS_ID = ? AND a.$DATE = ?
  ''',
      [classId, date],
    );

    return {
      for (var row in results)
        row['$STUDENT_ID'] as int: (row['$ISPRESENT'] == 1),
    };
  }

  Future<bool> updateStudentPhone(int studentId, String? phone) async {
    final db = await getDB();
    final rowsAffected = await db.update(
      STUDENT_TABLE_TITLE,
      {
        'phone': phone, // Can be null to remove phone
      },
      where: '$STUDENT_ID = ?',
      whereArgs: [studentId],
    );
    return rowsAffected > 0;
  }

  Future<void> deleteDatabaseFile() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String appPath = join(appDir.path, "classM.db");

    await deleteDatabase(appPath);

    print('Database deleted!');
  }
}
