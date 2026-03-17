import 'package:flutter/material.dart';
import 'package:sixpack30/Colors/app_colors.dart';
import 'package:sixpack30/View/OnboardingView/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  static const double _designWidth = 390;
  static const double _designLeft = 57;
  static const double _designImageWidth =
      _designWidth - 2 * _designLeft; // 390 - 2*57 = 276

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, animation, __) => const Splash2View(),
          transitionsBuilder: (_, animation, __, child) {
            final offsetAnimation = Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(
              CurveTween(curve: Curves.easeInOut),
            ).animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final imageWidth =
              screenWidth * (_designImageWidth / _designWidth);

          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                'assets/images/splash.png',
                width: imageWidth,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}

