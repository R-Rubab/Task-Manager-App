// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:week3_task_manager/core/theme/theme_provider.dart';
// import 'package:week3_task_manager/presentation/screens/login_screen.dart';
// import '../../data/models/task_model.dart';
// import '../../data/datasource/local_storage.dart';
// import '../widgets/task_tile.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<TaskModel> tasks = [];
//   TextEditingController controller = TextEditingController();
//   List<TaskModel> filteredTasks = [];
//   List<TaskModel> trashTasks = [];
//   String selectedTime = "";
//   String selectedDate = "";
//   int selectedIndex = 0;
//   List<TaskModel> backupTasks = [];
//   bool isFabOpen = false;
//   bool showOnlyIncomplete = false;
//   TextEditingController searchController = TextEditingController();
//   bool isDarkMode = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadTasks();
//     searchController.addListener(() {
//       setState(() {});
//     });
//   }
//   // ================= Tasks =================

//   void _loadTasks() async {
//     tasks = await LocalStorage.getTasks();
//     filteredTasks = tasks;

//     setState(() {});
//   }

//   void _saveTasks() async {
//     await LocalStorage.saveTasks(tasks);
//   }

//   void _addTask(String text) {
//     if (text.trim().isEmpty || selectedTime.isEmpty || selectedDate.isEmpty)
//       return;

//     setState(() {
//       tasks.add(TaskModel(title: text, time: selectedTime, date: selectedDate));
//       filteredTasks = tasks;
//     });

//     controller.clear();
//     selectedTime = "";
//     selectedDate = "";

//     _saveTasks();
//   }

//   void _editTask(int index, String newText) {
//     if (newText.trim().isEmpty) return;

//     setState(() {
//       tasks[index] = TaskModel(
//         title: newText,
//         time: tasks[index].time,
//         date: tasks[index].date,
//         isDone: tasks[index].isDone,
//       );

//       filteredTasks = tasks;
//     });

//     _saveTasks();
//   }

//   void _deleteTask(int index) {
//     final removedTask = tasks[index];

//     setState(() {
//       tasks.removeAt(index);
//       filteredTasks = tasks;
//     });

//     _saveTasks();

//     // SNACKBAR (UNDO)
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Task deleted"),
//         duration: Duration(seconds: 3),
//         action: SnackBarAction(
//           label: "UNDO",
//           onPressed: () {
//             setState(() {
//               tasks.insert(index, removedTask);
//               trashTasks.add(removedTask);
//               filteredTasks = tasks;
//             });
//             _saveTasks();
//           },
//         ),
//       ),
//     );
//   }

//   void _toggleTask(int index) {
//     setState(() {
//       tasks[index].isDone = !tasks[index].isDone;
//     });
//     _saveTasks();
//   }

//   void _searchTasks(String query) {
//     setState(() {
//       filteredTasks =
//           tasks
//               .where(
//                 (task) =>
//                     task.title.toLowerCase().contains(query.toLowerCase()),
//               )
//               .toList();
//     });
//   }

//   void _clearAll() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Row(
//             children: [
//               Icon(Icons.warning, color: Colors.red),
//               SizedBox(width: 8),
//               Text("Delete All Tasks?"),
//             ],
//           ),
//           content: Text("Are you sure you want to delete all tasks?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: Text("Cancel"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               onPressed: () => Navigator.pop(context, true),
//               child: Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirm != true) return;

//     final backup = List<TaskModel>.from(tasks);

//     // 🗑️ CLEAR
//     setState(() {
//       tasks.clear();
//       filteredTasks.clear();
//     });

//     _saveTasks();

//     // 🔄 SNACKBAR UNDO
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("All tasks deleted"),
//         duration: Duration(seconds: 4),

//         action: SnackBarAction(
//           label: "UNDO",
//           onPressed: () {
//             setState(() {
//               tasks = backup;
//               filteredTasks = backup;
//             });
//             _saveTasks();
//           },
//         ),
//       ),
//     );
//   }

//   // ================= PICKERS =================

//   Future<void> _pickTime(StateSetter setModal) async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (picked != null) {
//       setModal(() => selectedTime = picked.format(context));
//     }
//   }

//   Future<void> _pickDate(StateSetter setModal) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       final day =
//           ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][picked.weekday - 1];

//       setModal(() {
//         selectedDate = "$day ${picked.day}/${picked.month}/${picked.year}";
//       });
//     }
//   }

//   // ================= UI HELPERS =================

//   void _showSnack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   void _openAddTaskSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setModal) {
//             return Padding(
//               padding: EdgeInsets.fromLTRB(
//                 16,
//                 49,
//                 16,
//                 MediaQuery.of(context).viewInsets.bottom + 20,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Add Task",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),

//                   SizedBox(height: 20),

//                   TextField(
//                     controller: controller,
//                     decoration: InputDecoration(
//                       hintText: "Enter task...",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),

