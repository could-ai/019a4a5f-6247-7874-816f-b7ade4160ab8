import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cash_provider.dart';
import '../models/student.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _studentIdController = TextEditingController();
  Student? _editingStudent;

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _classController.clear();
    _studentIdController.clear();
    _editingStudent = null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<CashProvider>(context, listen: false);
      final name = _nameController.text.trim();
      final className = _classController.text.trim();
      final studentId = _studentIdController.text.trim();

      if (_editingStudent != null) {
        provider.updateStudent(_editingStudent!.id, name, className, studentId);
      } else {
        provider.addStudent(name, className, studentId);
      }

      _clearForm();
      Navigator.of(context).pop();
    }
  }

  void _showStudentDialog([Student? student]) {
    if (student != null) {
      _editingStudent = student;
      _nameController.text = student.name;
      _classController.text = student.className;
      _studentIdController.text = student.studentId;
    } else {
      _clearForm();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_editingStudent != null ? 'Edit Student' : 'Add Student'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _classController,
                decoration: const InputDecoration(labelText: 'Class'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _studentIdController,
                decoration: const InputDecoration(labelText: 'Student ID'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
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
            child: Text(_editingStudent != null ? 'Update' : 'Add'),
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
        title: const Text('Students'),
      ),
      body: provider.students.isEmpty
          ? const Center(child: Text('No students added yet.'))
          : ListView.builder(
              itemCount: provider.students.length,
              itemBuilder: (context, index) {
                final student = provider.students[index];
                return ListTile(
                  title: Text(student.name),
                  subtitle: Text('${student.className} - ${student.studentId}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showStudentDialog(student),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(student),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStudentDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<CashProvider>(context, listen: false).deleteStudent(student.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
