import 'package:flutter/material.dart';
import 'package:flutter_apps/data/models/task_model.dart';
import 'package:flutter_apps/presentation/providers/task_provider.dart';
import 'package:provider/provider.dart';

class ProviderTaskScreen extends StatefulWidget {
  const ProviderTaskScreen({super.key});

  @override
  State<ProviderTaskScreen> createState() => _ProviderTaskScreenState();
}

class _ProviderTaskScreenState extends State<ProviderTaskScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            "Add New Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: TextField(
            controller: controller,

            decoration: InputDecoration(
              hintText: "Enter task...",
              prefixIcon: const Icon(Icons.task_alt),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.add),

              label: const Text("Add"),

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              onPressed: () {
                if (controller.text.trim().isEmpty) {
                  return;
                }

                Provider.of<TaskProvider>(context, listen: false).addTask(
                  TaskModel(
                    id: DateTime.now().toString(),

                    title: controller.text.trim(),

                    time: TimeOfDay.now().format(context),

                    date:
                        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                  ),
                );

                controller.clear();

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Provider Task Manager",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),

        icon: const Icon(Icons.add),

        label: const Text("Add Task"),
      ),

      body: provider.tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    size: 90,
                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "No Tasks Yet",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Tap + button to add tasks",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : AnimatedList(
              key: GlobalKey<AnimatedListState>(),

              initialItemCount: provider.tasks.length,

              padding: const EdgeInsets.all(14),

              itemBuilder: (_, index, animation) {
                final task = provider.tasks[index];

                return SizeTransition(
                  sizeFactor: animation,

                  child: Card(
                    elevation: 5,

                    margin: const EdgeInsets.only(bottom: 14),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),

                      leading: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          color: task.isDone ? Colors.green : Colors.orange,
                        ),

                        child: Checkbox(
                          value: task.isDone,

                          activeColor: Colors.green,

                          onChanged: (_) {
                            provider.toggleTask(task.id);
                          },
                        ),
                      ),

                      title: Text(
                        task.title,

                        style: TextStyle(
                          fontWeight: FontWeight.w600,

                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),

                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text("📅 ${task.date}"),

                            Text("⏰ ${task.time}"),
                          ],
                        ),
                      ),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),

                        onPressed: () {
                          provider.deleteTask(task.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Task Deleted")),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
