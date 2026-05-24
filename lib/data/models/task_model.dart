import '../../domain/entities/task.dart';

class TaskModel extends Task {

  TaskModel({
    required super.id,
    required super.title,
    required super.time,
    required super.date,
    super.isDone,
  });

  Map<String, dynamic> toMap() {
    return {'id':id,'title': title, 'time': time, 'date': date, 'isDone': isDone};
  }

TaskModel copyWith({
    String? id,
    String? title,
    String? time,
    String? date,
    bool? isDone,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
    );
  }
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      time: map['time'],
      date: map['date'],
      isDone: map['isDone'],
    );
  }
}
