import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';

import 'package:taskhub/src/common/data/provider/tasks/remote/tasks_network_data_provider.dart';

import 'package:taskhub/src/common/data/client/cloud_firestore.dart';

class TasksNetworkDataProviderImpl implements TasksNetworkDataProvider {
  const TasksNetworkDataProviderImpl({
    required CloudFirestore cloudFirestore,
  }) : _cloudFirestore = cloudFirestore;

  final CloudFirestore _cloudFirestore;

  @override
  Future<void> deleteTask({
    required String taskId,
  }) async {
    final db = FirebaseFirestore.instance;
    await db.collection('tasks').doc(taskId).delete();
  }

  @override
  Future<TaskModel> fetchTask({
    required String taskId,
  }) async {
    final db = FirebaseFirestore.instance;
    final task = await db.collection('tasks').doc(taskId).get();
    return TaskModel.fromFirestore(task);
  }

  @override
  Future<String> createTask({
    required TaskModel task,
  }) async {
    final db = FirebaseFirestore.instance;
    final document = db.collection('tasks').doc();
    await document.set({
      'category': task.category,
      'completed': false,
      'description': task.description,
      'due_date':
          task.dueDate != null ? Timestamp.fromDate(task.dueDate!) : null,
      'priority': task.priority,
      'task_id': document.id,
      'title': task.title,
      'uid': FirebaseAuth.instance.currentUser?.uid,
    });
    return document.id;
  }

  @override
  Future<void> updateTask({required TaskModel task}) async {
    final db = FirebaseFirestore.instance;
    await db.collection('tasks').doc(task.taskId).update(<String, dynamic>{
      'category': task.category,
      'completed': task.completed,
      'description': task.description,
      'due_date':
          task.dueDate != null ? Timestamp.fromDate(task.dueDate!) : null,
      'priority': task.priority,
      'task_id': task.taskId,
      'title': task.title,
      'uid': task.uid,
    });
  }

  @override
  Future<Iterable<TaskModel>> fetchTasks({
    required String uid,
    String? taskId,
  }) async {
    final db = FirebaseFirestore.instance;
    final query = db
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .orderBy('due_date', descending: true);
    final QuerySnapshot<Map<String, dynamic>> response;
    if (taskId != null) {
      final lastChat = await _cloudFirestore.read(
        collection: 'tasks',
        documentId: taskId,
      );
      response = await query.startAfterDocument(lastChat).limit(10).get();
    } else {
      response = await query.limit(10).get();
    }
    return response.docs.map((e) => TaskModel.fromFirestore(e));
  }
}
