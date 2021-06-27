class Task {
  String task;
  DateTime time;

  Task({this.task, this.time});

  // Object to return our model
  factory Task.fromString(String task) {
    return Task(
      task: task,
      time: DateTime.now(),
    );
  }

// Object to parse the json object created
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      task: map['task'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

// json object to hold data that will be sent and saved in 
  Map<String, dynamic> getMap() {
    return {
      'task': this.task,
      'time': this.time.millisecondsSinceEpoch,
    };
  }
}
