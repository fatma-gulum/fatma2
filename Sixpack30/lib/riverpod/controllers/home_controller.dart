import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider = Provider<HomeController>(
  (ref) => HomeController(),
);

class HomeController {
  String get title => 'Sixpack30';
}

