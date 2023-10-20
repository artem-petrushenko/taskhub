import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';
import 'package:taskhub/src/feature/tasks/bloc/tasks_bloc.dart';
import 'package:taskhub/src/common/widget/navigation/navigation.dart';
import 'package:taskhub/src/feature/tasks/scope/tasks_scope.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((TasksBloc bloc) => bloc.state);
    return RefreshIndicator(
      onRefresh: () async => TasksScope.fetchTasks(context, null),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TaskHub'),
        ),
        body: Center(
          child: state.map(
            loading: (state) => const CircularProgressIndicator(),
            success: (state) => CustomScrollView(
              slivers: [
                SliverList.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= state.tasks.length - 1) {
                      TasksScope.fetchTasks(context, state.tasks[index].taskId);
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Dismissible(
                        key: Key(state.tasks[index].taskId),
                        onDismissed: (direction) {
                          HapticFeedback.vibrate();
                          TasksScope.removeTask(
                              context, state.tasks[index].taskId);
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
                          onTap: () async {
                            HapticFeedback.vibrate();
                            Navigator.pushNamed(
                              context,
                              RouteNames.editor,
                              arguments: state.tasks[index],
                            ).then(
                              (value) {
                                if (value == null) return;
                                if (value is String) {
                                  TasksScope.removeTask(context, value);
                                } else if (value is TaskModel) {
                                  TasksScope.updateReturnTask(context, value);
                                }
                              },
                            );
                          },
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
                                HapticFeedback.vibrate();
                                TasksScope.updateTask(
                                  context,
                                  state.tasks[index].taskId,
                                  !state.tasks[index].completed,
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
            Navigator.pushNamed(context, RouteNames.creator).then((task) {
              if (task == null) return;
              TasksScope.addTask(context, task as TaskModel);
            });
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
                    } on Object catch (error, stackTrace) {
                      Error.throwWithStackTrace(error, stackTrace);
                    }
                  },
                  icon: const Icon(Icons.add)),
            ],
          ),
        ),
      ),
    );
  }
}
