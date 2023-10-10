import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          title: const Text('Task Creator'),
          actions: [
            TextButton(
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
                initial: (state) => const Text('Create'),
                loading: (state) => const Text('Loading'),
                success: (state) => const Text('Loading'),
                failure: (state) => const Text('Failure'),
              ),
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 8.0, bottom: 32.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TitleTextFormField(nameController: nameController),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Expanded(
                          child: PriorityTextFormField(
                              priorityController: priorityController),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: CategoryTextFormField(
                              categoryController: categoryController),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    DueDateTextFormField(dueDateController: dueDateController),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: DescriptionTextFormField(
                          descriptionController: descriptionController),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DescriptionTextFormField extends StatelessWidget {
  const DescriptionTextFormField({
    super.key,
    required this.descriptionController,
  });

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        hintText: 'Description',
      ),
      expands: true,
      maxLines: null,
      textAlignVertical: TextAlignVertical.top,
      maxLength: 1000,
      validator: (String? value) {
        if (value!.isNotEmpty && value.length > 1000) {
          return 'Description should not exceed 1000 characters.';
        }
        return null;
      },
    );
  }
}

class PriorityTextFormField extends StatelessWidget {
  const PriorityTextFormField({
    super.key,
    required this.priorityController,
  });

  final TextEditingController priorityController;

  @override
  Widget build(BuildContext context) {
    final priority = <String>['High', 'Medium', 'Low'];

    Future<void> openPriorityDialog() async {
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
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ).then((value) {
        if (value != null) {
          priorityController.text = value;
        }
      });
    }

    return TextFormField(
      controller: priorityController,
      showCursor: false,
      readOnly: true,
      onTap: () async => await openPriorityDialog(),
      decoration: const InputDecoration(
        hintText: 'Priority',
      ),
      validator: (String? value) {
        if (value == null || value == '') {
          return 'Priority is required.';
        }
        return null;
      },
    );
  }
}

class TitleTextFormField extends StatelessWidget {
  const TitleTextFormField({
    super.key,
    required this.nameController,
  });

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: const InputDecoration(
        hintText: 'Title',
      ),
      keyboardType: TextInputType.text,
      maxLength: 100,
      validator: (String? value) {
        if (value == null || value == '') {
          return 'Title is required.';
        } else if (value.length > 100) {
          return 'Title should not exceed 100 characters.';
        }
        return null;
      },
    );
  }
}

class CategoryTextFormField extends StatelessWidget {
  const CategoryTextFormField({
    super.key,
    required this.categoryController,
  });

  final TextEditingController categoryController;

  @override
  Widget build(BuildContext context) {
    final categories = <String>['Work', 'Home', 'Other'];

    Future<void> openCategoryDialog() async {
      await showDialog<String?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select a Category'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: categories
                  .map((e) => ListTile(
                      title: Text(e),
                      onTap: () => Navigator.of(context).pop(e)))
                  .toList(),
            ),
          );
        },
      ).then((value) {
        if (value != null) {
          categoryController.text = value;
        }
      });
    }

    return TextFormField(
      controller: categoryController,
      showCursor: false,
      readOnly: true,
      onTap: () async => await openCategoryDialog(),
      decoration: const InputDecoration(
        hintText: 'Category',
      ),
      validator: (String? value) {
        if (value == null || value == '') {
          return 'Category is required.';
        }
        return null;
      },
    );
  }
}

class DueDateTextFormField extends StatelessWidget {
  const DueDateTextFormField({
    super.key,
    required this.dueDateController,
  });

  final TextEditingController dueDateController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dueDateController,
      decoration: const InputDecoration(
        hintText: 'Due Date',
      ),
      showCursor: false,
      readOnly: true,
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
          lastDate: DateTime(date.year + 10, date.month, date.day),
        ).then(
          (date) {
            if (date != null) {
              dueDateController.text = DateFormat.yMMMd().format(date);
            }
          },
        );
      },
    );
  }
}
