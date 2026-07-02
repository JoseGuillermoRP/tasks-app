class Task {
  String title;
  bool done;

  Task(this.title, {this.done = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(json['title'], done: json['done'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'done': done};
  }
}
