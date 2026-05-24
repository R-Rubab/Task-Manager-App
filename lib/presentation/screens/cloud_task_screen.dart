import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudTaskScreen extends StatefulWidget {
  const CloudTaskScreen({super.key});

  @override
  State<CloudTaskScreen> createState() => _CloudTaskScreenState();
}

class _CloudTaskScreenState extends State<CloudTaskScreen> {
  final TextEditingController controller = TextEditingController();

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addTask() async {
    if (controller.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .add({
          'title': controller.text.trim(),
          'isDone': false,
          'createdAt': Timestamp.now(),
        });

    controller.clear();
  }

  Future<void> deleteTask(String taskId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  Future<void> toggleTask(String taskId, bool value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({'isDone': value});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cloud Firestore Tasks")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text("Add Task"),

                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: "Enter task"),
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      await addTask();
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },

        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('tasks')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No Tasks Found"));
          }

          return ListView.builder(
            itemCount: docs.length,

            itemBuilder: (_, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  leading: Checkbox(
                    value: data['isDone'] ?? false,

                    onChanged: (value) {
                      toggleTask(docs[index].id, value ?? false);
                    },
                  ),

                  title: Text(
                    data['title'] ?? '',
                    style: TextStyle(
                      decoration: (data['isDone'] ?? false)
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),

                    onPressed: () {
                      deleteTask(docs[index].id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
