import 'package:flutter/material.dart';

class EditorView extends StatelessWidget {
  final String taskId;

  const EditorView({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(taskId),
          ),
        ],
      ),
    );
  }
}
