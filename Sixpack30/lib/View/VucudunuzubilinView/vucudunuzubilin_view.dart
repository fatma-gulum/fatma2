import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sixpack30/Text/app_text_styles.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/riverpod/providers/all_providers.dart';
import 'package:sixpack30/View/HomeView/home_view.dart';

class Onboarding3View extends StatelessWidget {
  const Onboarding3View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const VucudunuzubilinQuestionView(),
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/resimler/vucudunuzubilin.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(
                color: Color(0xFF333333),
                child: Center(
                  child: Icon(Icons.image_not_supported, color: Colors.white),
                ),
              ),
            ),
            Container(
              color: const Color(0xA8000000),
            ),
            Center(
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 266,
                      height: 98,
                      child: Text(
                        'Vücudunuzu Bilin'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: AppFont.montserrat,
                          fontWeight: FontWeight.w600,
                          fontSize: 40,
                          height: 1.0,
                          letterSpacing: 0,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 266.0011901855469,
                      height: 106,
                      child: SvgPicture.asset(
                        'assets/images/icons/Group 203.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HazirmisinView extends StatelessWidget {
  const HazirmisinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/resimler/hazirmisin.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0.3, 0), // hafif sola kaydır
            errorBuilder: (_, __, ___) => const ColoredBox(
              color: Color(0xFF333333),
              child: Center(
                child: Icon(Icons.image_not_supported, color: Colors.white),
              ),
            ),
          ),
          Container(
            color: const Color(0x42000000),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 136),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                SizedBox(
                  width: 303,
                  height: 68,
                  child: Text(
                    'Kendinin En İyi\nVersiyonu Olmaya'.tr(),
                    style: const TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      height: 34 / 28,
                      letterSpacing: 0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 342,
                  height: 42,
                  child: Text(
                    'Hazır Mısın?'.tr(),
                    style: const TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w700,
                      fontSize: 48,
                      height: 42 / 48,
                      letterSpacing: 0,
                      color: Color(0xFF06C44F),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
          Positioned(
          left: 24,
          right: 24,
          bottom: 48,
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HedefineGoreView(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Evet Hazırım'.tr(),
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
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/images/icons/iconstack.io - (Arrow Down).svg',
                      width: 16,
                      height: 16,
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
    );
  }
}

class HedefineGoreView extends StatefulWidget {
  const HedefineGoreView({super.key});

  @override
  State<HedefineGoreView> createState() => _HedefineGoreViewState();
}

class _HedefineGoreViewState extends State<HedefineGoreView> {
  double _progress = 0.0;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() async {
    while (mounted && _progress < 1.0) {
      await Future.delayed(const Duration(milliseconds: 120));
      setState(() {
        _progress = (_progress + 0.02).clamp(0.0, 1.0);
      });
      if (!_navigated && _progress >= 1.0) {
        _navigated = true;
        if (!mounted) return;
        // 100% olduğunda final ekrana geç
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const Onboarding4View(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _progress >= 0.99 ? 100 : (_progress * 100).round();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/resimler/3876b4113257b32207c79ea46168fee966f888e2.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0.3, 0), // referans ekrandaki gibi daha ortalı görünüm
            errorBuilder: (_, __, ___) => const ColoredBox(
              color: Color(0xFF333333),
              child: Center(
                child: Icon(Icons.image_not_supported, color: Colors.white),
              ),
            ),
          ),
          Container(
            color: const Color(0x42000000),
          ),
          Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 136),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              SizedBox(
                width: 303,
                height: 102,
                child: Text(
                  'Hedefine Göre\nUyarlanmış İçerikler\nHazırlanıyor'.tr(),
                  style: const TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    height: 34 / 28,
                    letterSpacing: 0.0,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
          ),
          Positioned(
          left: 24,
          right: 24,
          bottom: 48,
            child: SizedBox(
              width: 342,
              height: 44,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFD4D4D4),
                ),
                child: Stack(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth * _progress;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          width: w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF00EF5B),
                          ),
                        );
                      },
                    ),
                    // Buton metni: tüm genişlikte ortalanmış
                    Center(
                      child: Text(
                        'Başlayın'.tr(),
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
                    // Yüzdelik: sağda hizalı
                    Positioned(
                      right: 16,
                      top: (44 - 17) / 2,
                      child: SizedBox(
                        width: 35,
                        height: 17,
                        child: Center(
                          child: Text(
                            '%$percentage',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: -0.154, // ~ -1.1%
                              color: Color(0xFF1B1B1B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Onboarding4View extends StatelessWidget {
  const Onboarding4View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/resimler/baslayin.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0.1, 0),
            errorBuilder: (_, __, ___) => const ColoredBox(
              color: Color(0xFF333333),
              child: Center(
                child: Icon(Icons.image_not_supported, color: Colors.white),
              ),
            ),
          ),
          Container(
            color: const Color(0x42000000),
          ),
          Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 136),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                SizedBox(
                  width: 303,
                  height: 102,
                  child: Text(
                    'Hedefine Göre\nUyarlanmış İçerikler\nHazırlanıyor'.tr(),
                    style: const TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      height: 34 / 28,
                      letterSpacing: 0.0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const HomeView(),
                  ),
                  (route) => false,
                );
              },
              child: Container(
                width: 342,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF00EF5B),
                ),
                child: Stack(
                  children: [
                    // Yeşil dolu bar (100%)
                    Container(
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF00EF5B),
                      ),
                    ),
                    // Ortada Başlayın
                    Center(
                      child: Text(
                        'Başlayın'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFont.montserrat,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 1.0,
                          letterSpacing: -0.18,
                          color: Color(0xFF0A0A0A),
                        ),
                      ),
                    ),
                    // Sağda %100
                    Positioned(
                      right: 16,
                      top: (44 - 17) / 2,
                      child: Text(
                        '%100',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFont.montserrat,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.0,
                          letterSpacing: -0.154,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VucudunuzubilinQuestionView extends ConsumerStatefulWidget {
  final int step;
  /// Adım 4 (Aktivite düzeyi) için cinsiyet; geçilmezse provider'dan okunur.
  final String? gender;

  const VucudunuzubilinQuestionView({super.key, this.step = 1, this.gender});

  @override
  ConsumerState<VucudunuzubilinQuestionView> createState() =>
      _VucudunuzubilinQuestionViewState();
}

/// Aktivite düzeyi görselleri: kadın (4), erkek (4). Slider 0=Hareketsiz .. 3=Hareketli.
const List<String> _kadinAktivitePaths = [
  'assets/images/resimler/kadin_aktivite_duzeyi/14 2.jpg',
  'assets/images/resimler/kadin_aktivite_duzeyi/15 4.jpg',
  'assets/images/resimler/kadin_aktivite_duzeyi/17 900 (1).jpg',
  'assets/images/resimler/kadin_aktivite_duzeyi/18 17267576.jpg',
];
const List<String> _erkekAktivitePaths = [
  'assets/images/resimler/erkek_aktivite_duzeyi/19 7.jpg',
  'assets/images/resimler/erkek_aktivite_duzeyi/20 28.jpg',
  'assets/images/resimler/erkek_aktivite_duzeyi/22 1.jpg',
  'assets/images/resimler/erkek_aktivite_duzeyi/23 1.jpg',
];

class _VucudunuzubilinQuestionViewState
    extends ConsumerState<VucudunuzubilinQuestionView> {
  late int _selectedIndex;
  int _activityLevelIndex = 2;
  final Set<int> _selectedDays = {5};
  int _trainingDurationIndex = 2;

  @override
  void initState() {
    super.initState();
    if (widget.step == 2) {
      _selectedIndex = 2;
    } else if (widget.step == 3) {
      _selectedIndex = 1;
    } else {
      _selectedIndex = 1;
    }
  }

  static const double _designWidth = 390.0;
  static const double _designHeight = 844.0;

  /// Cinsiyete ve slider indeksine göre aktivite düzeyi görseli (0=Hareketsiz .. 3=Hareketli)
  String _activityLevelImagePath(String? gender) {
    final idx = _activityLevelIndex.clamp(0, 3);
    if (gender == 'erkek') return _erkekAktivitePaths[idx];
    // kadin veya null/none: kadın aktivite görselleri (slider hep 4 fotoğraf değiştirir)
    return _kadinAktivitePaths[idx];
  }

  Widget _buildActivityLevelImage(double scaleW, double scaleH, String? gender) {
    final path = _activityLevelImagePath(gender);
    final w = 242.18860239322538 * scaleW;
    final h = 242.18860239322538 * scaleH;
    // key: path değişince (slider hareketsiz→hareketli) görsel kesin güncellenir
    return Image.asset(
      path,
      key: ValueKey(path),
      width: w,
      height: h,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      cacheWidth: (w * MediaQuery.of(context).devicePixelRatio).round(),
      cacheHeight: (h * MediaQuery.of(context).devicePixelRatio).round(),
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/resimler/Frame 6959 (3).jpg',
        width: w,
        height: h,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    final size = MediaQuery.of(context).size;
    final scaleW = size.width / _designWidth;
    final scaleH = size.height / _designHeight;
    // Cinsiyet: sayfaya parametreyle geçildiyse onu kullan, yoksa provider'dan oku
    final selectedGender = widget.gender ?? ref.watch(selectedGenderProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 72),
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
                          Navigator.of(context).maybePop();
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 194,
                        height: 24,
                        child: Center(
                          child: Text(
                            'Vücudunuzu Bilin'.tr(),
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
                          '$step/6',
                          style: const TextStyle(
                            fontFamily: AppFont.montserrat,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 1.0,
                            letterSpacing: 0,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(6, (index) {
                          final isActive = index < step;
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: index == 5
                                  ? EdgeInsets.zero
                                  : const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF00EF5B)
                                    : const Color(0xFFD7D7D7),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (step == 1) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hedefinize ne kadar hızlı ulaşmak istiyorsunuz?'.tr(),
                      style: AppTextStyles.questionTitle,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _VucudunuzubilinOptionTile(
                    label: 'Hemen Şimdi'.tr(),
                    index: 0,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 0),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: SvgPicture.asset(
                            'assets/images/icons/Vector (4).svg',
                            width: 8,
                            height: 14,
                            colorFilter: ColorFilter.mode(
                              _selectedIndex == 0
                                  ? const Color(0xFF06C44F)
                                  : const Color(0xFF727775),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: SvgPicture.asset(
                            'assets/images/icons/Vector (4).svg',
                            width: 8,
                            height: 14,
                            colorFilter: ColorFilter.mode(
                              _selectedIndex == 0
                                  ? const Color(0xFF06C44F)
                                  : const Color(0xFF727775),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VucudunuzubilinOptionTile(
                    label: 'Çok Hızlı',
                    index: 1,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 1),
                    leading: SizedBox(
                      width: 19,
                      height: 23,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/Vector (5).svg',
                            width: 19,
                            height: 23,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              _selectedIndex == 1
                                  ? const Color(0xFF06C44F)
                                  : const Color(0xFF727775),
                              BlendMode.srcIn,
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, 1.5),
                            child: SvgPicture.asset(
                              'assets/images/icons/Vector (6).svg',
                              width: 6,
                              height: 9,
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(
                                _selectedIndex == 1
                                    ? const Color(0xFF06C44F)
                                    : const Color(0xFF727775),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VucudunuzubilinOptionTile(
                    label: 'Hızlı & Dengeli',
                    index: 2,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 2),
                    leading: SizedBox(
                      width: 22,
                      height: 23,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/Vector (7).svg',
                          width: 22,
                          height: 16,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 2
                                ? const Color(0xFF06C44F)
                                : const Color(0xFF727775),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VucudunuzubilinOptionTile(
                    label: 'Uzun Vadede',
                    index: 3,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 3),
                    leading: SizedBox(
                      width: 20,
                      height: 23,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/Vector (8).svg',
                            width: 20,
                            height: 22,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              _selectedIndex == 3
                                  ? const Color(0xFF06C44F)
                                  : const Color(0xFF727775),
                              BlendMode.srcIn,
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/images/icons/Vector (9).svg',
                            width: 10,
                            height: 10,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              _selectedIndex == 3
                                  ? const Color(0xFF06C44F)
                                  : const Color(0xFF727775),
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ] else if (step == 2) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Kas yapma ile son deneyimin nasıldı?'.tr(),
                      style: AppTextStyles.questionTitle,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _VucudunuzubilinOptionTile(
                    label: 'Hiç denemedim'.tr(),
                    index: 0,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 0),
                    leading: SizedBox(
                      width: 24,
                      height: 23,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/Vector (10).svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 0
                                ? const Color(0xFF06C44F)
                                : const Color(0xFF727775),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VucudunuzubilinOptionTile(
                    label: 'Denedim ama olmadı'.tr(),
                    index: 1,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 1),
                    leading: SizedBox(
                      width: 24,
                      height: 23,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/Vector (11).svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 1
                                ? const Color(0xFF06C44F)
                                : const Color(0xFF727775),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VucudunuzubilinOptionTile(
                    label: 'Başardım ama tekrar aldım'.tr(),
                    index: 2,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 2),
                    leading: SizedBox(
                      width: 24,
                      height: 23,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/Vector (12).svg',
                          width: 20,
                          height: 21,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 2
                                ? const Color(0xFF06C44F)
                                : const Color(0xFF727775),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VucudunuzubilinOptionTile(
                    label: 'Hala deniyorum',
                    index: 3,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 3),
                    leading: SizedBox(
                      width: 24,
                      height: 23,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/Vector (13).svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 3
                                ? const Color(0xFF06C44F)
                                : const Color(0xFF727775),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VucudunuzubilinOptionTile(
                    label: 'Başardım ve daha iyisini istiyorum'.tr(),
                    index: 4,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 4),
                    leading: SizedBox(
                      width: 24,
                      height: 23,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/iconstack.io - (Smile Plus).svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 4
                                ? const Color(0xFF06C44F)
                                : const Color(0xFF727775),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ] else if (step == 3) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tercih ettiğiniz antrenman tipi?'.tr(),
                      style: AppTextStyles.questionTitle,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _VucudunuzubilinOptionTile(
                    label: 'Başlaması Kolay'.tr(),
                    index: 0,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 0),
                    leading: SizedBox(
                      width: 24,
                      height: 23,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/iconstack.io - (Mood Smile).svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 0
                                ? const Color(0xFF06C44F)
                                : const Color(0xFF727775),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VucudunuzubilinOptionTile(
                    label: 'Terli',
                    index: 1,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 1),
                    leading: SizedBox(
                      width: 24,
                      height: 23,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/Vector (14).svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 1
                                ? const Color(0xFF06C44F)
                                : const Color(0xFF727775),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VucudunuzubilinOptionTile(
                    label: 'Zorlu',
                    index: 2,
                    selectedIndex: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = 2),
                    leading: SizedBox(
                      width: 24,
                      height: 23,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/Vector (15).svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 2
                                ? const Color(0xFF06C44F)
                                : const Color(0xFF727775),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ] else if (step == 4) ...[
                  // --- Aktivite düzeyiniz nedir? (Vücudunuzu Bilin, adım 4) ---
                  // Görsel: Hedef & Odak'ta seçilen cinsiyete göre (kadın/erkek aktivite klasörü)
                  // Slider Hareketsiz→Hareketli: 4 fotoğraf sırayla değişir
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Aktivite düzeyiniz nedir?'.tr(),
                      style: AppTextStyles.questionTitle,
                    ),
                  ),
                  SizedBox(height: 54 * scaleH),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24.22 * scaleW),
                          child: _buildActivityLevelImage(scaleW, scaleH, selectedGender),
                        ),
                        Transform.rotate(
                          angle: 48 * 3.14159265359 / 180,
                          child: Container(
                            width: 230.18860239322538 * scaleW,
                            height: 230.18860239322538 * scaleH,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.22 * scaleW),
                              border: Border.all(
                                color: const Color(0xFF8C8C8C),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32 * scaleH),
                  _ActivityLevelSlider(
                    value: _activityLevelIndex,
                    onChanged: (v) => setState(() => _activityLevelIndex = v),
                  ),
                  ] else if (step == 5) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Haftanın hangi günleri antrenman yaparsınız?'.tr(),
                      style: AppTextStyles.questionTitle,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _DayTile(
                    label: 'Pazartesi',
                    index: 0,
                    isSelected: _selectedDays.contains(0),
                    onTap: () => setState(() {
                      if (_selectedDays.contains(0)) {
                        _selectedDays.remove(0);
                      } else {
                        _selectedDays.add(0);
                      }
                    }),
                    iconAsset: 'assets/images/icons/iconstack.io - (Workout Gymnastics).svg',
                  ),
                  const SizedBox(height: 12),
                  _DayTile(
                    label: 'Salı',
                    index: 1,
                    isSelected: _selectedDays.contains(1),
                    onTap: () => setState(() {
                      if (_selectedDays.contains(1)) {
                        _selectedDays.remove(1);
                      } else {
                        _selectedDays.add(1);
                      }
                    }),
                    iconAsset: 'assets/images/icons/iconstack.io - (Workout Kicking).svg',
                  ),
                  const SizedBox(height: 12),
                  _DayTile(
                    label: 'Çarşamba',
                    index: 2,
                    isSelected: _selectedDays.contains(2),
                    onTap: () => setState(() {
                      if (_selectedDays.contains(2)) {
                        _selectedDays.remove(2);
                      } else {
                        _selectedDays.add(2);
                      }
                    }),
                    iconAsset: 'assets/images/icons/iconstack.io - (Workout Run).svg',
                  ),
                  const SizedBox(height: 12),
                  _DayTile(
                    label: 'Perşembe',
                    index: 3,
                    isSelected: _selectedDays.contains(3),
                    onTap: () => setState(() {
                      if (_selectedDays.contains(3)) {
                        _selectedDays.remove(3);
                      } else {
                        _selectedDays.add(3);
                      }
                    }),
                    iconAsset: 'assets/images/icons/iconstack.io - (Workout Squats).svg',
                  ),
                  const SizedBox(height: 12),
                  _DayTile(
                    label: 'Cuma',
                    index: 4,
                    isSelected: _selectedDays.contains(4),
                    onTap: () => setState(() {
                      if (_selectedDays.contains(4)) {
                        _selectedDays.remove(4);
                      } else {
                        _selectedDays.add(4);
                      }
                    }),
                    iconAsset: 'assets/images/icons/iconstack.io - (Workout Stretching).svg',
                  ),
                  const SizedBox(height: 12),
                  _DayTile(
                    label: 'Cumartesi',
                    index: 5,
                    isSelected: _selectedDays.contains(5),
                    onTap: () => setState(() {
                      if (_selectedDays.contains(5)) {
                        _selectedDays.remove(5);
                      } else {
                        _selectedDays.add(5);
                      }
                    }),
                    iconAsset: 'assets/images/icons/iconstack.io - (Workout Warm Up).svg',
                  ),
                  const SizedBox(height: 12),
                  _DayTile(
                    label: 'Pazar',
                    index: 6,
                    isSelected: _selectedDays.contains(6),
                    onTap: () => setState(() {
                      if (_selectedDays.contains(6)) {
                        _selectedDays.remove(6);
                      } else {
                        _selectedDays.add(6);
                      }
                    }),
                    iconAsset: 'assets/images/icons/iconstack.io - (Workout Battle Ropes).svg',
                  ),
                  ] else if (step == 6) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Antrenman süren ne kadar?'.tr(),
                      style: AppTextStyles.questionTitle,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _DurationTile(
                    label: '10 - 20 Dakika',
                    index: 0,
                    isSelected: _trainingDurationIndex == 0,
                    onTap: () => setState(() => _trainingDurationIndex = 0),
                    iconAsset: 'assets/images/icons/iconstack.io - (Alarm Plus).svg',
                  ),
                  const SizedBox(height: 12),
                  _DurationTile(
                    label: '25 - 30 Dakika',
                    index: 1,
                    isSelected: _trainingDurationIndex == 1,
                    onTap: () => setState(() => _trainingDurationIndex = 1),
                    iconAsset: 'assets/images/icons/iconstack.io - (Bike).svg',
                  ),
                  const SizedBox(height: 12),
                  _DurationTile(
                    label: '40 - 45 Dakika',
                    index: 2,
                    isSelected: _trainingDurationIndex == 2,
                    onTap: () => setState(() => _trainingDurationIndex = 2),
                    iconAsset: 'assets/images/icons/iconstack.io - (Bomb).svg',
                  ),
                  const SizedBox(height: 12),
                  _DurationTile(
                    label: '60+ Dakika',
                    index: 3,
                    isSelected: _trainingDurationIndex == 3,
                    onTap: () => setState(() => _trainingDurationIndex = 3),
                    iconAsset: 'assets/images/icons/iconstack.io - (Bulb).svg',
                  ),
                  ],
                ],
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 16,
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
                    if (step == 1) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const VucudunuzubilinQuestionView(step: 2),
                        ),
                      );
                    } else if (step == 2) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const VucudunuzubilinQuestionView(step: 3),
                        ),
                      );
                    } else if (step == 3) {
                      final gender = ref.read(selectedGenderProvider);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VucudunuzubilinQuestionView(step: 4, gender: gender),
                        ),
                      );
                    } else if (step == 4) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const VucudunuzubilinQuestionView(step: 5),
                        ),
                      );
                    } else if (step == 5) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const VucudunuzubilinQuestionView(step: 6),
                        ),
                      );
                    } else if (step == 6) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const HazirmisinView(),
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
                            step == 6 ? 'Başlayın' : 'Sonraki',
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

class _ActivityLevelSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _ActivityLevelSlider({
    required this.value,
    required this.onChanged,
  });

  static const int _dotCount = 4;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.clamp(0, _dotCount - 1);
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
                children: List.generate(_dotCount, (i) {
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
              'Hareketsiz',
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
              'Hareketli',
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

class _DurationTile extends StatelessWidget {
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final String iconAsset;

  const _DurationTile({
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFF06C44F) : const Color(0xFF727775);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF00EF5B) : const Color(0xFFD7D7D7),
            width: 1,
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                iconAsset,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: Color(0xFF100F0F),
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

class _DayTile extends StatelessWidget {
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final String iconAsset;

  const _DayTile({
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFF06C44F) : const Color(0xFF727775);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF00EF5B) : const Color(0xFFD7D7D7),
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                iconAsset,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: Color(0xFF100F0F),
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

class _VucudunuzubilinOptionTile extends StatelessWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;
  final Widget? leading;

  const _VucudunuzubilinOptionTile({
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00EF5B)
                : const Color(0xFFD7D7D7),
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: const Color(0xFF000000),
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
