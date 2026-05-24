import 'package:flutter/material.dart';
import 'package:flutter_apps/data/services/api_service.dart';

class UserApiScreen extends StatefulWidget {
  const UserApiScreen({super.key});

  @override
  State<UserApiScreen> createState() => _UserApiScreenState();
}

class _UserApiScreenState extends State<UserApiScreen> {
  late Future<List<dynamic>> users;

  @override
  void initState() {
    super.initState();
    users = ApiService.fetchUsers();
  }

  Future<void> refreshData() async {
    setState(() {
      users = ApiService.fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users API"), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<List<dynamic>>(
          future: users,
          builder: (context, snapshot) {
            /// 🔄 LOADING
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Failed to load data ❌"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: refreshData,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data!;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/150?img=$index",
                      ),
                    ),
                    title: Text(user['name']),
                    subtitle: Text(user['email']),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
