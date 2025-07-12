class ClassModel {
  ClassModel({
   this.id,
    required this.subjectName,
   this.section,
    required this.noOfStudent,
  });
  final int ?id;
  final String subjectName;
  final String ?section;
  final int noOfStudent;
}
