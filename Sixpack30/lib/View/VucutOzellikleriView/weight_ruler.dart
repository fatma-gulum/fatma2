import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/core/constants/body_measure_constants.dart';

/// Kilo birimi: kilogram veya Amerikan (pound).
enum WeightUnit {
  kg,
  lb,
}

/// kg → lb dönüşümü (1 kg ≈ 2.20462 lb). Gösterim için yuvarlanmış tam sayı.
int weightKgToLb(double kg) => (kg * 2.20462).round();

/// 1 kg arası piksel (boy cetveli gibi sık, yatay). Dış scroll hesaplaması için kullanılır.
const double weightRulerTickSpacingPx = 6.0;

/// Çizgi yükseklikleri (aşağıdan yukarı): 1kg kısa, 5kg orta, 10kg en uzun
const double _tickHeightShort = 12.0;
const double _tickHeightMid = 20.0;
const double _tickHeightLong = 28.0;

class WeightRuler extends StatefulWidget {
  final double selectedWeightKg;
  final ScrollController scrollController;
  final VoidCallback onScroll;
  /// Mevcut kilo için varsayılan (40–180). Hedef kilo için 30 ve 120 verin.
  final double minKg;
  final double maxKg;
  final WeightUnit weightUnit;

  const WeightRuler({
    super.key,
    required this.selectedWeightKg,
    required this.scrollController,
    required this.onScroll,
    this.minKg = BodyMeasureConstants.minWeightKg,
    this.maxKg = BodyMeasureConstants.maxWeightKg,
    this.weightUnit = WeightUnit.kg,
  });

  @override
  State<WeightRuler> createState() => _WeightRulerState();
}

class _WeightRulerState extends State<WeightRuler> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(widget.onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTo(widget.selectedWeightKg));
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(widget.onScroll);
    super.dispose();
  }

  void _scrollTo(double kg) {
    if (!widget.scrollController.hasClients) return;
    final vw = widget.scrollController.position.viewportDimension;
    final kgRounded = kg.round().toDouble().clamp(widget.minKg, widget.maxKg);
    final idx = (kgRounded - widget.minKg).round();
    final tickX = idx * weightRulerTickSpacingPx;
    final tickAreaW = (widget.maxKg - widget.minKg) * weightRulerTickSpacingPx;
    final pad = vw / 2;
    final totalW = tickAreaW + pad * 2;
    final maxOff = (totalW - vw).clamp(0.0, double.infinity);
    // Sağ/sol vw/2 padding var; seçili çizgiyi ortalamak için direkt tickX yeterli.
    final t = tickX.clamp(0.0, maxOff);
    if ((widget.scrollController.offset - t).abs() > 1) {
      widget.scrollController.jumpTo(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tickAreaWidth = (widget.maxKg - widget.minKg) * weightRulerTickSpacingPx;

    return LayoutBuilder(
      builder: (_, constraints) {
        final h = constraints.maxHeight;
        final pad = constraints.maxWidth / 2;
        final totalWidth = tickAreaWidth + pad * 2;
        return Stack(
          children: [
            SizedBox(
              height: h,
              child: SingleChildScrollView(
                controller: widget.scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: SizedBox(
                  width: totalWidth,
                  height: h,
                  child: Row(
                    children: [
                      SizedBox(width: pad),
                      SizedBox(
                        width: tickAreaWidth,
                        height: h,
                        child: CustomPaint(
                          size: Size(tickAreaWidth, h),
                          painter: _WeightRulerPainter(
                            minKg: widget.minKg,
                            maxKg: widget.maxKg,
                            weightUnit: widget.weightUnit,
                          ),
                        ),
                      ),
                      SizedBox(width: pad),
                    ],
                  ),
                ),
              ),
            ),
            // Kilo değeri çubuğun hemen üstünde (cetvel çubuğuna yakın)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontFamily: AppFont.montserrat,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            letterSpacing: 0,
                            color: Color(0xFF000000),
                          ),
                          children: [
                            if (widget.weightUnit == WeightUnit.kg) ...[
                              TextSpan(
                                text: widget.selectedWeightKg % 1 == 0
                                    ? '${widget.selectedWeightKg.round()}'
                                    : widget.selectedWeightKg.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 24),
                              ),
                              const TextSpan(
                                text: ' ',
                                style: TextStyle(fontSize: 15.61),
                              ),
                              const TextSpan(
                                text: 'kg',
                                style: TextStyle(fontSize: 16),
                              ),
                            ] else ...[
                              TextSpan(
                                text: '${weightKgToLb(widget.selectedWeightKg)}',
                                style: const TextStyle(fontSize: 24),
                              ),
                              const TextSpan(
                                text: ' ',
                                style: TextStyle(fontSize: 15.61),
                              ),
                              const TextSpan(
                                text: 'lb',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 2,
                        height: h * 0.6,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        color: const Color(0xFF00EF5B),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WeightRulerPainter extends CustomPainter {
  _WeightRulerPainter({
    required this.minKg,
    required this.maxKg,
    required this.weightUnit,
  });
  final double minKg;
  final double maxKg;
  final WeightUnit weightUnit;

  static const _colorTick = Color(0xFFC2C2C2);
  static const _colorLabel = Color(0xFFB1B1B1);

  @override
  void paint(Canvas canvas, Size size) {
    final minKgi = minKg.round();
    final maxKgi = maxKg.round();
    final bottom = size.height;

    final labelStyle = TextStyle(
      fontFamily: AppFont.montserrat,
      fontWeight: FontWeight.w600,
      fontSize: weightUnit == WeightUnit.lb ? 16 : 18,
      height: 1.0,
      color: _colorLabel,
    );

    for (int kg = minKgi; kg <= maxKgi; kg++) {
      final x = (kg - minKgi) * weightRulerTickSpacingPx;
      final is10 = kg % 10 == 0;
      final is5 = kg % 5 == 0;

      double h;
      if (is10) {
        h = _tickHeightLong;
      } else if (is5) {
        h = _tickHeightMid;
      } else {
        h = _tickHeightShort;
      }

      final yEnd = bottom - h;
      final paint = Paint()
        ..color = _colorTick
        ..strokeWidth = is10 ? 2.0 : (is5 ? 1.5 : 1.2)
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(x, bottom), Offset(x, yEnd), paint);

      if (is10) {
        final label = weightUnit == WeightUnit.lb
            ? '${weightKgToLb(kg.toDouble())}'
            : '$kg';
        final textPainter = TextPainter(
          text: TextSpan(text: label, style: labelStyle),
          textDirection: ui.TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, bottom - h - textPainter.height - 4),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WeightRulerPainter oldDelegate) =>
      oldDelegate.minKg != minKg ||
      oldDelegate.maxKg != maxKg ||
      oldDelegate.weightUnit != weightUnit;
}