//                   SizedBox(height: 10),

//                   // TIME
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         selectedTime.isEmpty ? "No time" : "⏰ $selectedTime",
//                       ),
//                       TextButton(
//                         onPressed: () => _pickTime(setModal),
//                         child: Text("Pick Time"),
//                       ),
//                     ],
//                   ),

//                   // DATE
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         selectedDate.isEmpty ? "No date" : "📅 $selectedDate",
//                       ),
//                       TextButton(
//                         onPressed: () => _pickDate(setModal),
//                         child: Text("Pick Date"),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 10),

//                   ElevatedButton(
//                     onPressed: () {
//                       _addTask(controller.text);
//                       Navigator.pop(context);
//                     },
//                     child: Text(
//                       "Add",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

// void _openEditSheet(int index) {
//   controller.text = tasks[index].title;
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) {
//       return Padding(
//         padding: EdgeInsets.fromLTRB(
//           16,
//           40,
//           16,
//           MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "Edit Task",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: controller,
//               decoration: InputDecoration(border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 _editTask(index, controller.text);
//                 Navigator.pop(context);
//               },
//               child: Text("Update"),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

//   // ================= Widgets =================

//   Widget _buildHeader() {
//     final user = FirebaseAuth.instance.currentUser;

//     String name = "User";

//     if (user != null && user.email != null) {
//       name = user.email!.split("@")[0]; // 👈 ali@gmail.com → ali
//     }

//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Hello $name 👋",
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           Text("Manage your daily tasks", style: TextStyle(color: Colors.grey)),
//         ],
//       ),
//     );
//   }

//   Widget _buildFabItem({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.black87,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(label, style: TextStyle(color: Colors.white)),
//           ),
//           SizedBox(width: 8),
//           FloatingActionButton(
//             mini: true,
//             heroTag: label,
//             onPressed: onTap,
//             child: Icon(icon),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStats() {
//     int completed = tasks.where((t) => t.isDone).length;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _statCard("Total", tasks.length, Colors.blue),
//         _statCard("Done", completed, Colors.green),
//         _statCard("Pending", tasks.length - completed, Colors.orange),
//       ],
//     );
//   }

//   Widget _statCard(String title, int count, Color color) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Text("$count", style: TextStyle(fontSize: 18, color: color)),
//             Text(title),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: false,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Theme.of(context).colorScheme.onSurface,

//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Task Manager",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//             Text(
//               "Stay organized ✨",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Theme.of(context).textTheme.bodySmall?.color,
//               ),
//             ),
//           ],
//         ),

//         actions: [
//           // 🗑️ CLEAR ALL
//           IconButton(
//             icon: Icon(Icons.delete_sweep_rounded),
//             tooltip: "Clear All",
//             onPressed: _clearAll,
//           ),

//           // 🌙 DARK MODE TOGGLE (OPTIONAL 🔥)
//           IconButton(
//             icon: Icon(Icons.dark_mode),
//             onPressed: () {
//               // toggle theme (if using provider)
//             },
//           ),
//         ],
//       ),

//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

//       floatingActionButton: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           //  ADD TASK
//           if (isFabOpen)
//             _buildFabItem(
//               icon: Icons.add_task,
//               label: "Add Task",
//               onTap: _openAddTaskSheet,
//             ),

//           //  TRASH
//           if (isFabOpen)
//             _buildFabItem(
//               icon: Icons.delete_outline,
//               label: "Trash",
//               onTap: () {
//                 // navigate to trash
//               },
//             ),

//           // SEARCH (optional)
//           if (isFabOpen)
//             _buildFabItem(icon: Icons.search, label: "Search", onTap: () {}),

//           SizedBox(height: 10),

//           // MAIN FAB
//           FloatingActionButton(
//             onPressed: () {
//               setState(() {
//                 isFabOpen = !isFabOpen;
//               });
//             },
//             child: Icon(isFabOpen ? Icons.close : Icons.add),
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: Column(
//           children: [
//             UserAccountsDrawerHeader(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.deepPurple, Colors.purpleAccent],
//                 ),
//               ),
//               accountName: Text(
//                 "Welcome 👋",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               accountEmail: Text(
//                 FirebaseAuth.instance.currentUser?.email ?? "No Email",
//               ),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
//               ),
//             ),

//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () => Navigator.pop(context),
//             ),

//             SwitchListTile(
//               title: Text("Dark Mode"),
//               secondary: Icon(Icons.dark_mode),
//               value: context.watch<ThemeProvider>().isDarkMode,
//               onChanged: (value) {
//                 context.read<ThemeProvider>().toggleTheme(value);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(value ? "Dark Mode ON 🌙" : "Light Mode ☀️"),
//                   ),
//                 );
//               },
//             ),

//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {
//                 Navigator.pop(context);

//                 _showSnack("Settings coming soon!");
//               },
//             ),

//             ListTile(
//               leading: Icon(Icons.info_outline),
//               title: Text('About'),
//               onTap: () {
//                 Navigator.pop(context);
//                 showAboutDialog(
//                   context: context,
//                   applicationName: "Task Manager Pro",
//                   applicationVersion: "1.0.0",
//                   applicationLegalese: "© 2026 Your Name",
//                 );
//               },
//             ),

//             Spacer(),

//             ListTile(
//               leading: Icon(Icons.logout, color: Colors.red),
//               title: Text('Logout', style: TextStyle(color: Colors.red)),
//               onTap: () async {
//                 await FirebaseAuth.instance.signOut();

//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (_) => LoginScreen()),
//                   (route) => false,
//                 );
//               },
//             ),

//             SizedBox(height: 10),
//           ],
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),

//             //  SEARCH
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: Theme.of(context).cardColor.withValues(alpha: 0.6),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.05),
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),

