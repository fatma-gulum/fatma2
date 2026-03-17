import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hedef & Odak sayfasında seçilen cinsiyet: 'kadin' | 'erkek' | 'none' | null
final selectedGenderProvider = StateProvider<String?>((ref) => null);
