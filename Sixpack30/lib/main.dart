import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sixpack30/Colors/app_colors.dart';
import 'package:sixpack30/View/SplashView/splash_view.dart';

const _supportedLocales = <Locale>[
  Locale('en', 'US'),
  Locale('tr', 'TR'),
  Locale('es', 'ES'),
  Locale('pt', 'PT'),
  Locale('fr', 'FR'),
  Locale('it', 'IT'),
  Locale('de', 'DE'),
  Locale('ru', 'RU'),
  Locale('ja', 'JP'),
  Locale('ko', 'KR'),
  Locale('hi', 'IN'),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: _supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('tr', 'TR'),
      // Bazı target’larda SharedPreferences kanalı hazır olmayabiliyor (hot restart vs).
      // Crash’ı engellemek için şimdilik kapalı; dil yine değişir.
      saveLocale: false,
      child: const ProviderScope(
        child: SixpackApp(),
      ),
    ),
  );
}

class SixpackApp extends StatelessWidget {
  const SixpackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ez = EasyLocalization.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sixpack30',
      locale: ez?.locale ?? const Locale('tr', 'TR'),
      supportedLocales: ez?.supportedLocales ?? _supportedLocales,
      localizationsDelegates: ez?.delegates ??
          const <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}
