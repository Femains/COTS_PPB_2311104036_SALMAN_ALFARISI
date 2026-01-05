import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/task_services.dart';
import '../../design_system/spacing.dart';
import '../../design_system/colors.dart';

class TaskAddPage extends StatefulWidget {
  const TaskAddPage({super.key});

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final courseController = TextEditingController();
  final deadlineController = TextEditingController();
  final noteController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        deadlineController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul Tugas', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(labelText: 'Mata Kuliah', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: deadlineController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                onTap: _selectDate,
                validator: (value) => value == null || value.isEmpty ? 'Pilih tanggal' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Catatan (opsional)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await TaskService.addTask(
                        title: titleController.text,
                        course: courseController.text,
                        deadline: deadlineController.text,
                        note: noteController.text,
                      );
                      
                      if (!mounted) return;
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text('Simpan Tugas', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}