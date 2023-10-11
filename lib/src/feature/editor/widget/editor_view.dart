import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';

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
  bool status = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    dueDateController = TextEditingController(
        text: DateFormat.yMMMd().format(widget.task.dueDate));
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
            DateFormat.yMMMd().format(widget.task.dueDate) ||
        categoryController.text != widget.task.category ||
        priorityController.text != widget.task.priority ||
        status != widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.taskId),
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (hasTaskChanged()) {
                  log('1');
                }
              }
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusCard extends StatefulWidget {
  final bool status;
  final ValueChanged<bool> onStatusChanged;

  const StatusCard({
    Key? key,
    required this.status,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: const Text('Status'),
        subtitle: Text(widget.status ? 'Complete' : 'Not Complete'),
        trailing: IconButton(
          icon: Icon(widget.status
              ? Icons.check_circle_outline
              : Icons.circle_outlined),
          onPressed: () {
            setState(() {
              widget.onStatusChanged(!widget.status);
            });
          },
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
                      }))
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
            if (value != null) {
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
            ).then(
              (date) {
                if (date != null) {
                  dueDateController.text = DateFormat.yMMMd().format(date);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
