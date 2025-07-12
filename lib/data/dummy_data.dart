import 'package:class_management/model/attendance_model.dart';
import 'package:class_management/model/class_model.dart';
import 'package:class_management/model/student_model.dart';

final dummyClass = ClassModel(
  subjectName: 'CSE 2028',
  section: 'A',
  noOfStudent: 60,
);

List<Student> dummyStudents = List.generate(5, (index) {
  return Student(
    classId: 1,
    roll: index + 1,
    name: 'Student ${index + 1}',
    remarks: index % 2 == 0 ? 'Needs improvement' : null,
    ctMarks: [5, 6, 7, 8],
    attendanceList: [Attendance(date: '2025-07-05', isPresent: index % 2 == 0)],
  );
});
