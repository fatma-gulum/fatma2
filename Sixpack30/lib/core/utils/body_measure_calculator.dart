import 'package:sixpack30/core/constants/body_measure_constants.dart';

double calculateDefaultTargetWeight(double currentWeightKg, {double delta = 10}) {
  final raw = currentWeightKg - delta;
  final clamped = raw.clamp(
    BodyMeasureConstants.minTargetWeightKg,
    BodyMeasureConstants.maxTargetWeightKg,
  );
  return (clamped * 10).round() / 10;
}

