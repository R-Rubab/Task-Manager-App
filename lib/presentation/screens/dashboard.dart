import 'package:flutter/material.dart';
import 'package:flutter_apps/presentation/screens/cloud_task_screen.dart';
import 'package:flutter_apps/presentation/screens/counter_screen.dart';
import 'package:flutter_apps/presentation/screens/provider_task_screen.dart';
import 'package:flutter_apps/presentation/screens/todo_screen.dart';
import 'package:flutter_apps/presentation/screens/login_screen.dart';
import 'package:flutter_apps/presentation/screens/splash_screen.dart';
import 'package:flutter_apps/presentation/screens/user_api_screen.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Developer Internship Tasks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFAB47BC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back 👋",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Track all internship tasks & projects",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),

                  child: ListView(
                    children: [
                      _buildTaskCard(
                        context,
                        icon: Icons.login_rounded,
                        title: "Week 1: Login UI",
                        subtitle: "Form Validation & Navigation",
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                      ),

                      _buildTaskCard(
                        context,
                        icon: Icons.add_circle_outline_rounded,
                        title: "Week 2: Counter App",
                        subtitle: "State Management & SharedPreferences",
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CounterScreen()),
                          );
                        },
                      ),

                      _buildTaskCard(
                        context,
                        icon: Icons.list_alt_rounded,
                        title: "Week 2: To-Do App",
                        subtitle: "ListView & Local Storage",
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TodoScreen()),
                          );
                        },
                      ),

                      _buildTaskCard(
                        context,
                        icon: Icons.task_alt_rounded,
                        title: "Week 3: Task Manager Pro",
                        subtitle: "Firebase Auth + Premium UI + Dark Mode",
                        color: Colors.deepPurple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SplashScreen()),
                          );
                        },
                      ),

                      _buildTaskCard(
                        context,
                        icon: Icons.api_rounded,
                        title: "Week 4: API Integration",
                        subtitle: "HTTP Requests + JSON Parsing",
                        color: Colors.teal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => UserApiScreen()),
                          );
                        },
                      ),

                      _buildTaskCard(
                        context,
                        icon: Icons.cloud_done_rounded,
                        title: "Week 5: Firebase Firestore",
                        subtitle: "Realtime Database & Authentication",
                        color: Colors.redAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CloudTaskScreen(),
                            ),
                          );
                        },
                      ),

                      _buildTaskCard(
                        context,
                        icon: Icons.auto_awesome_rounded,
                        title: "Week 6: Provider State Management",
                        subtitle: "Realtime Updates & Optimized Architecture",
                        color: Colors.indigo,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProviderTaskScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,

        child: Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),

            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.95),
                color.withValues(alpha: 0.75),
              ],
            ),

            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Row(
            children: [
              /// ICON
              Container(
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),

                child: Icon(icon, color: Colors.white, size: 28),
              ),

              const SizedBox(width: 18),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      subtitle,

                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              /// ARROW
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
