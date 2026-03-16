class BodyMeasureConstants {
  BodyMeasureConstants._();

  static const int minHeightCm = 100;
  static const int maxHeightCm = 220;

  static const double minWeightKg = 40;
  static const double maxWeightKg = 180;

  static const double minTargetWeightKg = 30;
  static const double maxTargetWeightKg = 120;

  static const int birthYearStart = 1925;

  static int get currentYear => DateTime.now().year;

  static int get birthYearCount => currentYear - birthYearStart + 1;
}

