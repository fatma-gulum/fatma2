import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sixpack30/Colors/app_colors.dart';
import 'package:sixpack30/View/VucudunuzubilinView/vucudunuzubilin_view.dart';
import 'package:sixpack30/Text/app_text_styles.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/Text/height.dart';
import 'package:sixpack30/Text/size.dart';
import 'package:sixpack30/Text/width.dart';
import 'package:sixpack30/View/VucutOzellikleriView/height_ruler.dart';
import 'package:sixpack30/View/VucutOzellikleriView/weight_ruler.dart';
import 'package:sixpack30/core/constants/body_measure_constants.dart';
import 'package:sixpack30/core/utils/body_measure_calculator.dart';

class VucutOzellikleriView extends StatefulWidget {
  const VucutOzellikleriView({super.key});

  @override
  State<VucutOzellikleriView> createState() => _VucutOzellikleriViewState();
}

class _VucutOzellikleriViewState extends State<VucutOzellikleriView> {
  static const int totalSteps = 4;
  int _step = 1;
  int _selectedYearIndex = 75;
  int _selectedHeightCm = BodyMeasureConstants.minHeightCm;
  HeightUnit _heightUnit = HeightUnit.cm;
  double _selectedWeightKg = BodyMeasureConstants.minWeightKg;
  WeightUnit _weightUnit = WeightUnit.kg;
  double _selectedTargetWeightKg = BodyMeasureConstants.minTargetWeightKg;

