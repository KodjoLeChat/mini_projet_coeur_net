enum TaskStatus {
  pending(title: 'À faire', description: 'Marquer comme fait'),
  done(title: 'Terminé', description: 'Marquer comme à faire');

  final String title;
  final String description;

  const TaskStatus({required this.title, required this.description});
}

class Task {
  final String? id;
  final String? title;
  final String? userId;
  final String? description;
  final TaskStatus? status;

  Task({this.id, this.title, this.description, this.status, this.userId});

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description, 'status': status?.name}
      ..removeWhere((key, value) => value == null);
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'] as String?,
      description: map['description'] as String?,
      status: TaskStatus.values.firstWhere(
        (value) => value.name == map['status'],
        orElse: () => TaskStatus.pending,
      ),
    );
  }

  @override
  String toString() =>
      'Task(title: $title, description: $description, status: ${status?.name})';

  static Task get mockTask => Task(
    title: "title",
    description: "description" * 15,
    status: TaskStatus.pending,
  );

  static List<Task> mockTaskList([int number = 10]) =>
      List.generate(number, (index) => mockTask);
}
