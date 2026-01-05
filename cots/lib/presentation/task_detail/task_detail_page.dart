import 'package:flutter/material.dart';
import '../../services/task_services.dart';
import '../../models/task_models.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';

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
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Tugas'),
                  content: const Text('Yakin ingin menghapus?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
                  ],
                ),
              );
              if (confirm == true) {
                await TaskService.deleteTask(widget.task.id);
                if (!mounted) return;
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.task.title, style: AppTypography.heading),
            Text(widget.task.course, style: TextStyle(color: AppColors.primary)),
            const Divider(height: 32),
            _infoRow(Icons.calendar_today, 'Deadline', widget.task.deadline),
            const SizedBox(height: 16),
            _infoRow(Icons.notes, 'Catatan', widget.task.note.isEmpty ? '-' : widget.task.note),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                title: const Text('Tandai Selesai'),
                value: isDone,
                onChanged: (val) async {
                  if (val != null) {
                    setState(() => isDone = val);
                    await TaskService.updateTaskStatus(id: widget.task.id, isDone: isDone);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isDone ? "Tugas Selesai!" : "Status diperbarui")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTypography.caption),
          Text(value, style: AppTypography.body),
        ]),
      ],
    );
  }
}