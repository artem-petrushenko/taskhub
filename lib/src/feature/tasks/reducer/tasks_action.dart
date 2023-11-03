part of 'tasks_reducer.dart';

class FetchTasksAction extends ReduxAction<TasksState> {
  final String? taskId;

  FetchTasksAction({this.taskId});

  @override
  TasksRepository get env => super.env as TasksRepository;

  @override
  Future<TasksState> reduce() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final tasks = await env.fetchTasks(
        uid: uid,
        taskId: taskId,
      );
      if (store.state is _Success) {
        if ((store.state as _Success).hasReachedMax) {
          return (store.state as _Success);
        }
        return tasks.isEmpty
            ? (store.state as _Success).copyWith(hasReachedMax: true)
            : (store.state as _Success).copyWith(
                tasks: (store.state as _Success).tasks + tasks.toList(),
                hasReachedMax: false,
              );
      } else {
        final newState = tasks.isEmpty
            ? const _Empty()
            : _Success(tasks: tasks.toList(), hasReachedMax: false);
        return newState;
      }
    } on Object catch (error) {
      return _Failure(error: error);
    }
  }
}

class RemoveTaskAction extends ReduxAction<TasksState> {
  final String taskId;

  RemoveTaskAction({required this.taskId});

  @override
  TasksRepository get env => super.env as TasksRepository;

  @override
  Future<TasksState> reduce() async {
    try {
      final currentTaskId = taskId;
      await env.deleteTask(taskId: currentTaskId);
      final updatedTasks = (state as _Success)
          .tasks
          .where((task) => task.taskId != currentTaskId)
          .toList();

      if (updatedTasks.isEmpty) {
        return const _Empty();
      } else {
        return (state as _Success).copyWith(tasks: updatedTasks);
      }
    } on Object catch (error) {
      return _Failure(error: error);
    }
  }
}

class AddTaskAction extends ReduxAction<TasksState> {
  final TaskModel task;

  AddTaskAction({required this.task});

  @override
  TasksRepository get env => super.env as TasksRepository;

  @override
  Future<TasksState> reduce() async {
    try {
      if (state is _Success) {
        List<TaskModel> list = List.from((state as _Success).tasks)
          ..add(task)
          ..sort((a, b) {
            if (a.dueDate == null && b.dueDate == null) {
              return 0; // Both dates are null, consider them equal.
            } else if (a.dueDate == null) {
              return 1; // 'a' is null, so 'b' comes before 'a'.
            } else if (b.dueDate == null) {
              return -1; // 'b' is null, so 'a' comes before 'b'.
            } else {
              return a.dueDate!
                  .compareTo(b.dueDate!); // Compare non-null dates.
            }
          });
        return (state as _Success).copyWith(tasks: list);
      } else {
        return _Success(tasks: [task], hasReachedMax: true);
      }
    } on Object catch (error) {
      return _Failure(error: error);
    }
  }
}

class UpdateTaskAction extends ReduxAction<TasksState> {
  final String taskId;
  final bool value;

  UpdateTaskAction({
    required this.taskId,
    required this.value,
  });

  @override
  TasksRepository get env => super.env as TasksRepository;

  @override
  Future<TasksState> reduce() async {
    try {
      final updatedTasks = (state as _Success).tasks.map((task) {
        if (task.taskId == taskId) {
          return task.copyWith(completed: value);
        }
        return task;
      }).toList();

      await env.updateTask(
          task: updatedTasks.singleWhere((task) => task.taskId == taskId));
      return (state as _Success).copyWith(tasks: updatedTasks);
    } on Object catch (error) {
      return _Failure(error: error);
    }
  }
}

class UpdateReturnedTaskAction extends ReduxAction<TasksState> {
  final TaskModel task;

  UpdateReturnedTaskAction({required this.task});

  @override
  TasksRepository get env => super.env as TasksRepository;

  @override
  Future<TasksState> reduce() async {
    try {
      final updatedTasks = (state as _Success).tasks.map((currentTask) {
        if (currentTask.taskId == task.taskId) {
          return currentTask = task;
        }
        return currentTask;
      }).toList();

      await env.updateTask(
          task: updatedTasks
              .singleWhere((currentTask) => currentTask.taskId == task.taskId));
      return (state as _Success).copyWith(tasks: updatedTasks);
    } on Object catch (error) {
      return _Failure(error: error);
    }
  }
}
