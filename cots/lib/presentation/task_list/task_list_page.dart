import 'package:flutter/material.dart';
import '../../services/task_services.dart';
import '../../models/task_models.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../task_detail/task_detail_page.dart';
import '../task_add/task_add_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> allTasks = [];
  List<Task> filteredTasks = [];
  bool loading = true;
  String searchQuery = "";
  String filterStatus = "Semua";

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() => loading = true);
    final result = await TaskService.getAllTasks();
    setState(() {
      allTasks = result;
      _applyFilter();
      loading = false;
    });
  }

  void _applyFilter() {
    setState(() {
      filteredTasks = allTasks.where((task) {
        final matchesSearch = task.title.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesFilter = filterStatus == "Semua" || task.getStatusLabel() == filterStatus;
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final refresh = await Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskAddPage()));
          if (refresh == true) fetchTasks();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari tugas...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onChanged: (val) {
                      searchQuery = val;
                      _applyFilter();
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                DropdownButton<String>(
                  value: filterStatus,
                  items: ['Semua', 'Berjalan', 'Selesai', 'Terlambat']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      filterStatus = val;
                      _applyFilter();
                    }
                  },
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : filteredTasks.isEmpty
                    ? const Center(child: Text("Tidak ada tugas ditemukan"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              title: Text(task.title, style: AppTypography.subHeading),
                              subtitle: Text('${task.course}\nDeadline: ${task.deadline}', style: AppTypography.caption),
                              isThreeLine: true,
                              trailing: _statusBadge(task),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)),
                                );
                                fetchTasks();
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(Task task) {
    final status = task.getStatusLabel();
    Color color = AppColors.primary;
    if (status == 'Selesai') color = AppColors.secondary;
    if (status == 'Terlambat') color = AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}