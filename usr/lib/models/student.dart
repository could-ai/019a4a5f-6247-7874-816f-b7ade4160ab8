class Student {
  final String id;
  final String name;
  final String className;
  final String studentId;

  Student({
    required this.id,
    required this.name,
    required this.className,
    required this.studentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'className': className,
      'studentId': studentId,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      className: map['className'],
      studentId: map['studentId'],
    );
  }
}
