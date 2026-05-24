import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// ADD TASK
  // Future<void> addTask({
  //   required String title,
  //   required String date,
  //   required String time,
  // }) async {
  //   await firestore.collection('users').doc(uid).collection('tasks').add({
  //     'title': title,
  //     'date': date,
  //     'time': time,
  //     'isDone': false,
  //     'createdAt': Timestamp.now(),
  //   });
  // }

Future<void> addTask({
    required String title,
    required String date,
    required String time,
  }) async {
    try {
      await firestore.collection('users').doc(uid).collection('tasks').add({
        'title': title,
        'date': date,
        'time': time,
        'isDone': false,
        'createdAt': Timestamp.now(),
      });

      print("TASK ADDED SUCCESS");
    } catch (e) {
      print("ADD TASK ERROR: $e");
    }
  }
  
    /// DELETE TASK
  Future<void> deleteTask(String taskId) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  /// UPDATE TASK
  Future<void> updateTask({
    required String taskId,
    required String title,
  }) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({'title': title});
  }

  /// TOGGLE TASK
  Future<void> toggleTask({
    required String taskId,
    required bool isDone,
  }) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({'isDone': !isDone});
  }
}
