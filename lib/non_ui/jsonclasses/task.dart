import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable(explicitToJson: true)
class Task {
  String id;
  String title;
  String description;
  @JsonKey(name: 'completed_at')
  DateTime completedAt;

  //
  Task({
    this.id,
    this.title,
    this.description,
    this.completedAt,
  });

  bool get isNew {
    return id == null;
  }

  bool get isCompleted {
    return completedAt != null;
  }

  void toggleComplete() {
    if (isCompleted) {
      completedAt = null;
    } else {
      completedAt = DateTime.now();
    }
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({
    String id,
    String title,
    String description,
    DateTime completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
