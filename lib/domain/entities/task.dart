class Task {
  final String id;
  final String title;
  final String time;
  final String date;

  bool isDone;

  Task({
    required this.title,
    required this.time,
    required this.date,
    this.isDone = false, required this.id,
  });
}