//               child: TextField(
//                 controller: searchController,
//                 onChanged: _searchTasks,

//                 style: TextStyle(fontSize: 14),

//                 decoration: InputDecoration(
//                   hintText: "Search tasks...",
//                   hintStyle: TextStyle(color: Colors.grey),

//                   //  ICON
//                   prefixIcon: Icon(Icons.search_rounded),

//                   // CLEAR BUTTON
//                   suffixIcon:
//                       searchController.text.isNotEmpty
//                           ? IconButton(
//                             icon: Icon(Icons.close),
//                             onPressed: () {
//                               searchController.clear();
//                               _searchTasks("");
//                               setState(() {});
//                             },
//                           )
//                           : null,

//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(16),
//                     // borderSide: BorderSide.none,
//                   ),

//                   contentPadding: EdgeInsets.symmetric(vertical: 14),
//                 ),
//               ),
//             ),
//             SizedBox(height: 15),

//             // Row(
//             //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
//             //   children: [
//             //     Container(
//             //       padding: EdgeInsets.all(13),
//             //       decoration: BoxDecoration(
//             //         // color: Colors.white,
//             //         border: Border.all(
//             //           color: const Color.fromARGB(255, 118, 118, 118),
//             //         ),
//             //         borderRadius: BorderRadius.all(Radius.circular(15)),
//             //       ),
//             //       child: Text(
//             //         'Incomplete Only',
//             //         style: TextStyle(fontSize: 15),
//             //       ),
//             //     ),
//             //     SizedBox(width: 25),
//             //     Text('0 Pending', style: TextStyle(fontSize: 14)),
//             //   ],
//             // ),
//             SizedBox(height: 8),
//             Text(
//               "Task Schedule",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
//             ),

//             SizedBox(
//               height: 95,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 7,
//                 itemBuilder: (context, index) {
//                   final date = DateTime.now().add(Duration(days: index));
//                   final isSelected = selectedIndex == index;

//                   final dayName =
//                       [
//                         "Mon",
//                         "Tue",
//                         "Wed",
//                         "Thu",
//                         "Fri",
//                         "Sat",
//                         "Sun",
//                       ][date.weekday - 1];

//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
//                       });
//                     },

//                     child: AnimatedContainer(
//                       // width: 57,
//                       duration: Duration(milliseconds: 300),
//                       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 8,
//                       ),

//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),

//                         gradient:
//                             isSelected
//                                 ? LinearGradient(
//                                   colors: [
//                                     Colors.deepPurple,
//                                     Colors.purpleAccent,
//                                   ],
//                                 )
//                                 : LinearGradient(
//                                   colors: [
//                                     Colors.deepPurple.withValues(alpha: 0.23),
//                                     Colors.purpleAccent.withValues(alpha: 0.23),
//                                   ],
//                                 ),

//                         color: isSelected ? null : Theme.of(context).cardColor,

//                         boxShadow:
//                             isSelected
//                                 ? [
//                                   BoxShadow(
//                                     color: Colors.deepPurple.withValues(
//                                       alpha: 0.3,
//                                     ),
//                                     blurRadius: 10,
//                                     offset: Offset(0, 4),
//                                   ),
//                                 ]
//                                 : [],
//                       ),

//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             dayName,
//                             style: TextStyle(
//                               color:
//                                   isSelected
//                                       ? Colors.white
//                                       : Theme.of(context)
//                                           .textTheme
//                                           .bodySmall
//                                           ?.color!
//                                           .withValues(alpha: 0.5),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),

//                           SizedBox(height: 4),

//                           Text(
//                             "${date.day}",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color:
//                                   isSelected
//                                       ? Colors.white
//                                       : Theme.of(context)
//                                           .textTheme
//                                           .bodySmall
//                                           ?.color!
//                                           .withValues(alpha: 0.5),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 10),

