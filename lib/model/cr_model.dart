import 'package:class_management/database/database_helper.dart';

class CrModel {
  final int id; // student ID
  final int classId;
  final int roll;
  final String phone;

  CrModel({
    required this.id,
    required this.classId,
    required this.roll,
    required this.phone,
  });

  Map<String, dynamic> toMap() => {
        '${DBHelper.STUDENT_ID}': id,
         '${DBHelper.CLASS_ID}': classId,
         '${DBHelper.ROLL}': roll,
        'phone': phone,
      };

  factory CrModel.fromMap(Map<String, dynamic> map) {
    return CrModel(
      id: map['${DBHelper.STUDENT_ID}'],
      classId: map['${DBHelper.CLASS_ID}'],
      roll: map['${DBHelper.ROLL}'],
      phone: map['phone'],
    );
  }
}
