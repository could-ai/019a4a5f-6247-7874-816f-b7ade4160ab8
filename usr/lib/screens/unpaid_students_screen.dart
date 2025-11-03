import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cash_provider.dart';

class UnpaidStudentsScreen extends StatelessWidget {
  const UnpaidStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CashProvider>(context);
    final unpaidStudents = provider.unpaidStudents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unpaid Students'),
      ),
      body: unpaidStudents.isEmpty
          ? const Center(child: Text('All students have paid!'))
          : ListView.builder(
              itemCount: unpaidStudents.length,
              itemBuilder: (context, index) {
                final student = unpaidStudents[index];
                return ListTile(
                  title: Text(student.name),
                  subtitle: Text('${student.className} - ${student.studentId}'),
                );
              },
            ),
    );
  }
}
