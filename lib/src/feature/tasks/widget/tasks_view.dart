import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';
import 'package:taskhub/src/feature/tasks/bloc/tasks_bloc.dart';
import 'package:taskhub/src/common/widget/navigation/navigation.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((TasksBloc bloc) => bloc.state);
    final bloc = context.select((TasksBloc bloc) => bloc);
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<TasksBloc>().add(const TasksEvent.fetchTasks()),
      child: Scaffold(
        body: Center(
          child: state.map(
            loading: (state) => const CircularProgressIndicator(),
            success: (state) => CustomScrollView(
              slivers: [
                const SliverAppBar(
                  title: Text('TaskHub'),
                ),
                SliverList.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= state.tasks.length - 1) {
                      context.read<TasksBloc>().add(TasksEvent.fetchTasks(
                          taskId: state.tasks[index].taskId));
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Dismissible(
                        key: Key(state.tasks[index].taskId),
                        onDismissed: (direction) {
                          HapticFeedback.vibrate();
                          bloc.add(
                            TasksEvent.removeTask(
                              taskId: state.tasks[index].taskId,
                            ),
                          );
                        },
                        direction: DismissDirection.endToStart,
                        background: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.vibrate();
                            Navigator.pushNamed(
                              context,
                              RouteNames.editor,
                              arguments: state.tasks[index],
                            );
                          },
                          child: Card(
                            elevation: 0.0,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: ListTile(
                              title: Text(
                                state.tasks[index].title,
                                style: TextStyle(
                                  decoration: state.tasks[index].completed
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: Text(state.tasks[index].category),
                              trailing: IconButton(
                                onPressed: () {
                                  bloc.add(
                                    TasksEvent.updateTask(
                                      taskId: state.tasks[index].taskId,
                                      value: !state.tasks[index].completed,
                                    ),
                                  );
                                },
                                icon: Icon(
                                  state.tasks[index].completed
                                      ? Icons.check_circle_outline
                                      : Icons.circle_outlined,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (!state.hasReachedMax)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            ),
            empty: (state) => const Text('Empty'),
            failure: (state) => const Text('Failure'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            HapticFeedback.vibrate();
            final task = await Navigator.pushNamed(context, RouteNames.creator)
                as TaskModel?;
            if (task == null) return;
            context.read<TasksBloc>().add(TasksEvent.addTask(task: task));
          },
          child: const Icon(Icons.create),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(
                  onPressed: () async {
                    try {
                      final GoogleSignInAccount? googleUser =
                          await GoogleSignIn().signIn();
                      final GoogleSignInAuthentication? googleAuth =
                          await googleUser?.authentication;
                      final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth?.accessToken,
                        idToken: googleAuth?.idToken,
                      );
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                    } catch (e) {}
                  },
                  icon: const Icon(Icons.add)),
            ],
          ),
        ),
      ),
    );
  }
}
