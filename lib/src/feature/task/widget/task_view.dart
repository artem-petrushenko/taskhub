import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskhub/src/feature/task/bloc/task_bloc.dart';

class TaskView extends StatelessWidget {
  const TaskView({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskBloc>().state;
    return Scaffold(
      body: Center(
        child: state.map(
          loading: (state) => const CircularProgressIndicator(),
          success: (state) => CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(taskId),
              ),
              SliverList.list(
                children: [
                  Text(state.task.title),
                ],
              ),
            ],
          ),
          failure: (state) => Text(
            'Failure ${state.error}',
          ),
        ),
      ),
    );
  }
}
