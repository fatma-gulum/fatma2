import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sixpack30/riverpod/providers/all_providers.dart';
import 'package:sixpack30/View/VucutView/vucut_view.dart'; // Onboarding2View
import 'package:sixpack30/View/VucutOzellikleriView/vucut_ozellikleri_view.dart';
import 'package:sixpack30/Colors/app_colors.dart';
import 'package:sixpack30/Text/app_text_styles.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/Text/height.dart';
import 'package:sixpack30/Text/size.dart';
import 'package:sixpack30/Text/width.dart';

class Onboarding1View extends ConsumerStatefulWidget {
  final int currentStep;
  final int totalSteps;

  const Onboarding1View({
    super.key,
    this.currentStep = 1,
    this.totalSteps = 4,
  });

  @override
  ConsumerState<Onboarding1View> createState() => _Onboarding1ViewState();
}

class _Onboarding1ViewState extends ConsumerState<Onboarding1View> {
  int _step = 1; // 1..4
  String? _selectedGender; // 'kadin' | 'erkek' | 'none' | null
  String? _selectedGoal; // 'gobek' | 'karin' | null
  int _bodyTypeIndex = 4; // 0..5, Biçimli=0, Ekstra=5, default 5th dot

  /// Adım 3: Mevcut vücut tipi görseli — cinsiyete göre
  String get _step3BodyImagePath {
    switch (_selectedGender) {
      case 'kadin':
        return 'assets/images/resimler/ekstravucut_kadin.jpg';
      case 'erkek':
        return 'assets/images/resimler/ekstravucut_erkek.jpg';
      default:
        return 'assets/images/resimler/ekstravucut.jpg';
    }
  }

  /// Adım 4: İstenen vücut tipi görseli — cinsiyete göre
  String get _step4BodyImagePath {
    switch (_selectedGender) {
      case 'kadin':
        return 'assets/images/resimler/bicimlivucut_kadin.jpg';
      case 'erkek':
        return 'assets/images/resimler/bicimlivucut_erkek.jpg';
      default:
        return 'assets/images/resimler/bicimlivucut.jpg';
    }
  }

  /// Kadın vücudu: Biçimli (0) → Ekstra (5). Step 4'te 7 nokta için son görsel tekrarlanır.
  static const List<String> _kadinVucutPaths = [
    'assets/images/resimler/kadın vücudu/Rectangle.jpg',
    'assets/images/resimler/kadın vücudu/Rectangle (1).jpg',
    'assets/images/resimler/kadın vücudu/Rectangle (2).jpg',
    'assets/images/resimler/kadın vücudu/Rectangle (3).jpg',
    'assets/images/resimler/kadın vücudu/Rectangle (4).jpg',
    'assets/images/resimler/kadın vücudu/Rectangle (5).jpg',
  ];

  /// Erkek vücudu: Biçimli (0) → Ekstra (5). Step 4'te 7 nokta için son görsel tekrarlanır.
  static const List<String> _erkekVucutPaths = [
    'assets/images/resimler/erkek vücudu/4 81.jpg',
    'assets/images/resimler/erkek vücudu/5 4.jpg',
    'assets/images/resimler/erkek vücudu/6 4.jpg',
    'assets/images/resimler/erkek vücudu/7 1.jpg',
    'assets/images/resimler/erkek vücudu/8 3.jpg',
    'assets/images/resimler/erkek vücudu/9 1.jpg',
  ];

