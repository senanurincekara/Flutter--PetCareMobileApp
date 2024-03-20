class Task {
  int? id;
  late String title;
  late String note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? remind;
  String? repeat;
  String? completedAt;
  String? createdAt;
  String? updatedAt;

  Task({
    this.id,
    required this.title,
    required this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.remind,
    this.repeat,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    remind = json['remind'];
    repeat = json['repeat'];
    completedAt = json['completedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['isCompleted'] = isCompleted;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['remind'] = remind;
    data['repeat'] = repeat;
    data['completedAt'] = completedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
