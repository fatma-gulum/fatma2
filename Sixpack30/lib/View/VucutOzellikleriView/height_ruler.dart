import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/core/constants/body_measure_constants.dart';

/// Boy birimi: santimetre veya Amerikan (ayak / inç).
enum HeightUnit {
  cm,
  ftIn,
}

/// 1 cm arası piksel (iPhone Health benzeri sık cetvel). Dış scroll hesaplaması için kullanılır.
const double heightRulerTickSpacingPx = 7.0;

/// cm → (feet, inches) dönüşümü (gösterim için yuvarlanmış).
(int feet, int inches) heightCmToFeetInches(int cm) {
  final totalInches = cm / 2.54;
  var feet = (totalInches / 12).floor();
  var inches = (totalInches % 12).round();
  if (inches == 12) {
    inches = 0;
    feet += 1;
  }
  return (feet, inches);
}

String formatHeightFeetInches(int feet, int inches) => "$feet'$inches\"";

/// Çizgi uzunlukları (sağdan sola): 1cm kısa, 5cm orta, 10cm en uzun
const double _tickLengthShort = 12.0;
const double _tickLengthMid = 20.0;
const double _tickLengthLong = 28.0;

class HeightRuler extends StatefulWidget {
  final int selectedHeightCm;
  final ScrollController scrollController;
  final VoidCallback onScroll;
  final HeightUnit heightUnit;

  const HeightRuler({
    super.key,
    required this.selectedHeightCm,
    required this.scrollController,
    required this.onScroll,
    this.heightUnit = HeightUnit.cm,
  });

  @override
  State<HeightRuler> createState() => _HeightRulerState();
}

class _HeightRulerState extends State<HeightRuler> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(widget.onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTo(widget.selectedHeightCm));
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(widget.onScroll);
    super.dispose();
  }

  void _scrollTo(int cm) {
    if (!widget.scrollController.hasClients) return;
    final vh = widget.scrollController.position.viewportDimension;
    final idx = cm - BodyMeasureConstants.minHeightCm;
    final tickY = idx * heightRulerTickSpacingPx;
    final totalH = (BodyMeasureConstants.maxHeightCm - BodyMeasureConstants.minHeightCm) * heightRulerTickSpacingPx;
    final maxOff = (totalH - vh).clamp(0.0, double.infinity);
    // Seçili cm çizgisini viewport tam ortasına getir
    final t = (tickY - vh / 2).clamp(0.0, maxOff);
    if ((widget.scrollController.offset - t).abs() > 1) {
      widget.scrollController.jumpTo(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = (BodyMeasureConstants.maxHeightCm - BodyMeasureConstants.minHeightCm) * heightRulerTickSpacingPx;

    return LayoutBuilder(
      builder: (_, constraints) {
        return Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: widget.scrollController,
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: SizedBox(
                      height: totalHeight,
                      width: double.infinity,
                      child: CustomPaint(
                        size: Size(constraints.maxWidth, totalHeight),
                        painter: _HeightRulerPainter(heightUnit: widget.heightUnit),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              top: (constraints.maxHeight - 29) / 2,
              child: IgnorePointer(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: 72,
                      height: 29,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Color(0xFF000000),
                            ),
                            children: [
                              if (widget.heightUnit == HeightUnit.cm) ...[
                                TextSpan(
                                  text: '${widget.selectedHeightCm}',
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const TextSpan(
                                  text: ' ',
                                  style: TextStyle(fontSize: 15.61),
                                ),
                                const TextSpan(
                                  text: 'cm',
                                  style: TextStyle(fontSize: 15.61),
                                ),
                              ] else ...[
                                TextSpan(
                                  text: formatHeightFeetInches(
                                    heightCmToFeetInches(widget.selectedHeightCm).$1,
                                    heightCmToFeetInches(widget.selectedHeightCm).$2,
                                  ),
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ],
                            ],
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 0,
                        margin: EdgeInsets.zero,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF00EF5B),
                              width: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeightRulerPainter extends CustomPainter {
  _HeightRulerPainter({required this.heightUnit});
  final HeightUnit heightUnit;

  static const _colorTick = Color(0xFFC2C2C2);
  static const _colorLabel = Color(0xFFB1B1B1);

  @override
  void paint(Canvas canvas, Size size) {
    final minCm = BodyMeasureConstants.minHeightCm;
    final maxCm = BodyMeasureConstants.maxHeightCm;
    final right = size.width;

    final labelStyle = TextStyle(
      fontFamily: AppFont.montserrat,
      fontWeight: FontWeight.w600,
      fontSize: heightUnit == HeightUnit.ftIn ? 16 : 18,
      height: 1.0,
      color: _colorLabel,
    );

    for (int cm = minCm; cm <= maxCm; cm++) {
      final y = (cm - minCm) * heightRulerTickSpacingPx;
      final is10 = cm % 10 == 0;
      final is5 = cm % 5 == 0;

      double len;
      if (is10) {
        len = _tickLengthLong;
      } else if (is5) {
        len = _tickLengthMid;
      } else {
        len = _tickLengthShort;
      }

      final xStart = right - len;
      final paint = Paint()
        ..color = _colorTick
        ..strokeWidth = is10 ? 2.0 : (is5 ? 1.5 : 1.2)
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(xStart, y), Offset(right, y), paint);

      if (is10) {
        final label = heightUnit == HeightUnit.ftIn
            ? formatHeightFeetInches(
                heightCmToFeetInches(cm).$1,
                heightCmToFeetInches(cm).$2,
              )
            : '$cm';
        final textPainter = TextPainter(
          text: TextSpan(text: label, style: labelStyle),
          textDirection: ui.TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(xStart - textPainter.width - 6, y - textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeightRulerPainter oldDelegate) =>
      oldDelegate.heightUnit != heightUnit;
}