//             // 📋 Task LIST
//             Container(
//               height: 375,
//               decoration: BoxDecoration(
//                 // color: Colors.white,
//                 border: Border.all(
//                   color:
//                       isDarkMode
//                           ? const Color.fromARGB(255, 222, 221, 221)
//                           : const Color.fromARGB(255, 194, 191, 191),
//                 ),
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               child:
//                   filteredTasks.isEmpty
//                       ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.task_alt, size: 80, color: Colors.grey),
//                             SizedBox(height: 10),
//                             Text(
//                               "No tasks yet",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Text(
//                               "Tap + to add your first task",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       )
//                       : ListView.builder(
//                         itemCount: filteredTasks.length,
//                         itemBuilder: (context, index) {
//                           final task = filteredTasks[index];

//                           return Column(
//                             children: [
//                               SizedBox(height: 10),
//                               Text(
//                                 [
//                                   "Monday",
//                                   "Tuesday",
//                                   "Wednesday",
//                                   "Thursday",
//                                   "Friday",
//                                   "Saturday",
//                                   "Sunday",
//                                 ][DateTime.now().weekday - 1],
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),

//                               _buildStats(),
//                               TaskTile(
//                                 task: task,
//                                 onDelete:
//                                     () => _deleteTask(tasks.indexOf(task)),
//                                 onToggle:
//                                     () => _toggleTask(tasks.indexOf(task)),
//                                 onEdit:
//                                     () => _openEditSheet(tasks.indexOf(task)),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//             ),
//             SizedBox(height: 10),
//             Align(
//               alignment: Alignment.center,
//               child: Text(
//                 // "⏰ Current Time: ${DateTime.now().hour}:${DateTime.now().minute}",
//                 'version 1.0.0',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/data/services/firebase_services.dart';
import 'package:flutter_apps/presentation/screens/cloud_task_screen.dart';
import 'package:flutter_apps/presentation/screens/dashboard.dart';
import 'package:flutter_apps/presentation/screens/user_api_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_apps/core/theme/theme_provider.dart';
import 'package:flutter_apps/core/utils/constants.dart';
import 'package:flutter_apps/presentation/screens/login_screen.dart';
import '../../../data/models/task_model.dart';
import '../../../data/datasource/local_storage.dart';
import '../../widgets/task_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _weekDaysShort = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];
  static const _weekDaysLong = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  final firestoreService = FirestoreService();
  bool isCloudMode = false;
  // ── Controllers ────────────────────────────────────────────────────────────
  final _taskInputController = TextEditingController();
  final _searchController = TextEditingController();

  // ── State ──────────────────────────────────────────────────────────────────
  List<TaskModel> _tasks = [];
  List<TaskModel> _filteredTasks = [];
  String _selectedTime = '';
  String _selectedDate = '';
  int _selectedDayIndex = 0;
  bool _isFabOpen = false;
  File? profileImage;
  // final String uid = FirebaseAuth.instance.currentUser!.uid;
  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadTasks();
    _searchController.addListener(() => setState(() {}));
    loadProfileImage();
  }

  @override
  void dispose() {
    _taskInputController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Data Methods ───────────────────────────────────────────────────────────
  Future<void> _loadTasks() async {
    // final loaded = await LocalStorage.getTasks();
    final loaded = await LocalStorage.getTasks();
    setState(() {
      _tasks = loaded;
      _filteredTasks = loaded;
    });
  }

  Future<void> _saveTasks() => LocalStorage.saveTasks(_tasks);

  // Future<void> _addTask(String text, [int? index]) async {
  //   if (text.trim().isEmpty || _selectedTime.isEmpty || _selectedDate.isEmpty) {
  //     return;
  //   }
  //   // setState(() {
  //   //   _tasks.add(
  //   //     TaskModel(title: text.trim(), time: _selectedTime, date: _selectedDate),
  //   //   );
  //   //   _filteredTasks = List.from(_tasks);
  //   //   _selectedTime = '';
  //   //   _selectedDate = '';
  //   // });
  //   // _taskInputController.clear();
  //   // _saveTasks();
  //   // setState(() async {
  //     if (isCloudMode) {
  //       await firestoreService.addTask(
  //         title: text,
  //         date: _selectedDate,
  //         time: _selectedTime,
  //       );
  //     } else {
  //       _tasks.add(
  //         TaskModel(
  //           title: text.trim(),
  //           time: _selectedTime,
  //           date: _selectedDate,
  //           id: firestoreService.uid,
  //         ),
  //       );
  //       _filteredTasks = List.from(_tasks);
  //       _selectedTime = '';
  //       _selectedDate = '';
  //       _taskInputController.clear();
  //       _saveTasks();
  //     }
  //   // });
  // }
  Future<void> _addTask(String text) async {
    if (text.trim().isEmpty || _selectedTime.isEmpty || _selectedDate.isEmpty) {
      return;
    }

    if (isCloudMode) {
      await firestoreService.addTask(
        title: text.trim(),
        date: _selectedDate,
        time: _selectedTime,
      );

      _taskInputController.clear();

      setState(() {
        _selectedTime = '';
        _selectedDate = '';
      });
    } else {
      setState(() {
        _tasks.add(
          TaskModel(
            title: text.trim(),
            time: _selectedTime,
            date: _selectedDate,
            id: firestoreService.uid,
          ),
        );

        _filteredTasks = List.from(_tasks);

        _selectedTime = '';
        _selectedDate = '';
      });

      _taskInputController.clear();

      _saveTasks();
    }
  }

  void _editTask(int index, String newText) async {
    if (newText.trim().isEmpty) return;

    final original = _tasks[index];
    if (isCloudMode) {
      await firestoreService.updateTask(
        taskId: firestoreService.uid,
        title: newText.trim(),
      );

      _taskInputController.clear();
    } else {
      setState(() {
        _tasks[index] = TaskModel(
          id: firestoreService.uid,
          title: newText.trim(),
          time: original.time,
          date: original.date,
          isDone: original.isDone,
        );
        _filteredTasks = List.from(_tasks);
      });
      _saveTasks();
    }
  }

  void _deleteTask(int index) {
    final removed = _tasks[index];

    setState(() {
      _tasks.removeAt(index);
      _filteredTasks = List.from(_tasks);
    });
    _saveTasks();

    _showUndoSnack(
      message: 'Task deleted',
      duration: const Duration(seconds: 3),

      onUndo: () {
        setState(() {
          _tasks.insert(index, removed);
          _filteredTasks = List.from(_tasks);
        });
        _saveTasks();
      },
    );
  }

  void _confirmDeleteAccount() async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Account"),
        content: Text("This action cannot be undone. Continue?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _showPasswordDialog();
    }
  }

  void _toggleTask(int index) {
    setState(() => _tasks[index].isDone = !_tasks[index].isDone);
    _saveTasks();
  }

  void _searchTasks(String query) {
    setState(() {
      _filteredTasks = query.trim().isEmpty
          ? List.from(_tasks)
          : _tasks
                .where(
                  (t) => t.title.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
    });
  }

  Future<void> _clearAll() async {
    final confirmed = await _showConfirmDialog(
      title: 'Delete All Tasks?',
      content: 'This will remove all your tasks. This action can be undone.',
      confirmLabel: 'Delete All',
      confirmColor: Colors.red,
    );
    if (confirmed != true) return;

    final backup = List<TaskModel>.from(_tasks);
    setState(() {
      _tasks.clear();
      _filteredTasks.clear();
    });
    _saveTasks();

    _showUndoSnack(
      message: 'All tasks deleted',
      duration: const Duration(seconds: 4),
      onUndo: () {
        setState(() {
          _tasks = backup;
          _filteredTasks = backup;
        });
        _saveTasks();
      },
    );
  }

  // ── Pickers ────────────────────────────────────────────────────────────────
  Future<void> _pickTime(StateSetter setModal) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setModal(() => _selectedTime = picked.format(context));
    }
  }

  Future<void> _pickDate(StateSetter setModal) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final day = _weekDaysShort[picked.weekday - 1];
      setModal(() {
        _selectedDate = '$day ${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  // ── Dialogs & Sheets ───────────────────────────────────────────────────────
  Future<bool?> _showConfirmDialog({
    required String title,
    required String content,
    required String confirmLabel,
    Color confirmColor = Colors.red,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: confirmColor),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmLabel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showUndoSnack({
    required String message,
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(label: 'UNDO', onPressed: onUndo),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.only(top: 18),
        backgroundColor: const Color(0xFF6A1B9A),
        duration: Duration(seconds: 3),
        content: Center(
          child: Text(
            msg,
            style: TextStyle(
              color: const Color.fromARGB(255, 239, 238, 240),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
      ),
    );
  }

  void _openAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: CColors.sheetRadius),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModal) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            24,
            20,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sheet handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                'Add New Task',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _taskInputController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'What do you need to do?',
                  prefixIcon: const Icon(Icons.edit_note_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Time & Date pickers
              Row(
                children: [
                  Expanded(
                    child: _PickerTile(
                      icon: Icons.access_time_rounded,

                      label: _selectedTime.isEmpty
                          ? 'Pick Time'
                          : _selectedTime,
                      onTap: () => _pickTime(setModal),
                      isEmpty: _selectedTime.isEmpty,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PickerTile(
                      icon: Icons.calendar_today_rounded,
                      label: _selectedDate.isEmpty
                          ? 'Pick Date'
                          : _selectedDate,
                      onTap: () => _pickDate(setModal),
                      isEmpty: _selectedDate.isEmpty,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  _addTask(_taskInputController.text);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add_task_rounded, color: Colors.white),
                label: const Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openEditSheet(int index) {
    _taskInputController.text = _tasks[index].title;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: CColors.sheetRadius),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          24,
          20,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Edit Task',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _taskInputController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Update your task...',
                prefixIcon: const Icon(Icons.edit_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _editTask(index, _taskInputController.text);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_rounded, color: Colors.white),
              label: const Text(
                'Update Task',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditSheet1({required String taskId, required String oldTitle}) {
    final TextEditingController editController = TextEditingController(
      text: oldTitle,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: CColors.sheetRadius),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          24,
          20,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// HANDLE BAR
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            /// TITLE
            Text(
              'Edit Task',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// INPUT
            TextField(
              controller: editController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Update your task...',
                prefixIcon: const Icon(Icons.edit_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// UPDATE BUTTON
            ElevatedButton.icon(
              onPressed: () async {
                final newText = editController.text.trim();
                if (newText.isEmpty) return;

                /// CLOUD MODE
                if (isCloudMode) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(firestoreService.uid)
                      .collection('tasks')
                      .doc(taskId)
                      .update({'title': newText});
                }
                /// LOCAL MODE
                // else {
                //   final index = _tasks.indexWhere((t) => t.id == taskId);
                //   // if (index != -1) {
                //     setState(() {
                //       _tasks[index] = _tasks[index] = TaskModel(
                //         id: _tasks[index].id,
                //         title: newText,
                //         time: _tasks[index].time,
                //         date: _tasks[index].date,
                //         isDone: _tasks[index].isDone,
                //       );
                //       // _editTask(index, _taskInputController.text);
                //     });
                //     _saveTasks();
                //   // }
                // }
                else {
                  final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
                  if (taskIndex == -1) return;
                  setState(() {
                    final updatedTask = _tasks[taskIndex].copyWith(
                      title: newText,
                    );
                    _tasks[taskIndex] = updatedTask;
                    // IMPORTANT: sync filtered list properly
                    final filteredIndex = _filteredTasks.indexWhere(
                      (t) => t.id == taskId,
                    );
                    if (filteredIndex != -1) {
                      _filteredTasks[filteredIndex] = updatedTask;
                    }
                  });
                  _saveTasks();
                }
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_rounded, color: Colors.white),
              label: const Text(
                'Update Task',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPasswordDialog() {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirm Password"),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: "Enter your password"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount(passwordController.text.trim());
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Current Password"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _changePassword(
                oldPassController.text.trim(),
                newPassController.text.trim(),
              );
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword(String oldPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) return;

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      /// 🔐 RE-AUTH
      await user.reauthenticateWithCredential(cred);

      /// 🔄 UPDATE PASSWORD
      await user.updatePassword(newPassword);

      _showSnack("Password updated successfully 🔐");
    } catch (e) {
      _showSnack("Error: Check your current password");
    }
  }

  Future<void> _deleteAccount(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) return;

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      /// 🔐 RE-AUTH
      await user.reauthenticateWithCredential(cred);

      /// ❌ DELETE ACCOUNT
      await user.delete();

      /// 🔄 REDIRECT TO LOGIN
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (_) => false,
      );

      _showSnack("Account deleted");
    } catch (e) {
      _showSnack("Error: Check password or login again");
    }
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image');

    if (path != null) {
      setState(() {
        profileImage = File(path);
      });
    }
  }

  //  Future<void> pickImage() async {
  //     final picker = ImagePicker();
  //     final picked = await picker.pickImage(source: ImageSource.gallery);
  //     if (picked != null) {
  //       final prefs = await SharedPreferences.getInstance();
  //       setState(() {
  //         profileImage = File(picked.path);
  //       });
  //       await prefs.setString('profile_image', picked.path);
  //     }
  //   }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();

      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        final prefs = await SharedPreferences.getInstance();

        setState(() {
          profileImage = File(picked.path);
        });

        await prefs.setString('profile_image', picked.path);
      }
    } catch (e) {
      print("Image error: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Image picker error")));
    }
  }

  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 📷 CHANGE IMAGE
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Change Image"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(); // gallery
                },
              ),

              /// 📸 CAMERA
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);

                  try {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );

                    if (picked != null) {
                      final prefs = await SharedPreferences.getInstance();

                      setState(() {
                        profileImage = File(picked.path);
                      });

                      await prefs.setString('profile_image', picked.path);
                    }
                  } catch (e) {
                    _showSnack("Camera not available");
                  }
                },
              ),

              /// ❌ REMOVE IMAGE
              if (profileImage != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text("Remove Image"),
                  onTap: () async {
                    Navigator.pop(context);

                    final confirm = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Remove Image?"),
                        content: Text(
                          "Are you sure you want to delete profile image?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text("Remove"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      final prefs = await SharedPreferences.getInstance();

                      setState(() {
                        profileImage = null;
                      });

                      await prefs.remove('profile_image');

                      _showSnack("Image removed");
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isFabOpen) {
          setState(() {
            _isFabOpen = false;
          });
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: _buildDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: _buildFab(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildSectionTitle('Task Schedule'),
              const SizedBox(height: 8),
              _buildDaySelector(),
              const SizedBox(height: 12),
              _buildTaskList(firestoreService.uid),
              const SizedBox(height: 12),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Manager',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Stay organized ✨',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
      actions: [
        // IconButton(
        //   icon: const Icon(Icons.delete_sweep_rounded),
        //   tooltip: 'Clear All',
        //   onPressed: _clearAll,
        // ),
        Row(
          children: [
            GestureDetector(
              onTap: () => isCloudMode
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CloudTaskScreen(),
                      ),
                    )
                  : null,
              child: Text(
                isCloudMode ? "Cloud" : "Local",
                style: TextStyle(fontSize: 12),
              ),
            ),

            Switch(
              value: isCloudMode,
              onChanged: (value) {
                setState(() {
                  isCloudMode = value;
                });
              },
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          tooltip: 'Notifications',
          onPressed: () {
            // add notifications
          },
        ),
      ],
    );
  }

  // ── Drawer ─────────────────────────────────────────────────────────────────
  Widget _buildDrawer() {
    final email = FirebaseAuth.instance.currentUser?.email ?? 'No Email';

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: CColors.gradientColors),
            ),
            accountName: const Text(
              'Welcome 👋',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(email),

            currentAccountPicture: GestureDetector(
              // onTap: pickImage,
              onTap: showImageOptions,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : null,
                child: profileImage == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Color(0xFF6A1B9A),
                      )
                    : null,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DashBoardPage()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.api),
            title: Text("API Users Data"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserApiScreen()),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (_, themeProvider, _) => SwitchListTile(
              title: const Text('Dark Mode'),
              secondary: const Icon(Icons.dark_mode_rounded),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
                _showSnack(value ? 'Dark Mode ON 🌙' : 'Light Mode ☀️');
              },
            ),
          ),

          // ListTile(
          //   leading: const Icon(Icons.settings_rounded),
          //   title: const Text('Settings'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     _showSnack('Settings coming soon!');
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text(' Notifications '),
            onTap: () {
              Navigator.pop(context);
              _showSnack('Notifications coming soon!');
            },
          ),
          ListTile(
            leading: Icon(isCloudMode ? Icons.cloud : Icons.storage),
            title: Text(isCloudMode ? "Cloud" : "Local"),
            trailing: Switch(
              value: isCloudMode,
              onChanged: (value) {
                setState(() {
                  isCloudMode = value;
                });
              },
            ),
            onTap: () {
              isCloudMode
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CloudTaskScreen(),
                      ),
                    )
                  : Navigator.pop(context);
              // _showSnack('Local screen coming soon!');
            },
          ),

          ListTile(
            leading: Icon(Icons.lock_reset),
            title: Text("Change Password"),
            onTap: _showChangePasswordDialog,
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red.shade500),
            title: Text(
              "Delete Account",
              style: TextStyle(color: Colors.red.shade500),
            ),
            onTap: _confirmDeleteAccount,
          ),

          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Task Manager Pro',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2026',
              );
            },
          ),

          const Spacer(),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ── FAB ────────────────────────────────────────────────────────────────────
  Widget _buildFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isFabOpen) ...[
          _FabMenuItem(
            icon: Icons.add_task_rounded,
            label: 'Add Task',
            onTap: () {
              setState(() => _isFabOpen = false);
              _openAddTaskSheet();
            },
          ),
          _FabMenuItem(
            icon: Icons.delete_sweep_rounded,
            label: 'Clear All',
            onTap: _clearAll,
          ),

          _FabMenuItem(
            icon: Icons.delete_outline_rounded,
            label: 'Trash',
            onTap: () {
              _showSnack('Trash coming soon!');
            },
          ),
          _FabMenuItem(
            icon: Icons.search_rounded,
            label: 'Search',
            onTap: () {
              _searchTasks;
            },
          ),
          const SizedBox(height: 4),
        ],
        FloatingActionButton(
          onPressed: () => setState(() => _isFabOpen = !_isFabOpen),
          backgroundColor: const Color(0xFF6A1B9A),
          child: AnimatedRotation(
            turns: _isFabOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ── Body Sections ──────────────────────────────────────────────────────────
  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.email?.split('@').first ?? 'User';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, $name 👋',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Manage your daily tasks',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _searchTasks,
      decoration: InputDecoration(
        hintText: 'Search tasks...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  _searchController.clear();
                  _searchTasks('');
                },
              )
            : null,
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6A1B9A), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (_, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = _selectedDayIndex == index;
          final dayName = _weekDaysShort[date.weekday - 1];

          return GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: isSelected
                      ? CColors.gradientColors
                      : [
                          const Color(0xFF6A1B9A).withValues(alpha: 0.12),
                          const Color(0xFFAB47BC).withValues(alpha: 0.12),
                        ],
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6A1B9A).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskList(String uid) {
    final completedCount = _tasks.where((t) => t.isDone).length;
    final pendingCount = _tasks.length - completedCount;
    final todayName = _weekDaysLong[DateTime.now().weekday - 1];

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: CColors.cardBorderRadius,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
        ),
        child: isCloudMode
            ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('tasks')
                    .snapshots(),

                builder: (context, snapshot) {
                  /// ⏳ LOADING
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  /// ❌ ERROR
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  /// 📭 EMPTY
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const _EmptyTasksPlaceholder();
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,

                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      return TaskTile(
                        task: TaskModel(
                          id: docs[index].id,
                          title: data['title'] ?? '',
                          date: data['date'] ?? '',
                          time: data['time'] ?? '',
                          isDone: data['isDone'] ?? false,
                        ),

                        onDelete: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection('tasks')
                              .doc(docs[index].id)
                              .delete();
                        },
                        onToggle: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection('tasks')
                              .doc(docs[index].id)
                              .update({'isDone': !(data['isDone'] ?? false)});
                        },

                        /// ✏️ EDIT TASK
                        onEdit: () {
                          // _openEditSheet(
                          // taskId: docs[index].id,
                          // oldTitle: data['title'],
                          // );
                        },
                      );
                    },
                  );
                },
              )
            : _filteredTasks.isEmpty
            ? const _EmptyTasksPlaceholder()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _filteredTasks.length,
                itemBuilder: (_, index) {
                  final task = _filteredTasks[index];
                  return Column(
                    children: [
                      if (index == 0) ...[
                        const SizedBox(height: 8),
                        Text(
                          todayName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _StatsRow(
                          total: _tasks.length,
                          completed: completedCount,
                          pending: pendingCount,
                        ),
                        const Divider(height: 1),
                      ],
                      TaskTile(
                        task: task,
                        onDelete: () => _deleteTask(_tasks.indexOf(task)),
                        onToggle: () => _toggleTask(_tasks.indexOf(task)),
                        onEdit: () => _openEditSheet(_tasks.indexOf(task)),

                        //                               ),
                        // onEdit: () {
                        //   _openEditSheet(taskId: task.id, oldTitle: task.title);
                        // },
                      ),
                    ],
                  );
                },
              ),

        // child: _filteredTasks.isEmpty
        // ? const _EmptyTasksPlaceholder()
        // : ListView.builder(
        //     padding: const EdgeInsets.symmetric(vertical: 8),
        //     itemCount: _filteredTasks.length,
        //     itemBuilder: (_, index) {
        //       final task = _filteredTasks[index];
        //       return Column(
        //         children: [
        //           if (index == 0) ...[
        //             const SizedBox(height: 8),
        //             Text(
        //               todayName,
        //               style: const TextStyle(
        //                 fontSize: 16,
        //                 color: Colors.grey,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             const SizedBox(height: 8),
        //             _StatsRow(
        //               total: _tasks.length,
        //               completed: completedCount,
        //               pending: pendingCount,
        //             ),
        //             const Divider(height: 1),
        //           ],
        //           TaskTile(
        //             task: task,
        //             onDelete: () => _deleteTask(_tasks.indexOf(task)),
        //             onToggle: () => _toggleTask(_tasks.indexOf(task)),
        //             onEdit: () => _openEditSheet(_tasks.indexOf(task)),
        //           ),
        //         ],
        //       );
        //     },
        //   ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: Text(
          'Version 1.0.0',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }
}

// ── Private Sub-Widgets ────────────────────────────────────────────────────────

class _FabMenuItem extends StatelessWidget {
  const _FabMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            heroTag: label,
            onPressed: onTap,
            backgroundColor: const Color(0xFF6A1B9A),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isEmpty,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEmpty ? Colors.grey.shade300 : const Color.fromARGB(255, 162, 100, 200),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isEmpty ? Colors.grey : const Color.fromARGB(255, 174, 128, 203),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isEmpty
                      ? Colors.grey
                      : const Color.fromARGB(255, 209, 176, 229),
                  fontWeight: isEmpty ? FontWeight.normal : FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.total,
    required this.completed,
    required this.pending,
  });

  final int total;
  final int completed;
  final int pending;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatChip(label: 'Total', count: total, color: Colors.blue),
          _StatChip(label: 'Done', count: completed, color: Colors.green),
          _StatChip(label: 'Pending', count: pending, color: Colors.orange),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _EmptyTasksPlaceholder extends StatelessWidget {
  const _EmptyTasksPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt_rounded, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap + to add your first task',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
