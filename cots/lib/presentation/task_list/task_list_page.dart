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
    try {
      final result = await TaskService.getAllTasks();
      setState(() {
        allTasks = result;
        _applyFilter();
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
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
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : _buildList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskAddPage()));
          fetchTasks(); // Refresh setelah tambah
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari tugas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                setState(() {
                  filterStatus = val;
                  _applyFilter();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (filteredTasks.isEmpty) return const Center(child: Text("Tidak ada tugas"));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return Dismissible(
          key: Key(task.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (_) => _confirmDeleteDialog(task),
          onDismissed: (_) async {
            await TaskService.deleteTask(task.id);
            allTasks.removeWhere((t) => t.id == task.id);
          },
          child: Card(
            child: ListTile(
              title: Text(task.title, style: AppTypography.subHeading),
              subtitle: Text(task.course),
              trailing: _statusBadge(task),
              onTap: () async {
                
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)),
                );
                fetchTasks(); 
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _confirmDeleteDialog(Task task) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus?'),
        content: Text('Hapus "${task.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );
  }

  Widget _statusBadge(Task task) {
    final status = task.getStatusLabel();
    Color color = status == 'Selesai' ? AppColors.secondary : (status == 'Terlambat' ? AppColors.danger : AppColors.primary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}