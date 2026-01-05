import 'package:flutter/material.dart';
import '../../services/task_services.dart';
import '../../models/task_models.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../task_list/task_list_page.dart';
import '../task_add/task_add_page.dart';
import '../task_detail/task_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Task> tasks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      final data = await TaskService.getAllTasks();
      setState(() {
        tasks = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int selesai = tasks.where((t) => t.isDone).length;
    int berjalan = tasks.where((t) => !t.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Tugas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  Text('Ringkasan Tugas', style: AppTypography.heading),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Statistik Cards
                  Row(
                    children: [
                      _infoCard('Total', tasks.length, AppColors.textPrimary),
                      _infoCard('Selesai', selesai, AppColors.secondary),
                      _infoCard('Berjalan', berjalan, AppColors.primary),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tugas Terbaru', style: AppTypography.subHeading),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TaskListPage()),
                        ).then((_) => loadData()),
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),

                  // List Singkat
                  ...tasks.take(3).map((task) => Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      title: Text(task.title, style: AppTypography.subHeading),
                      subtitle: Text(task.course),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)),
                      ).then((_) => loadData()),
                    ),
                  )),

                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TaskAddPage()),
                    ).then((_) => loadData()),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Tugas Baru'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoCard(String title, int value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Text(title, style: AppTypography.caption, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value.toString(),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}