import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';
import 'package:taskhub/src/feature/creator/bloc/creator_bloc.dart';

class CreatorView extends StatefulWidget {
  const CreatorView({super.key});

  @override
  State<CreatorView> createState() => _CreatorViewState();
}

class _CreatorViewState extends State<CreatorView> {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final dueDateController = TextEditingController();
    final categoryController = TextEditingController();
    final priorityController = TextEditingController();

    final state = context.watch<CreatorBloc>().state;
    final formKey = GlobalKey<FormState>();
    Completer<String?> categoryCompleter = Completer<String?>();
    List<String> categories = ['Work', 'Home', 'Other'];

    Completer<String?> priorityCompleter = Completer<String?>();
    List<String> priority = ['High', 'Medium', 'Low'];

    Future<String?> openPriorityDialog() async {
      priorityCompleter = Completer<String?>();
      await showDialog<String?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select a Priority'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: priority
                  .map(
                    (e) => ListTile(
                      title: Text(e),
                      onTap: () {
                        Navigator.of(context).pop(e);
                        priorityCompleter.complete(e);
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      return priorityCompleter.future;
    }

    Future<String?> openCategoryDialog() async {
      categoryCompleter = Completer<String?>();
      await showDialog<String?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select a Category'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: categories
                  .map(
                    (e) => ListTile(
                      title: Text(e),
                      onTap: () {
                        Navigator.of(context).pop(e);
                        categoryCompleter.complete(e);
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      return categoryCompleter.future;
    }

    return BlocListener<CreatorBloc, CreatorState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (state) => Navigator.pop(context, state.task),
          failure: (state) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.toString())),
          ),
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Editor'),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                      maxLength: 100,
                      validator: (String? value) {
                        if (value == null || value == '') {
                          return 'Title is required.';
                        } else if (value.length > 100) {
                          return 'Title should not exceed 100 characters.';
                        }
                        return null;
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                        ),
                        expands: true,
                        maxLines: null,
                        maxLength: 1000,
                        validator: (String? value) {
                          if (value!.isNotEmpty && value.length > 1000) {
                            return 'Description should not exceed 1000 characters.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: priorityController,
                            onTap: () async {
                              String? priority = await openPriorityDialog();
                              if (priority != null) {
                                priorityController.text = priority;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Priority',
                            ),
                            validator: (String? value) {
                              if (value == null || value == '') {
                                return 'Priority is required.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: TextFormField(
                            controller: categoryController,
                            onTap: () async {
                              String? category = await openCategoryDialog();
                              if (category != null) {
                                categoryController.text = category;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Category',
                            ),
                            validator: (String? value) {
                              if (value == null || value == '') {
                                return 'Category is required.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: dueDateController,
                      decoration: const InputDecoration(
                        hintText: 'Due Date',
                      ),
                      validator: (String? value) {
                        if (value != null) {
                          final now = DateTime.now();
                          if (DateFormat.yMMMd().parse(value).isBefore(now)) {
                            return 'Due date must be in the future.';
                          }
                        }
                        return null;
                      },
                      onTap: () {
                        final date = DateTime.now();
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime(date.year + 10, date.month, date.day),
                        ).then(
                          (date) {
                            if (date != null) {
                              dueDateController.text =
                                  DateFormat.yMMMd().format(date);
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 80.0),
                  ],
                ),
              ),
            ),
            FilledButton.tonal(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  state.maybeMap(
                    initial: (state) async {
                      final newTask = TaskModel(
                        category: categoryController.text,
                        completed: false,
                        description: descriptionController.text,
                        dueDate:
                            DateFormat.yMMMd().parse(dueDateController.text),
                        priority: priorityController.text,
                        taskId: '',
                        title: nameController.text,
                        uid: '',
                      );
                      context
                          .read<CreatorBloc>()
                          .add(CreatorEvent.createTask(task: newTask));
                    },
                    orElse: () => null,
                  );
                }
              },
              child: state.map(
                initial: (state) => const Text('Create Task'),
                loading: (state) => const CircularProgressIndicator(),
                success: (state) => const Icon(Icons.more_horiz_sharp),
                failure: (state) => const Icon(Icons.sms_failed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