  late final FixedExtentScrollController _yearController;
  final ScrollController _rulerScrollController = ScrollController();
  final ScrollController _weightScrollController = ScrollController();
  final ScrollController _targetWeightScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _yearController = FixedExtentScrollController(initialItem: _selectedYearIndex);
  }

  @override
  void dispose() {
    _yearController.dispose();
    _rulerScrollController.dispose();
    _weightScrollController.dispose();
    _targetWeightScrollController.dispose();
    super.dispose();
  }

  void _onRulerScroll() {
    if (!_rulerScrollController.hasClients) return;
    final pos = _rulerScrollController.position;
    final vh = pos.viewportDimension;
    final off = _rulerScrollController.offset + vh / 2;
    final idx = (off / heightRulerTickSpacingPx)
        .round()
        .clamp(0, BodyMeasureConstants.maxHeightCm - BodyMeasureConstants.minHeightCm);
    final v = BodyMeasureConstants.minHeightCm + idx;
    if (v != _selectedHeightCm) setState(() => _selectedHeightCm = v);
  }

  void _onWeightScroll() {
    if (!_weightScrollController.hasClients) return;
    final pos = _weightScrollController.position;
    final vw = pos.viewportDimension;
    final off = _weightScrollController.offset + vw / 2;
    final idx = (off / weightRulerTickSpacingPx)
        .round()
        .clamp(0, (BodyMeasureConstants.maxWeightKg - BodyMeasureConstants.minWeightKg).round());
    final v = BodyMeasureConstants.minWeightKg + idx;
    if ((v - _selectedWeightKg).abs() > 0.01) {
      setState(() => _selectedWeightKg = v);
    }
  }

  void _onTargetWeightScroll() {
    if (!_targetWeightScrollController.hasClients) return;
    final pos = _targetWeightScrollController.position;
    final vw = pos.viewportDimension;
    final off = _targetWeightScrollController.offset + vw / 2;
    final range = (BodyMeasureConstants.maxTargetWeightKg - BodyMeasureConstants.minTargetWeightKg).round();
    final idx = (off / weightRulerTickSpacingPx).round().clamp(0, range);
    final v = BodyMeasureConstants.minTargetWeightKg + idx;
    if ((v - _selectedTargetWeightKg).abs() > 0.01) {
      setState(() => _selectedTargetWeightKg = v);
    }
  }

  void _showWeightUnitPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF1FFF6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                'Kilo birimi',
                style: TextStyle(
                  fontFamily: AppFont.montserrat,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text(
                  'kg (kilogram)',
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  setState(() => _weightUnit = WeightUnit.kg);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                title: const Text(
                  'lb (pound)',
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text(
                  'Amerikan birimi',
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontSize: 12,
                    color: Color(0xFFB1B1B1),
                  ),
                ),
                onTap: () {
                  setState(() => _weightUnit = WeightUnit.lb);
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showHeightUnitPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF1FFF6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                'Boy birimi',
                style: TextStyle(
                  fontFamily: AppFont.montserrat,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text(
                  'cm (santimetre)',
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  setState(() => _heightUnit = HeightUnit.cm);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                title: const Text(
                  'ft in (ayak / inç)',
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text(
                  'Amerikan birimi',
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontSize: 12,
                    color: Color(0xFFB1B1B1),
                  ),
                ),
                onTap: () {
                  setState(() => _heightUnit = HeightUnit.ftIn);
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  int get _selectedYear => BodyMeasureConstants.birthYearStart + _selectedYearIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset(
                          'assets/images/icons/Frame 6952.svg',
                          width: 25,
                          height: 24,
                        ),
                        onPressed: () {
                          if (_step > 1) {
                            setState(() => _step--);
                          } else {
                            Navigator.of(context).maybePop();
                          }
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 194,
                        height: 24,
                        child: Center(
                          child: Text(
                            'Vücut',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.screenHeader,
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$_step/$totalSteps',
                          style: const TextStyle(
                            fontFamily: AppFont.montserrat,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: AppTextHeight.full,
                            letterSpacing: AppTextWidth.normal,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: _ProgressBarSegment(isActive: _step >= 1),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ProgressBarSegment(isActive: _step >= 2),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ProgressBarSegment(isActive: _step >= 3),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ProgressBarSegment(isActive: _step >= 4),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (_step == 1) ...[
                    const SizedBox(
                      width: 343,
                      height: 22,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Doğum yılınız Nedir?',
                          style: AppTextStyles.questionTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 180,
                      child: CupertinoTheme(
                        data: const CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        child: CupertinoPicker(
                          scrollController: _yearController,
                          itemExtent: 50,
                          diameterRatio: 1.2,
                          squeeze: 0.8,
                          useMagnifier: true,
                          magnification: 1.1,
                          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                            background: Colors.transparent,
                          ),
                          onSelectedItemChanged: (i) {
                            setState(() => _selectedYearIndex = i);
                          },
                          children: List.generate(BodyMeasureConstants.birthYearCount, (i) {
                            final year = BodyMeasureConstants.birthYearStart + i;
                            return Center(
                              child: Text(
                                '$year',
                                style: const TextStyle(
                                  fontFamily: AppFont.montserrat,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                  if (_step == 2) ...[
                    const SizedBox(
                      width: 343,
                      height: 22,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Boyunuz nedir?',
                          style: AppTextStyles.questionTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => _showHeightUnitPicker(context),
                      child: Container(
                        width: 90,
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00EF5B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFF00EF5B),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _heightUnit == HeightUnit.cm ? 'cm' : 'ft in',
                              style: const TextStyle(
                                fontFamily: AppFont.montserrat,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFFFFFFFF),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 210,
                      child: HeightRuler(
                        selectedHeightCm: _selectedHeightCm,
                        scrollController: _rulerScrollController,
                        onScroll: _onRulerScroll,
                        heightUnit: _heightUnit,
                      ),
                    ),
                  ],
                  if (_step == 3) ...[
                    const SizedBox(
                      width: 343,
                      height: 22,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Mevcut kilonuz nedir?',
                          style: AppTextStyles.questionTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () => _showWeightUnitPicker(context),
                        child: Container(
                          width: 90,
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00EF5B),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFF00EF5B),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _weightUnit == WeightUnit.kg ? 'kg' : 'lb',
                                style: const TextStyle(
                                  fontFamily: AppFont.montserrat,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFFFFFFFF),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 53),
                    SizedBox(
                      height: 210,
                      child: WeightRuler(
                        selectedWeightKg: _selectedWeightKg,
                        scrollController: _weightScrollController,
                        onScroll: _onWeightScroll,
                        weightUnit: _weightUnit,
                      ),
                    ),
                  ],
                  if (_step == 4) ...[
                    const SizedBox(
                      width: 343,
                      height: 22,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hedef kilonuz nedir?',
                          style: AppTextStyles.questionTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () => _showWeightUnitPicker(context),
                        child: Container(
                          width: 90,
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00EF5B),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFF00EF5B),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _weightUnit == WeightUnit.kg ? 'kg' : 'lb',
                                style: const TextStyle(
                                  fontFamily: AppFont.montserrat,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFFFFFFFF),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/Polygon 7.svg',
                            width: 12,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF373434),
                              BlendMode.srcIn,
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/images/icons/Polygon 8.svg',
                            width: 12,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFD9D9D9),
                              BlendMode.srcIn,
                            ),
                          ),
                        const SizedBox(width: 6),
                        Text(
                          _weightUnit == WeightUnit.kg
                              ? '${_selectedWeightKg % 1 == 0 ? _selectedWeightKg.round() : _selectedWeightKg.toStringAsFixed(1)} kg'
                              : '${weightKgToLb(_selectedWeightKg)} lb',
                          style: const TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Color(0xFFB1B1B1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 210,
                      child: WeightRuler(
                        selectedWeightKg: _selectedTargetWeightKg,
                        scrollController: _targetWeightScrollController,
                        onScroll: _onTargetWeightScroll,
                        minKg: BodyMeasureConstants.minTargetWeightKg,
                        maxKg: BodyMeasureConstants.maxTargetWeightKg,
                        weightUnit: _weightUnit,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: SizedBox(
                width: 342,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00EF5B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_step < totalSteps) {
                      setState(() {
                        if (_step == 3) {
                          _selectedTargetWeightKg =
                              calculateDefaultTargetWeight(_selectedWeightKg);
                        }
                        _step++;
                      });
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const VucudunuzubilinView(),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 61,
                        height: 20,
                        child: Center(
                          child: Text(
                            'Sonraki',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 1.0,
                              letterSpacing: -0.18,
                              color: Color(0xFF0A0A0A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/images/icons/iconstack.io - (Arrow Down).svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0A0A0A),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBarSegment extends StatelessWidget {
  final bool isActive;

  const _ProgressBarSegment({this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF00EF5B)
            : const Color(0xFFD7D7D7),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
