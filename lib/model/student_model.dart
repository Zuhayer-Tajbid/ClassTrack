import 'package:class_management/model/attendance_model.dart';

class Student{

 Student({this.id,required this.classId,required this.roll, this.attendanceList=const [],this.ctMarks = const [0, 0, 0, 0],this.name,this.remarks,  this.phone,});

final int ?id;
final int classId;
final String ?name;
final int roll;
final String? remarks;
 final String? phone;
 final List<Attendance> attendanceList;
final List<int>  ctMarks;
}