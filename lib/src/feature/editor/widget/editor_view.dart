import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';

import 'package:taskhub/src/feature/editor/bloc/editor_bloc.dart';
import 'package:taskhub/src/feature/editor/scope/editor_scope.dart';

class EditorView extends StatefulWidget {
  final TaskModel task;

  const EditorView({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController dueDateController;
  late TextEditingController categoryController;
  late TextEditingController priorityController;
  late bool status;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    dueDateController = TextEditingController(
        text: widget.task.dueDate != null
            ? DateFormat.yMMMd().format(widget.task.dueDate!)
            : '');
    categoryController = TextEditingController(text: widget.task.category);
    priorityController = TextEditingController(text: widget.task.priority);
    status = widget.task.completed;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    categoryController.dispose();
    priorityController.dispose();
    super.dispose();
  }

  bool hasTaskChanged() {
    return nameController.text != widget.task.title ||
        descriptionController.text != widget.task.description ||
        dueDateController.text !=
            (widget.task.dueDate != null
                ? DateFormat.yMMMd().format(widget.task.dueDate!)
                : '') ||
        categoryController.text != widget.task.category ||
        priorityController.text != widget.task.priority ||
        status != widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BlocListener<EditorBloc, EditorState>(
      listener: (context, state) {
        state.mapOrNull(
          successRemove: (state) {
            Navigator.pop(context, state.taskId);
          },
          successUpdate: (state) {
            Navigator.pop(context, state.task);
          },
          failure: (state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.toString())),
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.task.taskId),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    TitleTextFormField(nameController: nameController),
                    DescriptionTextFormField(
                        descriptionController: descriptionController),
                    DueDateTextFormField(dueDateController: dueDateController),
                    PriorityTextFormField(
                        priorityController: priorityController),
                    CategoryTextFormField(
                        categoryController: categoryController),
                    StatusCard(
                      status: status,
                      onStatusChanged: (newStatus) {
                        setState(() {
                          status = newStatus;
                        });
                      },
                    ),
                    BlocBuilder<EditorBloc, EditorState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                              child: FilledButton.tonal(
                                onPressed: state.mapOrNull(
                                  initial: (state) => () {
                                    HapticFeedback.vibrate();
                                    if (formKey.currentState!.validate()) {
                                      if (hasTaskChanged()) {
                                        EditorScope.updateTask(
                                          context,
                                          widget.task.copyWith(
                                            category: categoryController.text,
                                            completed: status,
                                            description:
                                                descriptionController.text,
                                            dueDate:
                                                dueDateController.text != ''
                                                    ? DateFormat.yMMMd().parse(
                                                        dueDateController.text)
                                                    : null,
                                            priority: priorityController.text,
                                            title: nameController.text,
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                                child: const Text('Update'),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: FilledButton.tonal(
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                                onPressed: state.mapOrNull(
                                  initial: (state) => () {
                                    HapticFeedback.vibrate();
                                    EditorScope.removeTask(
                                        context, widget.task.taskId);
                                  },
                                ),
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final bool status;
  final ValueChanged<bool> onStatusChanged;

  const StatusCard({
    Key? key,
    required this.status,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: const Text('Status'),
        subtitle: Text(status ? 'Complete' : 'Not Complete'),
        trailing: IconButton(
          icon:
              Icon(status ? Icons.check_circle_outline : Icons.circle_outlined),
          onPressed: () {
            HapticFeedback.vibrate();
            onStatusChanged(!status);
          },
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14.0,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}

class DescriptionTextFormField extends StatelessWidget {
  const DescriptionTextFormField({
    Key? key,
    required this.descriptionController,
  }) : super(key: key);

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: const Text('Description'),
        subtitle: TextFormField(
          controller: descriptionController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          decoration: const InputDecoration(
            hintText: 'Description',
            isDense: true,
            filled: false,
            contentPadding: EdgeInsets.zero,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          maxLines: null,
          textAlignVertical: TextAlignVertical.top,
          maxLength: 1000,
          validator: (String? value) {
            if (value != null && value.isNotEmpty && value.length > 1000) {
              return 'Description should not exceed 1000 characters.';
            }
            return null;
          },
        ),
      ),
    );
  }
}

class PriorityTextFormField extends StatelessWidget {
  const PriorityTextFormField({
    Key? key,
    required this.priorityController,
  }) : super(key: key);

  final TextEditingController priorityController;

  @override
  Widget build(BuildContext context) {
    final priority = <String>['High', 'Medium', 'Low'];

    Future<void> openPriorityDialog() async {
      final value = await showDialog<String?>(
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
      );
      if (value != null) {
        priorityController.text = value;
      }
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: const Text('Priority'),
        subtitle: TextFormField(
          controller: priorityController,
          showCursor: false,
          readOnly: true,
          onTap: () => openPriorityDialog(),
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          decoration: const InputDecoration(
            hintText: 'Priority',
            isDense: true,
            filled: false,
            contentPadding: EdgeInsets.zero,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Priority is required.';
            }
            return null;
          },
        ),
      ),
    );
  }
}

class TitleTextFormField extends StatelessWidget {
  const TitleTextFormField({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: const Text('Title'),
        subtitle: TextFormField(
          controller: nameController,
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          decoration: const InputDecoration(
            hintText: 'Title',
            isDense: true,
            filled: false,
            contentPadding: EdgeInsets.zero,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
          maxLength: 100,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Title is required.';
            } else if (value.length > 100) {
              return 'Title should not exceed 100 characters.';
            }
            return null;
          },
        ),
      ),
    );
  }
}

class CategoryTextFormField extends StatelessWidget {
  const CategoryTextFormField({
    Key? key,
    required this.categoryController,
  }) : super(key: key);

  final TextEditingController categoryController;

  @override
  Widget build(BuildContext context) {
    final categories = <String>['Work', 'Home', 'Other'];

    Future<void> openCategoryDialog() async {
      final value = await showDialog<String?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select a Category'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: categories
                  .map((e) => ListTile(
                        title: Text(e),
                        onTap: () {
                          Navigator.of(context).pop(e);
                        },
                      ))
                  .toList(),
            ),
          );
        },
      );
      if (value != null) {
        categoryController.text = value;
      }
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: const Text('Category'),
        subtitle: TextFormField(
          controller: categoryController,
          showCursor: false,
          readOnly: true,
          onTap: () => openCategoryDialog(),
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          decoration: const InputDecoration(
            hintText: 'Category',
            isDense: true,
            filled: false,
            contentPadding: EdgeInsets.zero,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Category is required.';
            }
            return null;
          },
        ),
      ),
    );
  }
}

class DueDateTextFormField extends StatelessWidget {
  const DueDateTextFormField({
    Key? key,
    required this.dueDateController,
  }) : super(key: key);

  final TextEditingController dueDateController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: const Text('Due Date'),
        subtitle: TextFormField(
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          controller: dueDateController,
          decoration: const InputDecoration(
            hintText: 'Due Date',
            isDense: true,
            filled: false,
            contentPadding: EdgeInsets.zero,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          showCursor: false,
          readOnly: true,
          validator: (String? value) {
            if (value != null && value != '') {
              final now = DateTime.now();
              final selectedDate = DateFormat.yMMMd().parse(value);
              if (selectedDate.isBefore(now)) {
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
            ).then((date) {
              if (date != null) {
                dueDateController.text = DateFormat.yMMMd().format(date);
              }
            });
          },
        ),
      ),
    );
  }
}
