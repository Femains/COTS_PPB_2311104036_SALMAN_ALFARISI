import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_models.dart';

class TaskService {
  static const String baseUrl = 'https://rpblbedyqmnzpowbumzd.supabase.co/rest/v1';
  static const String apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwYmxiZWR5cW1uenBvd2J1bXpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxMjcxMjYsImV4cCI6MjA3MzcwMzEyNn0.QaMJlyqhZcPorbFUpImZAynz3o2l0xDfq_exf2wUrTs';

  static Map<String, String> headers() => {
        'apikey': apiKey,
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      };

  static Future<List<Task>> getAllTasks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks?select=*&order=deadline.asc'),
      headers: headers(),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  static Future<void> addTask({
    required String title,
    required String course,
    required String deadline,
    required String note,
  }) async {
    await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: headers(),
      body: jsonEncode({
        'title': title,
        'course': course,
        'deadline': deadline,
        'note': note,
        'is_done': false,
      }),
    );
  }

  static Future<void> updateTaskStatus({required int id, required bool isDone}) async {
    await http.patch(
      Uri.parse('$baseUrl/tasks?id=eq.$id'),
      headers: headers(),
      body: jsonEncode({'is_done': isDone}),
    );
  }

  static Future<void> deleteTask(int id) async {
    await http.delete(
      Uri.parse('$baseUrl/tasks?id=eq.$id'),
      headers: headers(),
    );
  }
}