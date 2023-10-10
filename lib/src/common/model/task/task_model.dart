import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';

part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory TaskModel({
    required final String category,
    required final bool completed,
    required final String description,
    required final DateTime dueDate,
    required final String priority,
    required final String taskId,
    required final String title,
    required final String uid,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  factory TaskModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return TaskModel(
      uid: data!['uid'] as String,
      category: data['category'] as String,
      description: data['description'] as String,
      dueDate: (data['due_date'] as Timestamp).toDate(),
      priority: data['priority'] as String,
      taskId: data['task_id'] as String,
      title: data['title'] as String,
      completed: data['completed'] as bool,
    );
  }
}
