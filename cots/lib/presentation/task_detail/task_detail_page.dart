import 'package:flutter/material.dart';
import '../../services/task_services.dart';
import '../../models/task_models.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late bool isDone;

  @override
  void initState() {
    super.initState();
    isDone = widget.task.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.task.title, style: const TextStyle(fontSize: 20)),
            Text(widget.task.course),
            Text('Deadline: ${widget.task.deadline}'),
            const SizedBox(height: 12),
            Text('Catatan: ${widget.task.note}'),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: isDone,
                  onChanged: (value) async {
                    if (value == null) return;
                    setState(() => isDone = value);
                    await TaskService.updateTaskStatus(id: widget.task.id, isDone: isDone);
                  },
                ),
                const Text('Tandai selesai')
              ],
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
