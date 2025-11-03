import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cash_provider.dart';
import '../models/payment.dart';
import '../models/student.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedStudentId;
  DateTime _selectedDate = DateTime.now();
  Payment? _editingPayment;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _amountController.clear();
    _selectedStudentId = null;
    _selectedDate = DateTime.now();
    _editingPayment = null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedStudentId != null) {
      final provider = Provider.of<CashProvider>(context, listen: false);
      final amount = double.parse(_amountController.text);

      if (_editingPayment != null) {
        provider.updatePayment(_editingPayment!.id, _selectedStudentId!, amount, _selectedDate);
      } else {
        provider.addPayment(_selectedStudentId!, amount, _selectedDate);
      }

      _clearForm();
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showPaymentDialog([Payment? payment]) {
    final provider = Provider.of<CashProvider>(context, listen: false);
    if (payment != null) {
      _editingPayment = payment;
      _selectedStudentId = payment.studentId;
      _amountController.text = payment.amount.toString();
      _selectedDate = payment.date;
    } else {
      _clearForm();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_editingPayment != null ? 'Edit Payment' : 'Add Payment'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedStudentId,
                decoration: const InputDecoration(labelText: 'Student'),
                items: provider.students.map((student) {
                  return DropdownMenuItem(
                    value: student.id,
                    child: Text(student.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStudentId = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a student' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount (RM)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  final amount = double.tryParse(value!);
                  if (amount == null || amount <= 0) return 'Invalid amount';
                  return null;
                },
              ),
              ListTile(
                title: Text('Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(_editingPayment != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CashProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
      ),
      body: provider.payments.isEmpty
          ? const Center(child: Text('No payments recorded yet.'))
          : ListView.builder(
              itemCount: provider.payments.length,
              itemBuilder: (context, index) {
                final payment = provider.payments[index];
                final student = provider.students.firstWhere(
                  (s) => s.id == payment.studentId,
                  orElse: () => Student(id: '', name: 'Unknown', className: '', studentId: ''),
                );
                return ListTile(
                  title: Text(student.name),
                  subtitle: Text('RM ${payment.amount.toStringAsFixed(2)} - ${payment.date.toLocal().toString().split(' ')[0]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showPaymentDialog(payment),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(payment, student.name),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPaymentDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(Payment payment, String studentName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment'),
        content: Text('Are you sure you want to delete payment of RM ${payment.amount.toStringAsFixed(2)} for $studentName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<CashProvider>(context, listen: false).deletePayment(payment.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
