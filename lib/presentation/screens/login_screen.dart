// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final emailController = TextEditingController();
//   final passController = TextEditingController();

//   bool isLoading = false;
//   bool obscurePassword = true;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passController.dispose();
//     super.dispose();
//   }

//   /// ================= AUTH =================

//   Future<void> login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => isLoading = true);

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passController.text.trim(),
//       );

//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     } on FirebaseAuthException catch (e) {
//       _showError(e.message ?? "Login failed");
//     } finally {
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }

//   Future<void> register() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => isLoading = true);

//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passController.text.trim(),
//       );

//       await login();
//     } on FirebaseAuthException catch (e) {
//       _showError(e.message ?? "Signup failed");
//     } finally {
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   /// ================= UI =================

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     return Scaffold(
//       body: Container(
//         width: double.infinity,

//         /// 🎨 GRADIENT (THEME BASED)
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors:
//             // isDark
//             // ? [Color.fromARGB(255, 62, 46, 67), Color(0xFF2D2D44)]
//             // :
//             [Colors.deepPurple, Colors.purpleAccent],
//           ),
//         ),

//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(20),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.task_alt,
//                       size: 80,
//                       color: theme.colorScheme.onPrimary,
//                     ),

//                     SizedBox(height: 10),

//                     Text(
//                       "Task Manager",
//                       style: TextStyle(
//                         fontSize: 24,
//                         color: theme.colorScheme.onPrimary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     SizedBox(height: 30),

//                     Container(
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: theme.cardColor.withAlpha(200),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             blurRadius: 10,
//                             color: Colors.black.withValues(alpha: 0.1),
//                           ),
//                         ],
//                       ),

//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Text(
//                             "Welcome Back 👋",
//                             textAlign: TextAlign.center,
//                             style: theme.textTheme.titleLarge,
//                           ),

//                           SizedBox(height: 5),

//                           Text(
//                             "Login to continue",
//                             textAlign: TextAlign.center,
//                             style: theme.textTheme.bodyMedium,
//                           ),

//                           SizedBox(height: 20),

//                           TextFormField(
//                             controller: emailController,
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (value) {
//                               final email = value?.trim() ?? '';
//                               if (email.isEmpty) {
//                                 return 'Email is required';
//                               }
//                               if (!email.contains('@')) {
//                                 return 'Enter a valid email';
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                               hintText: "Email",
//                               prefixIcon: Icon(Icons.email),
//                               filled: true,
//                               fillColor:
//                                   theme.inputDecorationTheme.fillColor ??
//                                   (isDark
//                                       ? Colors.grey.shade800
//                                       : Colors.grey.shade100),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 15),

//                           /// 🔒 PASSWORD
//                           TextFormField(
//                             controller: passController,
//                             obscureText: obscurePassword,
//                             validator: (value) {
//                               final password = value?.trim() ?? '';
//                               if (password.isEmpty) {
//                                 return 'Password is required';
//                               }
//                               if (password.length < 6) {
//                                 return 'Password must be at least 6 characters';
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                               hintText: "Password",
//                               prefixIcon: Icon(Icons.lock),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   obscurePassword
//                                       ? Icons.visibility
//                                       : Icons.visibility_off,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     obscurePassword = !obscurePassword;
//                                   });
//                                 },
//                               ),
//                               filled: true,
//                               fillColor:
//                                   theme.inputDecorationTheme.fillColor ??
//                                   (isDark
//                                       ? Colors.grey.shade800
//                                       : Colors.grey.shade100),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 10),

//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: TextButton(
//                               onPressed: () {},
//                               child: Text(
//                                 "Forgot Password?",
//                                 style: TextStyle(
//                                   color: theme.colorScheme.onSurface
//                                       .withValues(alpha: 0.8),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 20),

//                           ElevatedButton(
//                             onPressed: isLoading ? null : login,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.deepPurple,
//                               padding: EdgeInsets.symmetric(vertical: 14),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child:
//                                 isLoading
//                                     ? CircularProgressIndicator(
//                                       color: theme.colorScheme.onPrimary,
//                                     )
//                                     : Text(
//                                       "Login",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                           ),

//                           SizedBox(height: 10),

//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("Don't have an account? "),
//                               TextButton(
//                                 onPressed: register,
//                                 child: Text(
//                                   "Sign Up",
//                                   style: TextStyle(
//                                     color: theme.colorScheme.onSurface
//                                         .withValues(alpha: 0.8),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     shadows: [
//                                       Shadow(
//                                         color: theme.colorScheme.onSurface
//                                             .withValues(alpha: 0.8),
//                                         offset: Offset(0, 1),
//                                         blurRadius: 1,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_apps/core/utils/constants.dart';
import 'package:flutter_apps/presentation/screens/dashboard.dart';
import 'home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ── Keys & Controllers ─────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  // ── State ──────────────────────────────────────────────────────────────────
  bool _obscurePassword = true;
   bool _isLoginLoading = false;
  final bool _isRegisterLoading = false;

  // ── Animation ──────────────────────────────────────────────────────────────
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // ── Animation Setup ────────────────────────────────────────────────────────
  void _initAnimations() {
    _animController = AnimationController(
      vsync: this,
      duration: CColors.animDuration,
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  // ── Auth Methods ───────────────────────────────────────────────────────────
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _setLoading(true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );
      _navigateToHome();
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e.code));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    _setLoading(true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );
      _navigateToHome();
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e.code));
    } finally {
      _setLoading(false);
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    if (mounted) setState(() => _isLoginLoading = value);
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, _, _) => const HomeScreen(),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _friendlyError(String code) => switch (code) {
    'user-not-found' => 'No account found with this email.',
    'wrong-password' => 'Incorrect password. Please try again.',
    'invalid-email' => 'Please enter a valid email address.',
    'email-already-in-use' => 'This email is already registered.',
    'weak-password' => 'Password must be at least 6 characters.',
    'network-request-failed' => 'No internet connection.',
    _ => 'Something went wrong. Please try again.',
  };

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter your email first")));
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent to your email 📩")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  void showForgotDialog() {
    TextEditingController resetController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Reset Password"),
        content: TextField(
          controller: resetController,
          decoration: InputDecoration(hintText: "Enter your email"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: resetController.text.trim(),
              );

              Navigator.pop(context);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Reset link sent 📩")));
            },
            child: Text("Send"),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _GradientBackground(
        colors: CColors.gradientColors,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 32),
                        _buildCard(context),
                        const SizedBox(height: 32),
                        _PrimaryButton(
                          label: 'DashBoard',
                          isLoading: false,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashBoardPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── UI Sections ────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.task_alt_rounded,
            size: 56,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Task Manager',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Stay organized. Stay productive.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white70,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(CColors.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome Back 👋',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Login to continue',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Email field
          _AppTextField(
            controller: _emailController,
            hintText: 'Email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            isDark: isDark,
            fieldRadius: CColors.fieldRadius,
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) return 'Email is required';
              if (!email.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Password field
          _AppTextField(
            controller: _passController,
            hintText: 'Password',
            prefixIcon: Icons.lock_outline_rounded,
            isDark: isDark,
            fieldRadius: CColors.fieldRadius,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              final pass = value?.trim() ?? '';
              if (pass.isEmpty) return 'Password is required';
              if (pass.length < 6) return 'Minimum 6 characters required';
              return null;
            },
          ),

          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgotPassword,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Login button
          _PrimaryButton(
            label: 'Login',
            isLoading: _isLoginLoading,
            onPressed: _login,
          ),

          const SizedBox(height: 16),

          // Sign up row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?", style: theme.textTheme.bodyMedium),
              TextButton(
                onPressed: _isRegisterLoading ? null : _register,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Reusable Private Widgets ───────────────────────────────────────────────────

class _GradientBackground extends StatelessWidget {
  const _GradientBackground({required this.colors, required this.child});

  final List<Color> colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.isDark,
    required this.fieldRadius,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isDark;
  final double fieldRadius;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final fillColor = isDark ? const Color(0xFF2A2A3D) : Colors.grey.shade100;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: Color(0xFF6A1B9A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A1B9A),
          disabledBackgroundColor: Colors.purple.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
