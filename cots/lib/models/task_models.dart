class Task {
  final int id;
  final String title;
  final String course;
  final String deadline; // format YYYY-MM-DD
  final String note;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.note,
    required this.isDone,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      course: json['course'],
      deadline: json['deadline'],
      note: json['note'] ?? '',
      isDone: json['is_done'] ?? false,
    );
  }

  String getStatusLabel() {
    final today = DateTime.now();
    final taskDeadline = DateTime.parse(deadline);

    if (isDone) return 'Selesai';
    if (taskDeadline.isBefore(DateTime(today.year, today.month, today.day))) return 'Terlambat';
    return 'Berjalan';
  }
}