  /// Slider indeksine göre vücut görseli (kadın/erkek seçiliyse klasördeki fotoğraflar).
  String _bodyImagePathForSlider(bool isStep3) {
    final dotCount = isStep3 ? 6 : 7;
    final index = _bodyTypeIndex.clamp(0, dotCount - 1);
    if (_selectedGender == 'kadin') {
      final list = _kadinVucutPaths;
      return list[index.clamp(0, list.length - 1)];
    }
    if (_selectedGender == 'erkek') {
      final list = _erkekVucutPaths;
      return list[index.clamp(0, list.length - 1)];
    }
    return isStep3 ? _step3BodyImagePath : _step4BodyImagePath;
  }

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
                            'Hedef & Odak',
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
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Text(
                            '$_step/${widget.totalSteps}',
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
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: _ProgressBarSegment(
                              isActive: _step >= 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ProgressBarSegment(
                              isActive: _step >= 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ProgressBarSegment(
                              isActive: _step >= 3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ProgressBarSegment(
                              isActive: _step >= 4,
                            ),
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
                          'Cinsiyetiniz nedir?',
                          style: AppTextStyles.questionTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _GenderCard(
                          label: 'Kadın',
                          isSelected: _selectedGender == 'kadin',
                          imagePath: 'assets/images/resimler/kadın.jpeg',
                          imageAlignment: Alignment(0, -0.1),
                          imageScale: 1.0,
                          imageHeightFactor: null,
                          unselectedBorderColor: const Color(0xFF969A9D),
                          onTap: () {
                            ref.read(selectedGenderProvider.notifier).state = 'kadin';
                            setState(() => _selectedGender = 'kadin');
                          },
                          ),
                          const SizedBox(width: 12),
                          _GenderCard(
                            label: 'Erkek',
                            isSelected: _selectedGender == 'erkek',
                            imagePath: 'assets/images/resimler/erkek.jpeg',
                            imageAlignment: Alignment.center,
                            imageScale: 1.0,
                            imageHeightFactor: null,
                            onTap: () {
                            ref.read(selectedGenderProvider.notifier).state = 'erkek';
                            setState(() => _selectedGender = 'erkek');
                          },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                            ref.read(selectedGenderProvider.notifier).state = 'none';
                            setState(() => _selectedGender = 'none');
                          },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _selectedGender == 'none'
                                ? const Color(0xFF06C44F)
                                : const Color(0xFFD7D7D7),
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/icons/Vector (3).svg',
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                _selectedGender == 'none'
                                    ? const Color(0xFF06C44F)
                                    : const Color(0xFF0A0A0A),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Belirtmek istemiyorum',
                              style: TextStyle(
                                fontFamily: AppFont.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: AppTextHeight.full,
                                letterSpacing: AppTextWidth.normal,
                                color: _selectedGender == 'none'
                                    ? const Color(0xFF06C44F)
                                    : const Color(0xFF0A0A0A),
                              ),
                            ),
                          ],
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
                          'Ana hedefiniz nedir?',
                          style: AppTextStyles.questionTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _GoalCard(
                      label: 'Göbek Eritme',
                      imagePath: 'assets/images/resimler/gobekeritme.jpg',
                      isSelected: _selectedGoal == 'gobek',
                      onTap: () => setState(() => _selectedGoal = 'gobek'),
                      imageWidth: 104,
                      imageHeight: 85,
                      imageBorderRadius: const BorderRadius.only(
                        topRight: Radius.circular(2),
                        bottomRight: Radius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _GoalCard(
                      label: 'Karın Kası Yapma',
                      imagePath: 'assets/images/resimler/karinkasiyapma.jpg',
                      isSelected: _selectedGoal == 'karin',
                      onTap: () => setState(() => _selectedGoal = 'karin'),
                      imageWidth: 104,
                      imageHeight: 85,
                      imageBorderRadius: const BorderRadius.only(
                        topRight: Radius.circular(2),
                        bottomRight: Radius.circular(2),
                      ),
                    ),
                  ],
                  if (_step == 3 || _step == 4) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _step == 4
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const Onboarding2View(),
                                ),
                              );
                            }
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 343,
                            height: 22,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _step == 3
                                    ? 'Vücut tipiniz nedir?'
                                    : 'İstediğiniz vücut tipi nedir?',
                                style: AppTextStyles.questionTitle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 340,
                            width: double.infinity,
                            child: _step == 3
                                ? Image.asset(
                                    _bodyImagePathForSlider(true),
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 340,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/resimler/ekstravucut.jpg',
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      height: 340,
                                    ),
                                  )
                                : Image.asset(
                                    _bodyImagePathForSlider(false),
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 340,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/resimler/bicimlivucut.jpg',
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      height: 340,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 32),
                          _BodyTypeSlider(
                            value: _bodyTypeIndex,
                            dotCount: _step == 3 ? 6 : 7,
                            onChanged: (v) => setState(() => _bodyTypeIndex = v),
                          ),
                        ],
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
                    backgroundColor: const Color(0xFF00EF5B), // #00EF5B
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Radius 10
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_step == 4) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const Onboarding2View(),
                        ),
                      );
                    } else if (_step < widget.totalSteps) {
                      setState(() {
                        if (_step == 3) _bodyTypeIndex = 2;
                        _step++;
                      });
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

class _GoalCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  final double imageWidth;
  final double imageHeight;
  final BorderRadius? imageBorderRadius;

  const _GoalCard({
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    this.imageWidth = 72,
    this.imageHeight = 72,
    this.imageBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final cardHeight = imageHeight;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF06C44F)
                : const Color(0x33606060),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: imageBorderRadius ?? BorderRadius.zero,
                child: SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFE0E0E0),
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: AppTextHeight.full,
                    letterSpacing: AppTextWidth.normal,
                    color: Color(0xFF100F0F),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyTypeSlider extends StatelessWidget {
  final int value;
  final int dotCount;
  final ValueChanged<int> onChanged;

  const _BodyTypeSlider({
    required this.value,
    required this.onChanged,
    this.dotCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value.clamp(0, dotCount - 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 342,
          height: 28,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 342,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFCDFFE0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(dotCount, (i) {
                  final isSelected = displayValue == i;
                  return GestureDetector(
                    onTap: () => onChanged(i),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      child: Container(
                        width: isSelected ? 24 : 8,
                        height: isSelected ? 24 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0x7D00EF5B)
                              : const Color(0xFF8FFFBA),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF39DB77),
                                  width: 2.5,
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Biçimli',
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.0,
                letterSpacing: 0.0,
                color: Color(0xFF000000),
              ),
            ),
            Text(
              'Ekstra',
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.0,
                letterSpacing: 0.0,
                color: Color(0xFF000000),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressBarSegment extends StatelessWidget {
  final bool isActive;

  const _ProgressBarSegment({this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF00EF5B) // aktif #00EF5B
              : const Color(0xFFD7D7D7), // pasif #D7D7D7
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final Alignment imageAlignment;
  final double imageScale;
  final double? imageHeightFactor; // null => tam yükseklik
  final Color? unselectedBorderColor; // seçili değilken çerçeve rengi
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    this.imageAlignment = Alignment.center,
    this.imageScale = 1.0,
    this.imageHeightFactor,
    this.unselectedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 240,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), // Radius 6px
          border: Border.all(
            color: isSelected
                ? const Color(0xFF06C44F) // seçili: #06C44F
                : (unselectedBorderColor ?? const Color(0x33606060)),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageHeightFactor != null)
                Align(
                  alignment: Alignment.topCenter,
                  heightFactor: imageHeightFactor,
                  child: _buildFilteredImage(),
                )
              else
                _buildFilteredImage(),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildFilteredImage() {
    return Transform.scale(
      scale: imageScale,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          const Color(0x33606060), // #60606033, %20 opaklık
          BlendMode.srcATop,
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          alignment: imageAlignment,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFE0E0E0),
            child: const Center(child: Icon(Icons.image_not_supported)),
          ),
        ),
      ),
    );
  }
}

