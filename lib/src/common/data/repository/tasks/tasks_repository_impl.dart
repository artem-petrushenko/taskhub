import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskhub/src/common/data/repository/tasks/tasks_repository.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';

import 'package:taskhub/src/common/data/provider/tasks/remote/tasks_network_data_provider_impl.dart';

@immutable
class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl({
    required TasksNetworkDataProviderImpl tasksNetworkDataProviderImpl,
  }) : _tasksNetworkDataProviderImpl = tasksNetworkDataProviderImpl;

  final TasksNetworkDataProviderImpl _tasksNetworkDataProviderImpl;

  @override
  Future<TaskModel> createTask({
    required TaskModel task,
  }) async {
    final taskId = await _tasksNetworkDataProviderImpl.createTask(task: task);
    return await _tasksNetworkDataProviderImpl.fetchTask(taskId: taskId);
  }

  @override
  Future<void> deleteTask({
    required String taskId,
  }) async {
    await _tasksNetworkDataProviderImpl.deleteTask(taskId: taskId);
  }

  @override
  Future<TaskModel> fetchTask({
    required String taskId,
  }) async {
    return await _tasksNetworkDataProviderImpl.fetchTask(taskId: taskId);
  }

  @override
  Future<Iterable<TaskModel>> fetchTasks({
    required String uid,
    String? taskId,
  }) async {
    return await _tasksNetworkDataProviderImpl.fetchTasks(
      uid: uid,
      taskId: taskId,
    );
  }

  @override
  Future<void> updateTask({
    required TaskModel task,
  }) async {
    await _tasksNetworkDataProviderImpl.updateTask(task: task);
  }
}
