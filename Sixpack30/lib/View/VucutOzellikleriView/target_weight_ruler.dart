import 'package:flutter/material.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/core/constants/body_measure_constants.dart';

class TargetWeightRuler extends StatefulWidget {
  final double selectedWeightKg;
  final ScrollController scrollController;
  final VoidCallback onScroll;

  const TargetWeightRuler({
    super.key,
    required this.selectedWeightKg,
    required this.scrollController,
    required this.onScroll,
  });

  @override
  State<TargetWeightRuler> createState() => _TargetWeightRulerState();
}

class _TargetWeightRulerState extends State<TargetWeightRuler> {
  static const double _tickW = 8;
  static const int _ticksPerKg = 10;

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
    final idx = ((kg - BodyMeasureConstants.minTargetWeightKg) * _ticksPerKg).round();
    final itemCount = ((BodyMeasureConstants.maxTargetWeightKg -
                    BodyMeasureConstants.minTargetWeightKg) *
                _ticksPerKg)
            .round() +
        1;
    final off = idx * _tickW;
    final maxOff = itemCount * _tickW - vw;
    final t = (off - vw / 2 + _tickW / 2).clamp(0.0, maxOff.clamp(0.0, double.infinity));
    if ((widget.scrollController.offset - t).abs() > 1) {
      widget.scrollController.jumpTo(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = ((BodyMeasureConstants.maxTargetWeightKg -
                BodyMeasureConstants.minTargetWeightKg) *
            _ticksPerKg)
        .round() +
        1;
    return LayoutBuilder(
      builder: (_, constraints) {
        return Stack(
          children: [
            SizedBox(
              height: 180,
              child: ListView.builder(
                controller: widget.scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: itemCount,
                itemBuilder: (_, i) {
                  final kg = BodyMeasureConstants.minTargetWeightKg + i / _ticksPerKg;
                  final isMajor = i % _ticksPerKg == 0;
                  return SizedBox(
                    width: _tickW,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isMajor) ...[
                          SizedBox(
                            width: 27.31,
                            height: 13.01,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '${kg.round()}',
                                style: const TextStyle(
                                  fontFamily: AppFont.montserrat,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  height: 1.0,
                                  letterSpacing: 0,
                                  color: Color(0xFF4A4A4A),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ] else
                          const SizedBox(height: 21.01),
                        Container(
                          width: 1.3,
                          height: isMajor ? 28 : 14,
                          decoration: BoxDecoration(
                            color: const Color(0xBBD5D5D5),
                            borderRadius: BorderRadius.circular(0.65),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Center(
                  child: Transform.rotate(
                    angle: 90 * 3.14159265359 / 180,
                    child: Container(
                      width: 127,
                      height: 1.3,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00EF5B),
                        border: Border.all(
                          width: 1.3,
                          color: const Color(0xFF00EF5B),
                        ),
                      ),
                    ),
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

