import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskhub/src/common/data/repository/tasks/tasks_repository_impl.dart';

import 'package:taskhub/src/common/data/client/cloud_firestore.dart';
import 'package:taskhub/src/common/data/provider/tasks/remote/tasks_network_data_provider_impl.dart';
import 'package:taskhub/src/feature/creator/bloc/creator_bloc.dart';
import 'package:taskhub/src/feature/creator/widget/creator_view.dart';
import 'package:taskhub/src/feature/editor/bloc/editor_bloc.dart';
import 'package:taskhub/src/feature/editor/widget/editor_view.dart';
import 'package:taskhub/src/feature/task/bloc/task_bloc.dart';
import 'package:taskhub/src/feature/task/widget/task_view.dart';
import 'package:taskhub/src/feature/tasks/bloc/tasks_bloc.dart';
import 'package:taskhub/src/feature/tasks/widget/tasks_view.dart';

abstract class RouteNames {
  static const tasks = '/';
  static const task = '/task';
  static const editor = '/task/editor';
  static const creator = '/creator';
}

class Navigation {
  static final _screenFactory = ScreenFactory();
  final routes = <String, Widget Function(BuildContext)>{
    RouteNames.tasks: (_) => _screenFactory.makeTasks(),
    RouteNames.creator: (_) => _screenFactory.makeCreator(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.task:
        final arguments = settings.arguments;
        final taskId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeTask(taskId: taskId),
        );
      case RouteNames.editor:
        final arguments = settings.arguments;
        final taskId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditor(taskId: taskId),
        );
      default:
        const widget = Text("Navigation Error");
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
}

class ScreenFactory {
  Widget makeTasks() {
    return BlocProvider<TasksBloc>(
      create: (_) => TasksBloc(
        tasksRepository: const TasksRepositoryImpl(
          tasksNetworkDataProviderImpl: TasksNetworkDataProviderImpl(
            cloudFirestore: CloudFirestore(),
          ),
        ),
      )..add(const TasksEvent.fetchTasks()),
      child: const TasksView(),
    );
  }

  Widget makeEditor({
    required String taskId,
  }) {
    return BlocProvider<EditorBloc>(
      create: (_) => EditorBloc(
        tasksRepository: const TasksRepositoryImpl(
          tasksNetworkDataProviderImpl: TasksNetworkDataProviderImpl(
            cloudFirestore: CloudFirestore(),
          ),
        ),
      ),
      child: EditorView(taskId: taskId),
    );
  }

  Widget makeCreator() {
    return BlocProvider<CreatorBloc>(
      create: (_) => CreatorBloc(
        tasksRepository: const TasksRepositoryImpl(
          tasksNetworkDataProviderImpl: TasksNetworkDataProviderImpl(
            cloudFirestore: CloudFirestore(),
          ),
        ),
      ),
      child: const CreatorView(),
    );
  }

  Widget makeTask({
    required String taskId,
  }) {
    return BlocProvider<TaskBloc>(
      create: (_) => TaskBloc(
        tasksRepository: const TasksRepositoryImpl(
          tasksNetworkDataProviderImpl: TasksNetworkDataProviderImpl(
            cloudFirestore: CloudFirestore(),
          ),
        ),
      )..add(TaskEvent.fetchTask(taskId: taskId)),
      child: TaskView(taskId: taskId),
    );
  }
}
