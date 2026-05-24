import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_apps/core/utils/constants.dart';
import 'auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setSystemOverlayStyle();
    _initAnimation();
    _scheduleNavigation();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _setSystemOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  void _initAnimation() {
    _fadeController = AnimationController(
      vsync: this,
      duration: CColors.fadeDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  Future<void> _scheduleNavigation() async {
    await Future.delayed(CColors.splashDuration);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: CColors.fadeDuration,
        pageBuilder: (_, _, _) => const AuthWrapper(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _SplashBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: const _SplashContent(),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────

class _SplashBackground extends StatelessWidget {
  const _SplashBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CColors.gradientStart, CColors.gradientEnd],
        ),
      ),
      child: child,
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/animations/splash.json',
          height: 200,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 24),
        const _AppTitle(),
        const SizedBox(height: 8),
        const _AppSubtitle(),
      ],
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Task Manager',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _AppSubtitle extends StatelessWidget {
  const _AppSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Organize · Focus · Achieve',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white70,
        letterSpacing: 1.5,
      ),
    );
  }
}
