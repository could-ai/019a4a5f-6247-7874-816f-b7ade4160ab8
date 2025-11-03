import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/payment.dart';
import '../models/purchase.dart';
import 'package:uuid/uuid.dart';

class CashProvider extends ChangeNotifier {
  final List<Student> _students = [];
  final List<Payment> _payments = [];
  final List<Purchase> _purchases = [];

  List<Student> get students => _students;
  List<Payment> get payments => _payments;
  List<Purchase> get purchases => _purchases;

  double get totalCollected => _payments.fold(0, (sum, payment) => sum + payment.amount);
  double get totalExpenses => _purchases.fold(0, (sum, purchase) => sum + purchase.price);
  double get balance => totalCollected - totalExpenses;
  int get totalStudents => _students.length;

  List<Student> get unpaidStudents {
    final paidStudentIds = _payments.map((p) => p.studentId).toSet();
    return _students.where((student) => !paidStudentIds.contains(student.id)).toList();
  }

  void addStudent(String name, String className, String studentId) {
    final student = Student(
      id: const Uuid().v4(),
      name: name,
      className: className,
      studentId: studentId,
    );
    _students.add(student);
    notifyListeners();
  }

  void updateStudent(String id, String name, String className, String studentId) {
    final index = _students.indexWhere((s) => s.id == id);
    if (index != -1) {
      _students[index] = Student(
        id: id,
        name: name,
        className: className,
        studentId: studentId,
      );
      notifyListeners();
    }
  }

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    _payments.removeWhere((p) => p.studentId == id);
    notifyListeners();
  }

  void addPayment(String studentId, double amount, DateTime date) {
    final payment = Payment(
      id: const Uuid().v4(),
      studentId: studentId,
      amount: amount,
      date: date,
    );
    _payments.add(payment);
    notifyListeners();
  }

  void updatePayment(String id, String studentId, double amount, DateTime date) {
    final index = _payments.indexWhere((p) => p.id == id);
    if (index != -1) {
      _payments[index] = Payment(
        id: id,
        studentId: studentId,
        amount: amount,
        date: date,
      );
      notifyListeners();
    }
  }

  void deletePayment(String id) {
    _payments.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void addPurchase(String itemName, double price, DateTime date) {
    final purchase = Purchase(
      id: const Uuid().v4(),
      itemName: itemName,
      price: price,
      date: date,
    );
    _purchases.add(purchase);
    notifyListeners();
  }

  void updatePurchase(String id, String itemName, double price, DateTime date) {
    final index = _purchases.indexWhere((p) => p.id == id);
    if (index != -1) {
      _purchases[index] = Purchase(
        id: id,
        itemName: itemName,
        price: price,
        date: date,
      );
      notifyListeners();
    }
  }

  void deletePurchase(String id) {
    _purchases.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
