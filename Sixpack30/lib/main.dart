import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sixpack30/Colors/app_colors.dart';
import 'package:sixpack30/View/SplashView/splash_view.dart';

void main() {
  runApp(
    ProviderScope(
      child: const SixpackApp(),
      
    ),
  );
}

class SixpackApp extends StatelessWidget {
  const SixpackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Sixpack30',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}
