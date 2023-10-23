import 'package:taskhub/src/common/model/task/task_model.dart';

abstract interface class TasksRepository {
  Future<Iterable<TaskModel>> fetchTasks({
    required final String uid,
    final String? taskId,
  });

  Future<TaskModel> fetchTask({required final String taskId});

  Future<TaskModel> createTask({required final TaskModel task});

  Future<void> deleteTask({required final String taskId});

  Future<void> updateTask({required final TaskModel task});
}
