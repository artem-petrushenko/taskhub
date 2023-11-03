import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:taskhub/src/common/data/repository/tasks/tasks_repository_impl.dart';

import 'package:taskhub/src/common/data/client/cloud_firestore.dart';
import 'package:taskhub/src/common/data/provider/tasks/remote/tasks_network_data_provider_impl.dart';
import 'package:taskhub/src/common/model/task/task_model.dart';
import 'package:taskhub/src/feature/creator/reducer/creator_reducer.dart';
import 'package:taskhub/src/feature/creator/widget/creator_view.dart';
import 'package:taskhub/src/feature/editor/reducer/editor_reducer.dart';
import 'package:taskhub/src/feature/editor/widget/editor_view.dart';
import 'package:taskhub/src/feature/tasks/reducer/tasks_reducer.dart';
import 'package:taskhub/src/feature/tasks/widget/tasks_view.dart';

abstract class RouteNames {
  static const tasks = '/';
  static const editor = '/editor';
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
      case RouteNames.editor:
        final arguments = settings.arguments;
        final task = arguments is TaskModel ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditor(task: task as TaskModel),
        );
      default:
        const widget = Text("Navigation Error");
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
}

class ScreenFactory {
  Widget makeTasks() {
    final firestore = FirebaseFirestore.instance;

    final tasksRepository = TasksRepositoryImpl(
      tasksNetworkDataProviderImpl: TasksNetworkDataProviderImpl(
        cloudFirestore: CloudFirestore(firestore: firestore),
      ),
    );

    final tasksReducer = TasksReducer(tasksRepository: tasksRepository);
    final store = tasksReducer.createStore();

    return StoreProvider<TasksState>(
      store: store,
      child: const TasksView(),
    );
  }

  Widget makeEditor({
    required TaskModel task,
  }) {
    final firestore = FirebaseFirestore.instance;
    final tasksRepository = TasksRepositoryImpl(
      tasksNetworkDataProviderImpl: TasksNetworkDataProviderImpl(
        cloudFirestore: CloudFirestore(firestore: firestore),
      ),
    );

    final editorReducer = EditorReducer(tasksRepository: tasksRepository);
    final store = editorReducer.createStore();

    return StoreProvider<EditorState>(
      store: store,
      child: EditorView(task: task),
    );
  }

  Widget makeCreator() {
    final firestore = FirebaseFirestore.instance;

    final tasksRepository = TasksRepositoryImpl(
      tasksNetworkDataProviderImpl: TasksNetworkDataProviderImpl(
        cloudFirestore: CloudFirestore(firestore: firestore),
      ),
    );

    final creatorReducer = CreatorReducer(tasksRepository: tasksRepository);
    final store = creatorReducer.createStore();

    return StoreProvider<CreatorState>(
      store: store,
      child: const CreatorView(),
    );
  }
}
