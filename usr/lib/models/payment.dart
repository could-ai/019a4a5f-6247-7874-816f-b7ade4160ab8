class Payment {
  final String id;
  final String studentId;
  final double amount;
  final DateTime date;

  Payment({
    required this.id,
    required this.studentId,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      studentId: map['studentId'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}
