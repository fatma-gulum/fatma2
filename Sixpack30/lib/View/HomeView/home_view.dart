import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sixpack30/Colors/app_colors.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/View/FaqView/faq_view.dart';
import 'package:sixpack30/View/ShareAppView/share_app_view.dart';
import 'package:sixpack30/View/LoginView/login_view.dart';
import 'package:sixpack30/View/WorkoutProgramView/workout_program_view.dart';
import 'package:sixpack30/View/VucutOzellikleriView/height_ruler.dart';
import 'package:sixpack30/View/VucutOzellikleriView/weight_ruler.dart';
import 'package:sixpack30/core/constants/body_measure_constants.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedDayIndex = 1; // varsayılan seçili gün (örnekteki yeşil gün)
  late int _selectedTabIndex;
  final double _todayWorkoutProgress = 0.86; // bugünkü antrenman tamamlanma oranı (0-1)
  bool _notificationsEnabled = true;
  bool _healthAppConnected = true;
  bool _isEditingProfile = false;
  bool _isNotificationsView = false;
  bool _isLanguagePreferencesView = false;
  bool _isRateUsView = false;
  int _selectedRating = 4;
  int _selectedLanguageIndex = 0;
  String _selectedBodyType = 'Normal';
  final GlobalKey _bodyTypeFieldKey = GlobalKey();
  int _selectedAge = 26;
  int _selectedHeightCm = 170;
  int _selectedWeightKg = 70;
  final Set<int> _selectedStreakDays = {};
  int _adimHedefIndex = 1; // Günlük 10 bin
  double _suIcSliderValue = 0.2; // 1 of 5 glasses
  double _suIcThumbPosition = 11.0; // çubuk üzerinde thumb (0..118), başlangıç left 19px karttan
  late final Future<String> _suIcGlassesSvgFuture =
      rootBundle.loadString('assets/images/icons/Frame 7162.svg');

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
  }

  /// Thumb konumuna göre vurgulanacak bardak indeksi (0..4).
  int _suIcActiveGlassIndex() {
    final center = _suIcThumbPosition + 5.0;
    return (center / 128.0 * 5.0).floor().clamp(0, 4);
  }

  /// Frame 7162 SVG string'inde bardak renklerini günceller.
  /// 0..activeIndex (dahil) bardaklar mavi, geri kalanlar gri (arttıkça artan dolum).
  String _suIcGlassesSvgWithActive(String svg, int activeIndex) {
    const activeColor = '#27BEEA';
    const inactiveColor = '#BBBBBB';
    final lines = svg.split('\n');
    final result = <String>[];
    int pathIndex = 0;
    for (final line in lines) {
      if (line.contains('<path ')) {
        final glassIndex = pathIndex ~/ 2;
        pathIndex++;
        final color = glassIndex <= activeIndex ? activeColor : inactiveColor;
        result.add(line
            .replaceAll(RegExp(r'fill="#[A-Fa-f0-9]+"'), 'fill="$color"')
            .replaceAll(RegExp(r'stroke="#[A-Fa-f0-9]+"'), 'stroke="$color"'));
      } else {
        result.add(line);
      }
    }
    return result.join('\n');
  }

  final List<_DayItem> _days = const [
    _DayItem(day: '22', label: 'P'),
    _DayItem(day: '23', label: 'S'),
    _DayItem(day: '24', label: 'Ç'),
    _DayItem(day: '25', label: 'P'),
    _DayItem(day: '26', label: 'C'),
    _DayItem(day: '27', label: 'C'),
    _DayItem(day: '28', label: 'P'),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Ana sayfadan onboarding/loading ekranlarına geri dönmeyi engelle.
        // İçeride bir alt ekran/sekme açıksa önce onu kapat.
        if (_selectedTabIndex != 0) {
          setState(() => _selectedTabIndex = 0);
          return false;
        }
        if (_isEditingProfile || _isNotificationsView || _isLanguagePreferencesView || _isRateUsView) {
          setState(() {
            _isEditingProfile = false;
            _isNotificationsView = false;
            _isLanguagePreferencesView = false;
            _isRateUsView = false;
          });
          return false;
        }
        return false; // Home'dan geri çıkma
      },
      child: Scaffold(
        backgroundColor: _selectedTabIndex == 3
            ? const Color(0xFFFEFEFE)
            : const Color(0xFFFFFFFF),
        body: _selectedTabIndex == 1
            ? WorkoutProgramView(
                onBack: () => setState(() => _selectedTabIndex = 0),
              )
            : Center(
                child: Container(
                  width: _selectedTabIndex == 3 ? 390 : null,
                  constraints: BoxConstraints(
                    maxWidth: 390,
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 3
                        ? const Color(0xFFFEFEFE)
                        : const Color(0xFFFFFFFF),
                  ),
                  child: SafeArea(
                    child: _selectedTabIndex == 3
                        ? SizedBox(
                            width: 390,
                            child: _isEditingProfile
                                ? _buildEditProfileView()
                                : _isNotificationsView
                                    ? _buildNotificationsView()
                                    : _isLanguagePreferencesView
                                        ? _buildLanguagePreferencesView()
                                        : _isRateUsView
                                            ? _buildRateUsView()
                                            : _buildProfileView(),
                          )
                        : _selectedTabIndex == 2
                            ? _buildProgressView()
                            : Column(
                                children: [
                                  _buildHeader(),
                                  const SizedBox(height: 8),
                                  _buildCalendar(),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Günün Antrenmanı',
                                            style: TextStyle(
                                              fontFamily: AppFont.montserrat,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              height: 1.0,
                                              letterSpacing: -0.011,
                                              color: const Color(0xFF000000),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          _buildTodayWorkoutCard(),
                                          const SizedBox(height: 24),
                                          _buildContinueSection(),
                                          const SizedBox(height: 24),
                                          _buildTodayTrainingProgressCard(),
                                          const SizedBox(height: 24),
                                          _buildCompletedDaysSection(),
                                          const SizedBox(height: 16),
                                          _buildPremiumSection(),
                                          const SizedBox(height: 16),
                                          _buildProgressSection(),
                                          const SizedBox(height: 16),
                                          _buildStatsSection(
                                            includePerformanceProgressBlock: false,
                                            includeBigCards: false,
                                            includeSmallCards: false,
                                          ),
                                          const SizedBox(height: 24),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ),
              ),
        bottomNavigationBar: _selectedTabIndex == 3 &&
                (_isEditingProfile ||
                    _isNotificationsView ||
                    _isLanguagePreferencesView ||
                    _isRateUsView)
            ? null
            : _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: SizedBox(
                  width: 25,
                  height: 24,
                  child: SvgPicture.asset(
                    'assets/images/icons/Frame 6952.svg',
                    width: 25,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
                onPressed: () => setState(() => _selectedTabIndex = 0),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 25, minHeight: 24),
                style: IconButton.styleFrom(
                  minimumSize: const Size(25, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 311,
                  height: 30,
                  child: Center(
                    child: Text(
                      'Profil'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 1.5,
                        letterSpacing: -0.22,
                        color: const Color(0xFF0D0D0D),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFD9D9D9),
                backgroundImage: const AssetImage('assets/images/resimler/Ellipse 68.jpg'),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 107,
                height: 30,
                child: Text(
                  'Sinem Bakır',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    height: 1.5,
                    letterSpacing: -0.22,
                    color: const Color(0xFF0D0D0D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 342,
            height: 30,
            child: Text(
              'Hesap Ayarları'.tr(),
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                height: 1.5,
                letterSpacing: -0.22,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildProfileCard(
            height: 180,
            children: [
              _buildProfileRow(
                Icons.person_outline,
                'Profili Düzenle'.tr(),
                leadingSvgAsset: _profileEditIcon,
                trailingSvgAsset: _profileArrowIcon,
                darkTextStyle: true,
                onTap: () => setState(() {
                  _isEditingProfile = true;
                }),
              ),
              _buildProfileDivider(),
              _buildProfileRow(
                Icons.notifications_outlined,
                'Bildirimler'.tr(),
                leadingSvgAsset: _profileNotificationsIcon,
                trailingSvgAsset: _profileArrowIcon,
                darkTextStyle: true,
                onTap: () => setState(() {
                  _isNotificationsView = true;
                }),
              ),
              _buildProfileDivider(),
              _buildProfileRow(Icons.workspace_premium_outlined, 'Premium'.tr(), leadingSvgAsset: _profilePremiumIcon, trailingSvgAsset: _profileArrowIcon, darkTextStyle: true),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 342,
            height: 30,
            child: Text(
              'Destek & Diğer'.tr(),
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                height: 1.5,
                letterSpacing: -0.22,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildProfileCard(
            children: [
              _buildProfileRow(
                Icons.favorite_outline,
                'App Sağlık ile Bağlan'.tr(),
                leadingSvgAsset: _profileHealthAppIcon,
                isSwitch: true,
                darkTextStyle: true,
                switchValue: _healthAppConnected,
                switchOnChanged: (v) => setState(() => _healthAppConnected = v),
              ),
              _buildProfileDivider(),
              _buildProfileRow(
                Icons.language,
                'Dil Tercihleri'.tr(),
                leadingSvgAsset: _profileLanguageIcon,
                trailingSvgAsset: _profileArrowIcon,
                darkTextStyle: true,
                onTap: () => setState(() {
                  _isLanguagePreferencesView = true;
                }),
              ),
              _buildProfileDivider(),
              _buildProfileRow(
                Icons.help_outline,
                'Sıkça Sorulan Sorular'.tr(),
                leadingSvgAsset: _profileFaqIcon,
                trailingSvgAsset: _profileArrowIcon,
                darkTextStyle: true,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FaqView(),
                  ),
                ),
              ),
              _buildProfileDivider(),
              _buildProfileRow(
                Icons.star_outline,
                'Bizi Değerlendir'.tr(),
                leadingSvgAsset: _profileRateUsIcon,
                trailingSvgAsset: _profileArrowIcon,
                darkTextStyle: true,
                onTap: () => setState(() {
                  _isRateUsView = true;
                }),
              ),
              _buildProfileDivider(),
              _buildProfileRow(
                Icons.share_outlined,
                'Uygulamayı Paylaş'.tr(),
                leadingSvgAsset: _profileShareAppIcon,
                trailingSvgAsset: _profileArrowIcon,
                darkTextStyle: true,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ShareAppView(),
                  ),
                ),
              ),
              _buildProfileDivider(),
              _buildProfileRow(
                Icons.logout,
                'Çıkış Yap'.tr(),
                isLogout: true,
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProgressView() {
    return SizedBox(
      width: 390,
      child: Container(
        width: 390,
        height: 1666,
        color: const Color(0xFFFFFFFF),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: SizedBox(
                      width: 25,
                      height: 24,
                      child: SvgPicture.asset(
                        'assets/images/icons/Frame 6952.svg',
                        width: 25,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                    onPressed: () => setState(() {
                      _selectedTabIndex = 0;
                    }),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 25, minHeight: 24),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(25, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: Center(
                        child: Text(
                          'İlerleme'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFont.montserrat,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            height: 1.5,
                            letterSpacing: -0.22,
                            color: const Color(0xFF0D0D0D),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 16),
              // Günün Antrenmanı başlığı ve kartı
              Text(
                'Günün Antrenmanı'.tr(),
                style: TextStyle(
                  fontFamily: AppFont.montserrat,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: const Color(0xFF0D0D0D),
                ),
              ),
              const SizedBox(height: 12),
              _buildTodayWorkoutCard(),
              const SizedBox(height: 16),
              _buildStreakCard(),
              const SizedBox(height: 24),
              // Antrenman özeti
              SizedBox(
                width: 342,
                height: 20,
                child: Text(
                  'Antrenman Özeti'.tr(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.0,
                    letterSpacing: -0.011,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildTodayProgressSummary(),
              const SizedBox(height: 24),
              // Performans & İlerleme
              SizedBox(
                width: 342,
                height: 20,
                child: Text(
                  'Performans & İlerleme'.tr(),
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.0,
                    letterSpacing: -0.011,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildStatsSection(),
              const SizedBox(height: 24),
              _buildAdimSuIcSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static const List<String> _adimHedefOptions = [
    'Günlük 6 bin',
    'Günlük 10 bin',
    'Haftada 40 bin',
    'Haftada 90 bin',
  ];

  Widget _buildAdimSuIcSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAdimCard(),
          const SizedBox(width: 13),
          _buildSuIcCard(),
        ],
      ),
    );
  }

  void _showAdimHedefMenu(BuildContext context, RenderBox button) {
    final position = button.localToGlobal(Offset.zero);
    final size = button.size;
    final left = position.dx;
    final top = position.dy + size.height;
    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 85, top + 82),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Color(0x1CEBEBEB), width: 1),
      ),
      color: const Color(0xFFECECEC),
      elevation: 0,
      items: List.generate(4, (i) => PopupMenuItem<int>(
        value: i,
        height: 20,
        child: SizedBox(
          width: 85 - 16,
          child: Text(
            _adimHedefOptions[i],
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              color: Color(0xFF000000),
            ),
          ),
        ),
      )),
    ).then((v) {
      if (v != null) setState(() => _adimHedefIndex = v);
    });
  }

  Widget _buildAdimCard() {
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: const Color(0xFFECECEC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Color(0x1CEBEBEB), width: 1),
          ),
          elevation: 0,
        ),
      ),
      child: Container(
        width: 164,
        height: 95,
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFEFE),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
        ),
        child: ClipRect(
          child: SizedBox(
            height: 79,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 88,
                  height: 17,
                  child: Text(
                    'Adım'.tr(),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.0,
                      letterSpacing: 14 * -0.011,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: SvgPicture.asset(
                        'assets/images/icons/Frame 7118 (2).svg',
                        width: 44,
                        height: 44,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _adimHedefIndex,
                                isExpanded: true,
                                isDense: true,
                                icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 9,
                                  color: const Color(0xFF000000),
                                ),
                                items: List.generate(4, (i) => DropdownMenuItem(value: i, child: Text(_adimHedefOptions[i]))),
                                onChanged: (v) => setState(() => _adimHedefIndex = v ?? 0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Builder(
                            builder: (ctx) {
                              return SizedBox(
                                width: 85,
                                height: 20,
                                child: TextButton(
                                  onPressed: () {
                                    final box = ctx.findRenderObject() as RenderBox?;
                                    if (box != null && box.hasSize) _showAdimHedefMenu(ctx, box);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF000000),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    minimumSize: Size.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    'Hedef seç'.tr(),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    ),
    );
  }

  Widget _buildSuIcCard() {
    return Container(
      width: 164,
      height: 95,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
      ),
      child: ClipRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 88,
              height: 17,
              child: Text(
                'Su iç'.tr(),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.0,
                  letterSpacing: 14 * -0.011,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: 127,
              height: 19,
              child: FutureBuilder<String>(
                future: _suIcGlassesSvgFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SvgPicture.asset(
                      'assets/images/icons/Frame 7162.svg',
                      width: 127,
                      height: 19,
                      fit: BoxFit.contain,
                    );
                  }
                  return SvgPicture.string(
                    _suIcGlassesSvgWithActive(
                      snapshot.data!,
                      _suIcActiveGlassIndex(),
                    ),
                    width: 127,
                    height: 19,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: 128,
              height: 10,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 128,
                        height: 4,
                        child: SvgPicture.asset(
                          'assets/images/icons/Frame 7163.svg',
                          width: 128,
                          height: 4,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: _suIcThumbPosition.clamp(0.0, 118.0),
                    top: 0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _suIcThumbPosition =
                              (_suIcThumbPosition + details.delta.dx).clamp(0.0, 118.0);
                        });
                      },
                      child: SvgPicture.asset(
                        'assets/images/icons/Ellipse 82.svg',
                        width: 10,
                        height: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      width: 342,
      decoration: BoxDecoration(
        color: const Color(0x3BF1F1F1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFEBEBEB),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üstte, border içine düzgün oturan başlık
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Harika Gidiyorsun 🎉'.tr(),
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w500,
                fontSize: 10,
                height: 1.0,
                letterSpacing: -0.011,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.2, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 71,
                  height: 41.45,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/icons/Frame 7167.svg',
                      width: 48,
                      height: 41.45,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 5.82),
                SizedBox(
                  width: 71,
                  height: 24,
                  child: Text(
                    '3',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      height: 1.0,
                      letterSpacing: -0.011,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 71,
                  height: 12,
                  child: Text(
                    'Günlük Seri'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      height: 1.0,
                      letterSpacing: -0.011,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStreakDay(index: 0, label: 'P', isStaticDone: true),
              _buildStreakDay(index: 1, label: 'S', isStaticDone: true),
              _buildStreakDay(index: 2, label: 'Ç', isStaticDone: true),
              _buildStreakDay(index: 3, label: 'P', dayNumber: '26'),
              _buildStreakDay(index: 4, label: 'C', dayNumber: '27'),
              _buildStreakDay(index: 5, label: 'C', dayNumber: '28'),
              _buildStreakDay(index: 6, label: 'P', dayNumber: '29'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakDay({
    required int index,
    required String label,
    bool isStaticDone = false,
    String? dayNumber,
  }) {
    final bool isSelected = _selectedStreakDays.contains(index) || isStaticDone;
    return GestureDetector(
      onTap: isStaticDone
          ? null
          : () {
              setState(() {
                if (_selectedStreakDays.contains(index)) {
                  _selectedStreakDays.remove(index);
                } else {
                  _selectedStreakDays.add(index);
                }
              });
            },
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.0,
              letterSpacing: -0.011,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color:
                  isSelected ? const Color(0xFF06C44F) : const Color(0x1A06C44F),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    )
                  : Text(
                      dayNumber ?? '',
                      style: const TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.0,
                        letterSpacing: -0.011,
                        color: Color(0xFF06C44F),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard({double? height, required List<Widget> children}) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
    return Container(
      width: 342,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: const Color(0xFFF3F3F3)),
      ),
      child: height != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SingleChildScrollView(
                child: content,
              ),
            )
          : content,
    );
  }

  static const String _profileArrowIcon = 'assets/images/icons/iconstack.io - (Round Alt Arrow Right).svg';

  static const String _profileEditIcon = 'assets/images/icons/Frame 6637 (1).svg';
  static const String _profileNotificationsIcon = 'assets/images/icons/Frame 6637 (2).svg';
  static const String _profilePremiumIcon = 'assets/images/icons/Frame 6637 (3).svg';
  static const String _profileHealthAppIcon = 'assets/images/icons/Frame 6637 (4).svg';
  static const String _profileLanguageIcon = 'assets/images/icons/Frame 6637 (5).svg';
  static const String _profileFaqIcon = 'assets/images/icons/Frame 6637 (6).svg';
  static const String _profileRateUsIcon = 'assets/images/icons/Frame 6637 (7).svg';
  static const String _profileShareAppIcon = 'assets/images/icons/Frame 6637 (8).svg';

  Widget _buildEditProfileView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: SizedBox(
                        width: 25,
                        height: 24,
                        child: SvgPicture.asset(
                          'assets/images/icons/Frame 6952.svg',
                          width: 25,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () => setState(() {
                        _isEditingProfile = false;
                      }),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 25, minHeight: 24),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(25, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 311,
                        height: 30,
                        child: Center(
                          child: Text(
                            'Profili Düzenle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              height: 1.5,
                              letterSpacing: -0.22,
                              color: const Color(0xFF0D0D0D),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                      height: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFD9D9D9),
                      backgroundImage:
                          AssetImage('assets/images/resimler/Ellipse 68.jpg'),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 150,
                      height: 30,
                      child: Text(
                        'Sinem Bakır',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1.5,
                          letterSpacing: -0.22,
                          color: const Color(0xFF0D0D0D),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildLabeledTextField(
                  label: 'Adınız',
                  initialValue: 'Sinem Bakır',
                  isNameField: true,
                ),
                const SizedBox(height: 16),
                _buildLabeledDropdown(
                  label: 'Vücut Tipiniz',
                  value: _selectedBodyType,
                  items: const ['Zayıf', 'Normal', 'Kilolu', 'Çok kilolu'],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedBodyType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildLabeledTextField(
                  label: 'Yaşınız',
                  isAgeField: true,
                ),
                const SizedBox(height: 16),
                _buildLabeledTextField(
                  label: 'Boyunuz',
                  initialValue: '1.65',
                  keyboardType: TextInputType.number,
                  isHeightField: true,
                ),
                const SizedBox(height: 16),
                _buildLabeledTextField(
                  label: 'Kilonuz',
                  initialValue: '52',
                  keyboardType: TextInputType.number,
                  isWeightField: true,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 342,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00EF5B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Değişiklikleri Kaydet',
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 342,
                height: 20,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF000000),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(342, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Hesabı Sil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.0,
                      letterSpacing: -0.011,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: SizedBox(
                        width: 25,
                        height: 24,
                        child: SvgPicture.asset(
                          'assets/images/icons/Frame 6952.svg',
                          width: 25,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () => setState(() {
                        _isNotificationsView = false;
                      }),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 25, minHeight: 24),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(25, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 294,
                        height: 30,
                        child: Center(
                          child: Text(
                            'Bildirimler',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              height: 1.5,
                              letterSpacing: -0.22,
                              color: const Color(0xFF0D0D0D),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: SizedBox(
                        width: 25,
                        height: 24,
                        child: SvgPicture.asset(
                          'assets/images/icons/iconstack.io - (Ellipsis Vertical Outline).svg',
                          width: 25,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () {
                        // TODO: bildirim menüsü (ör. tümünü sil, ayarlar)
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 25, minHeight: 24),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(25, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // "Bugün" başlığı ve Tümünü sil
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 22,
                        child: Text(
                          'Bugün',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 1.0,
                            letterSpacing: -0.011,
                            color: const Color(0xFF0D0D0D),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 88,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0x4DDEDEDE), // #DEDEDE4D
                          width: 1,
                        ),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          foregroundColor: const Color(0xFFE92525),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
                        child: SizedBox(
                          width: 67,
                          height: 15,
                          child: Center(
                            child: Text(
                              'Tümünü sil',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFont.montserrat,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 1.0,
                                letterSpacing: -0.011,
                                color: const Color(0xFFE92525),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  title: 'Spor saatin geldi',
                  subtitle:
                      'Bugün antrenman günün 💪 Hedefine bir adım daha yaklaşma zamanı.',
                  time: '12:00',
                  showDelete: true,
                ),
                const SizedBox(height: 14),
                _buildNotificationCard(
                  title: 'Son 2 set',
                  subtitle:
                      'Şimdiye kadar harikasın. Devam et! Yanma hissi = gelişim.',
                  time: '2 saat önce',
                  showDelete: true,
                  iconPath: 'assets/images/icons/Frame 6802 (1).svg',
                ),
                const SizedBox(height: 14),
                _buildNotificationCard(
                  title: 'İlerleme',
                  subtitle:
                      '5 gündür üst üste aktif! Kendinle gurur duyma zamanı.',
                  time: '6 saat önce',
                  showDelete: true,
                  iconPath: 'assets/images/icons/Frame 6802 (2).svg',
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: 342,
                  height: 22,
                  child: Text(
                    'Dün',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.0,
                      letterSpacing: -0.011,
                      color: const Color(0xFF0D0D0D),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  title: 'Harekete Geç',
                  subtitle:
                      '10 dakika bile yeter. Başla. Bugün kendin için bir şey yap.',
                  time: '1 gün önce',
                  showDelete: true,
                  iconPath: 'assets/images/icons/Frame 6802 (3).svg',
                ),
                const SizedBox(height: 14),
                _buildNotificationCard(
                  title: 'Bugünün Görevleri Tamamlandı',
                  subtitle:
                      'Günün tüm sorumluluklarını tamamladın, şimdi dinlenme zamanı.',
                  time: '1 gün önce',
                  showDelete: true,
                  iconPath: 'assets/images/icons/Frame 6802 (4).svg',
                ),
                const SizedBox(height: 14),
                _buildNotificationCard(
                  title: 'Motivasyon',
                  subtitle:
                      'Ertelemek mi, başlamak mı? Seçim senin. Güç, konfor alanının dışında.',
                  time: '1 gün önce',
                  showDelete: true,
                  iconPath: 'assets/images/icons/Frame 6697.svg',
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static const List<Map<String, dynamic>> _languageOptions = [
    {'flag': '🇺🇸', 'name': 'English', 'locale': Locale('en', 'US')},
    {'flag': '🇹🇷', 'name': 'Türkçe', 'locale': Locale('tr', 'TR')},
    {'flag': '🇪🇸', 'name': 'Español', 'locale': Locale('es', 'ES')},
    {'flag': '🇵🇹', 'name': 'Português', 'locale': Locale('pt', 'PT')},
    {'flag': '🇫🇷', 'name': 'Français', 'locale': Locale('fr', 'FR')},
    {'flag': '🇮🇹', 'name': 'Italiano', 'locale': Locale('it', 'IT')},
    {'flag': '🇩🇪', 'name': 'Deutsch', 'locale': Locale('de', 'DE')},
    {'flag': '🇷🇺', 'name': 'Русский', 'locale': Locale('ru', 'RU')},
    {'flag': '🇯🇵', 'name': '日本語', 'locale': Locale('ja', 'JP')},
    {'flag': '🇰🇷', 'name': '한국어', 'locale': Locale('ko', 'KR')},
    {'flag': '🇮🇳', 'name': 'हिन्दी', 'locale': Locale('hi', 'IN')},
  ];

  Widget _buildRateUsView() {
    return Container(
      width: 390,
      height: 894,
      color: const Color(0xFFFEFEFE),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                IconButton(
                  icon: SizedBox(
                    width: 25,
                    height: 24,
                    child: SvgPicture.asset(
                      'assets/images/icons/Frame 6952.svg',
                      width: 25,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                  onPressed: () => setState(() {
                    _isRateUsView = false;
                  }),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 25, minHeight: 24),
                  style: IconButton.styleFrom(
                    minimumSize: const Size(25, 24),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 311,
                    height: 30,
                    child: Center(
                      child: Text(
                        'Uygulamayı Puanla',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFont.montserrat,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          height: 1.5,
                          letterSpacing: -0.22,
                          color: const Color(0xFF0D0D0D),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 25,
                  height: 24,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 145,
                    height: 39,
                    child: Text(
                      'SixPack30',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 28.64,
                        height: 1.0,
                        letterSpacing: 0,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 228,
                    height: 244,
                    child: Stack(
                      children: [
                        // Back frame (açık yeşil, resmin üstünde hafif taşmış)
                        Positioned(
                          top: 0,
                          left: 16,
                          child: Container(
                            width: 200,
                            height: 221,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDFCF3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        // Middle frame (daha koyu yeşil, resmin üstünde)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            width: 200,
                            height: 221,
                            decoration: BoxDecoration(
                              color: const Color(0xFFCFEBDA),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        // Foreground image (biraz aşağıda, üstünden çerçeveler taşıyor)
                        Positioned(
                          top: 16,
                          left: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Image.asset(
                              'assets/images/resimler/bizidegerlendir.jpg',
                              width: 200,
                              height: 221,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 320,
                    height: 24,
                    child: Text(
                      'SixPack30’ u Beğendin mi?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        height: 1.0,
                        letterSpacing: 0,
                        color: const Color(0xFF0D0D0D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 320,
                    height: 20,
                    child: Text(
                      'Görüşleriniz bizim için çok değerli',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.0,
                        letterSpacing: 0,
                        color: const Color(0xFF4E4949),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 260,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final ratingValue = index + 1;
                        final isSelected = ratingValue <= _selectedRating;
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedRating = ratingValue;
                            });
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(),
                          iconSize: 38.47,
                          icon: SizedBox(
                            width: 38.48,
                            height: 37.12,
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                isSelected
                                    ? const Color(0xFF06C44F)
                                    : const Color(0xFFC9C9C9),
                                BlendMode.srcIn,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/icons/iconstack.io - (Star Fill).svg',
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 320,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00EF5B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: SizedBox(
                    width: 240,
                    height: 20,
                    child: Center(
                      child: Text(
                        'Gönder',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFont.montserrat,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.0,
                          letterSpacing: -0.011,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagePreferencesView() {
    return Container(
      width: 390,
      color: const Color(0xFFFEFEFE),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                IconButton(
                  icon: SizedBox(
                    width: 25,
                    height: 24,
                    child: SvgPicture.asset(
                      'assets/images/icons/Frame 6952.svg',
                      width: 25,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                  onPressed: () => setState(() {
                    _isLanguagePreferencesView = false;
                  }),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 25, minHeight: 24),
                  style: IconButton.styleFrom(
                    minimumSize: const Size(25, 24),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 311,
                    height: 30,
                    child: Center(
                      child: Text(
                        'Dil Tercihleri'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFont.montserrat,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          height: 1.5,
                          letterSpacing: -0.22,
                          color: const Color(0xFF0D0D0D),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 25,
                  height: 24,
                ),
              ],
            ),
          ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          ...List.generate(_languageOptions.length, (index) {
                            final lang = _languageOptions[index];
                            final isSelected = index == _selectedLanguageIndex;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Material(
                                color: const Color(0xFFFEFEFE),
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () => setState(() {
                                    _selectedLanguageIndex = index;
                                  }),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 342,
                                    height: 48,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEFEFE),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: isSelected
                                            ? const Color(0x9E4E4949)
                                            : const Color(0xFFDDDDDD),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          lang['flag'] as String,
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            lang['name'] as String,
                                            style: TextStyle(
                                              fontFamily: AppFont.montserrat,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              height: 1.5,
                                              letterSpacing: -0.22,
                                              color: const Color(0xFF000000),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: SizedBox(
              width: 342,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final selected = _languageOptions[_selectedLanguageIndex];
                  final locale = selected['locale'] as Locale;
                  await context.setLocale(locale);
                  if (mounted) {
                    setState(() {
                      _isLanguagePreferencesView = false;
                    });
                  }
                },
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    'assets/images/icons/iconstack.io - (Save 2).svg',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF100F0F),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                label: SizedBox(
                  width: 70,
                  height: 20,
                  child: Center(
                    child: Text(
                      'Kaydet'.tr(),
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.0,
                        letterSpacing: -0.176,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00EF5B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  minimumSize: const Size(342, 44),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required String time,
    bool showDelete = false,
    String iconPath = 'assets/images/icons/Frame 6802.svg',
  }) {
    if (showDelete) {
      return Dismissible(
        key: ValueKey('${title}_$time'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: const Color(0xFFFEFEFE),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.only(right: 6.33),
          child: SvgPicture.asset(
            'assets/images/icons/Frame 7030.svg',
            width: 25.33,
            height: 25.33,
            fit: BoxFit.contain,
          ),
        ),
        onDismissed: (direction) {
          // TODO: bildirim silme işlemi burada ele alınabilir.
        },
        child: _buildNotificationCardContent(
          title: title,
          subtitle: subtitle,
          time: time,
          showDelete: showDelete,
          iconPath: iconPath,
        ),
      );
    }

    return _buildNotificationCardContent(
      title: title,
      subtitle: subtitle,
      time: time,
      showDelete: showDelete,
      iconPath: iconPath,
    );
  }

  Widget _buildNotificationCardContent({
    required String title,
    required String subtitle,
    required String time,
    required bool showDelete,
    String iconPath = 'assets/images/icons/Frame 6802.svg',
  }) {
    return Container(
      width: 342,
      height: 77,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF3F3F3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF06C44F),
              borderRadius: BorderRadius.circular(2.73),
            ),
            child: Center(
              child: Opacity(
                opacity: 1,
                child: SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 232),
                        child: SizedBox(
                          height: 17,
                          child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: -0.154,
                              color: const Color(0xFF0D0D0D),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 15,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          time,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: AppFont.montserrat,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            height: 1.0,
                            letterSpacing: -0.011,
                            color: const Color(0xFF4E4949),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 232),
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.0,
                        letterSpacing: -0.132,
                        color: const Color(0xFF4E4949),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    String? initialValue,
    TextInputType? keyboardType,
    bool isNameField = false,
    bool isAgeField = false,
    bool isHeightField = false,
    bool isWeightField = false,
  }) {
    // Özel yaş alanı: alt tarafta picker açan read-only input
    if (isAgeField) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 342,
            height: 18,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 1.5,
                letterSpacing: -0.011,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final pickedAge = await _showAgePicker(context, _selectedAge);
              if (pickedAge != null) {
                setState(() {
                  _selectedAge = pickedAge;
                });
              }
            },
            child: Container(
              width: 342,
              height: 40,
              padding: const EdgeInsets.fromLTRB(10, 11, 12, 11),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedAge.toString(),
                style: TextStyle(
                  fontFamily: AppFont.montserrat,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 1.5,
                  letterSpacing: -0.011,
                  color: const Color(0xFF525050),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Özel boy alanı: alt tarafta height picker açan read-only input
    if (isHeightField) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 342,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 1.5,
                letterSpacing: -0.011,
                color: const Color(0xFF000000),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final pickedHeight =
                  await _showHeightPicker(context, _selectedHeightCm);
              if (pickedHeight != null) {
                setState(() {
                  _selectedHeightCm = pickedHeight;
                });
              }
            },
            child: Container(
              width: 342,
              height: 40,
              padding: const EdgeInsets.fromLTRB(10, 11, 12, 11),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                (_selectedHeightCm / 100).toStringAsFixed(2),
                style: TextStyle(
                  fontFamily: AppFont.montserrat,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 1.5,
                  letterSpacing: -0.011,
                  color: const Color(0xFF525050),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      );
    }

    // Özel kilo alanı: alt tarafta weight picker açan read-only input
    if (isWeightField) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 342,
            height: 18,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 1.5,
                letterSpacing: -0.011,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final pickedWeight =
                  await _showWeightPicker(context, _selectedWeightKg);
              if (pickedWeight != null) {
                setState(() {
                  _selectedWeightKg = pickedWeight;
                });
              }
            },
            child: Container(
              width: 342,
              height: 40,
              padding: const EdgeInsets.fromLTRB(10, 11, 12, 11),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedWeightKg.toString(),
                style: TextStyle(
                  fontFamily: AppFont.montserrat,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 1.5,
                  letterSpacing: -0.011,
                  color: const Color(0xFF525050),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 342,
          height: 18,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.5,
              letterSpacing: -0.011,
              color: const Color(0xFF000000),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 342,
          height: 40,
          child: TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 11, 12, 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFEBEBEB), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFEBEBEB), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFEBEBEB), width: 1),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
            ),
            style: TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w500,
              fontSize: (isNameField || isAgeField || isHeightField || isWeightField) ? 12 : 14,
              height: (isNameField || isAgeField || isHeightField || isWeightField) ? 1.5 : null,
              letterSpacing: (isNameField || isAgeField || isHeightField || isWeightField) ? -0.011 : null,
              color: isNameField
                  ? const Color(0xFF3D3D3D)
                  : isAgeField
                      ? const Color(0xFF525050)
                      : isHeightField
                          ? const Color(0xFF525050)
                          : isWeightField
                          ? const Color(0xFF525050)
                      : const Color(0xFF000000),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 342,
          height: 18,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.5,
              letterSpacing: -0.011,
              color: const Color(0xFF000000),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          key: _bodyTypeFieldKey,
          width: 342,
          height: 40,
          padding: const EdgeInsets.fromLTRB(10, 11, 12, 11),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final selected = await _showBodyTypeMenu(
                context: context,
                currentValue: value,
                items: items,
              );
              if (selected != null) {
                onChanged(selected);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.5,
                      letterSpacing: -0.011,
                      color: const Color(0xFF3D3D3D),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/images/icons/Vector (18).svg',
                  width: 3,
                  height: 6,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF525050),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> _showBodyTypeMenu({
    required BuildContext context,
    required String currentValue,
    required List<String> items,
  }) async {
    final RenderBox box =
        _bodyTypeFieldKey.currentContext!.findRenderObject() as RenderBox;
    final Offset fieldOffset = box.localToGlobal(Offset.zero);
    final Size fieldSize = box.size;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // Menü, alanın sağ alt köşesine yakın açılsın
    const double menuWidth = 85;
    final double left = fieldOffset.dx + fieldSize.width - menuWidth;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(left, fieldOffset.dy + fieldSize.height, menuWidth, 0),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      color: const Color(0xFFECECEC),
      items: items
          .map(
            (item) => PopupMenuItem<String>(
              value: item,
              height: 19,
              child: SizedBox(
                width: menuWidth,
                height: 19,
                child: Container(
                  width: menuWidth,
                  height: 19,
                  color: item == currentValue
                      ? const Color(0x6ED0CDCD) // #D0CDCD6E
                      : const Color(0xFFECECEC),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.5,
                      letterSpacing: -0.011,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: Color(0x1CEBEBEB), width: 1),
      ),
    );

    return selected ?? currentValue;
  }

  Future<int?> _showAgePicker(BuildContext context, int currentAge) async {
    final int minAge = 15;
    final int maxAge = 80;
    final FixedExtentScrollController controller =
        FixedExtentScrollController(initialItem: currentAge - minAge);

    final picked = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        int tempAge = currentAge;
        final mediaQuery = MediaQuery.of(ctx);
        final screenHeight = mediaQuery.size.height;
        final bottomSafe = mediaQuery.padding.bottom;
        final sheetHeight = screenHeight * 0.56;
        final bottomPadding = bottomSafe + 24;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: sheetHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF1FFF6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/icons/Grabber.svg',
                                width: 36,
                                height: 5,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 24, minHeight: 24),
                            icon: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Center(
                                child: Opacity(
                                  opacity: 1,
                                  child: SvgPicture.asset(
                                    'assets/images/icons/Clip path group (1).svg',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop(tempAge);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: 120,
                          child: ListWheelScrollView.useDelegate(
                      controller: controller,
                      itemExtent: 40,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setModalState(() {
                          tempAge = minAge + index;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0 || index > maxAge - minAge) {
                            return null;
                          }
                          final age = minAge + index;
                          final bool isSelected = age == tempAge;
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.of(context).pop(age);
                            },
                            child: Center(
                              child: SizedBox(
                                width: isSelected ? 60 : 139,
                                height: isSelected ? 31 : 25,
                                child: Text(
                                  age.toString(),
                                  textAlign: TextAlign.center,
                                  style: isSelected
                                      ? GoogleFonts.leagueSpartan(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 33.41,
                                          height: 1.0,
                                          letterSpacing: 0,
                                          color: const Color(0xFF000000),
                                        )
                                      : GoogleFonts.leagueSpartan(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 26.73,
                                          height: 1.0,
                                          letterSpacing: 0,
                                          color: const Color(0xFFCECECE),
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    return picked;
  }

  Future<int?> _showHeightPicker(
      BuildContext context, int currentHeightCm) async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _HeightPickerSheetContent(
        initialHeightCm: currentHeightCm,
      ),
    );
    return picked;
  }

  Future<int?> _showWeightPicker(
      BuildContext context, int currentWeightKg) async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _WeightPickerSheetContent(
        initialWeightKg: currentWeightKg.toDouble(),
      ),
    );
    return picked;
  }

  Widget _buildProfileRow(
    IconData icon,
    String title, {
    IconData? trailing,
    String? trailingSvgAsset,
    String? leadingSvgAsset,
    bool isSwitch = false,
    bool isLogout = false,
    bool darkTextStyle = false,
    bool? switchValue,
    void Function(bool)? switchOnChanged,
    VoidCallback? onTap,
  }) {
    final TextStyle textStyle = isLogout
        ? TextStyle(
            fontFamily: AppFont.montserrat,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            height: 1.5,
            letterSpacing: -0.154,
            color: const Color(0xFFE61317),
          )
        : darkTextStyle
            ? TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.5,
                letterSpacing: -0.154,
                color: const Color(0xFF000000),
              )
            : TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: const Color(0xFF323232),
              );
    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          if (leadingSvgAsset != null)
            SvgPicture.asset(
              leadingSvgAsset!,
              width: 28,
              height: 28,
            )
          else if (isLogout)
            SvgPicture.asset(
              'assets/images/icons/Frame 6637.svg',
              width: 28,
              height: 28,
            )
          else
            Icon(icon, size: 24, color: const Color(0xFF9E9E9E)),
          const SizedBox(width: 12),
          Expanded(
            child: isLogout
                ? SizedBox(
                    width: 64,
                    height: 21,
                    child: Text(
                      title,
                      style: textStyle,
                    ),
                  )
                : Text(
                    title,
                    style: textStyle,
                  ),
          ),
          if (isSwitch)
            SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: Transform.scale(
                  scaleX: 37 / 51,
                  scaleY: 20 / 31,
                  alignment: Alignment.center,
                  child: Switch(
                    value: switchValue ?? false,
                    onChanged: switchOnChanged ?? (_) {},
                    activeTrackColor: const Color(0xFF06C44F),
                    inactiveTrackColor: const Color(0xF5342F2F),
                    activeThumbColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            )
          else if (trailingSvgAsset != null)
            SvgPicture.asset(
              trailingSvgAsset,
              width: 24,
              height: 24,
            )
          else if (trailing != null && !isLogout)
            Icon(trailing, size: 20, color: const Color(0xFF9E9E9E)),
        ],
      ),
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }

  Widget _buildProfileDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFF3F3F3),
      indent: 52,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage:
                AssetImage('assets/images/resimler/loginkadin.png'),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 181,
                height: 30,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hoşgeldin Sinem'.tr(),
                    style: const TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      height: 1.5, // line-height %150
                      letterSpacing: -0.011,
                      color: Color(0xFF0D0D0D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 2),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/images/icons/Vector (16).svg',
              width: 14.89693832397461,
              height: 15.831620216369629,
              colorFilter: const ColorFilter.mode(
                Color(0xFF000000),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = _days[index];
          final bool isSelected = index == _selectedDayIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF06C44F) : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.day,
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.5,
                      letterSpacing: -0.011,
                      color: isSelected ? Colors.white : const Color(0xFF000000),
                    ),
                  ),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.5,
                      letterSpacing: -0.011,
                      color:
                          isSelected ? Colors.white : const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: _days.length,
      ),
    );
  }

  Widget _buildTodayWorkoutCard() {
    const green = Color(0xFF06C44F);
    return SizedBox(
      width: 342,
      height: 121,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Görsel sağda, yeşil panelin altına biraz taşacak şekilde (referans)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 125,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                child: Image.asset(
                  'assets/images/resimler/anasayfa.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Yeşil panel solda, görselin bir kısmının üzerine biniyor
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Aktivasyon'.tr(),
                          style: TextStyle(
                            fontFamily: AppFont.montserrat,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 1.0,
                            letterSpacing: -0.176,
                            color: Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 9,
                          runSpacing: 7,
                          children: [
                            _buildChipWithIcon(
                              iconPath:
                                  'assets/images/icons/iconstack.io - (Back Muscle Body).svg',
                              label: '8 Egzersiz'.tr(),
                            ),
                            _buildChipWithIcon(
                              iconPath:
                                  'assets/images/icons/iconstack.io - (Dumbbell Large).svg',
                              label: 'Bölge: Karın'.tr(),
                            ),
                            _buildChipWithIcon(
                              iconPath:
                                  'assets/images/icons/iconstack.io - (Clock).svg',
                              label: '30 Dakika'.tr(),
                            ),
                            _buildChipWithIcon(
                              iconPath:
                                  'assets/images/icons/Vector (17).svg',
                              label: '250 Kcal'.tr(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 95),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return SizedBox(
      width: 100,
      height: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFont.montserrat,
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color: const Color(0xFF06C44F),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildChipWithIcon({
    required String iconPath,
    required String label,
  }) {
    return SizedBox(
      width: 100,
      height: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 12,
              height: 12,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: AppFont.montserrat,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: const Color(0xFF06C44F),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kaldığın Yerden Devam Et'.tr(),
          style: TextStyle(
            fontFamily: AppFont.montserrat,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            height: 1.0,
            letterSpacing: -0.011,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 12),
        _buildExerciseCard(
          title: 'Bent Knee Leg Raise',
          progress: 0.62,
          imagePath: 'assets/images/resimler/bentkneeleg.png',
        ),
        const SizedBox(height: 8),
        _buildExerciseCard(
          title: 'Lying Knee Raise',
          progress: 0.45,
          imagePath: 'assets/images/resimler/bentkneeraise.png',
        ),
      ],
    );
  }

  Widget _buildExerciseCard({
    required String title,
    required double progress,
    String? imagePath,
  }) {
    return Container(
      width: 345,
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: const Color(0xFFEBEBEB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Opacity(
                opacity: 1,
                child: Image.asset(
                  imagePath,
                  width: 97,
                  height: 86,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE8FFF1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: Color(0xFF06C44F),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 86,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 20,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: AppFont.montserrat,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 1.0,
                                letterSpacing: -0.176,
                                color: const Color(0xFF000000),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(4, 2.75, 3, 2.75),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Opacity(
                          opacity: 1,
                          child: SvgPicture.asset(
                            'assets/images/icons/Frame 7065.svg',
                            width: 22,
                            height: 22,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 18,
                        padding: const EdgeInsets.fromLTRB(13, 1, 13, 1),
                        decoration: BoxDecoration(
                          color: const Color(0xC45B5B5B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Karın',
                          style: TextStyle(
                            fontFamily: AppFont.montserrat,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 29,
                        height: 17,
                        child: Center(
                          child: Text(
                            '${(progress * 100).round()}%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: -0.154,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 213,
                    height: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: const Color(0xFFDDDDDD),
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF00EF5B)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayProgressSummary() {
    const double col1Width = 170;
    const double col2Width = 164;
    const double gap = 8;
    return SizedBox(
      width: 342,
      child: Column(
        children: [
          Row(
            children: [
              _buildSummaryCard(
                title: 'Tamamlanan Gün',
                value: '12/30',
                width: col1Width,
              ),
              const SizedBox(width: gap),
              _buildSummaryCard(
                title: 'Yakılan Kalori',
                value: '480 Kcal',
                width: col2Width,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSummaryCard(
                title: 'Hareket Sayısı',
                value: '46',
                width: 213,
              ),
              const SizedBox(width: gap),
              _buildSummaryCard(
                title: 'Süre',
                value: '40 Dk',
                width: 119,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    double? width,
  }) {
    final bool isHighlight = title == 'Yakılan Kalori';
    final double cardWidth = width ?? 164;
    return SizedBox(
      width: cardWidth,
      height: 76,
      child: Container(
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0xFF06C44F) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10),
          border: isHighlight
              ? null
              : Border.all(
                  color: const Color(0xFFEBEBEB),
                  width: 1,
                ),
        ),
        padding: const EdgeInsets.all(12),
        child: title == 'Hareket Sayısı'
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 108,
                          height: 15,
                          child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 1.0,
                              letterSpacing: -0.011,
                              color: const Color(0xFF434343),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 84,
                          height: 24,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: AppFont.montserrat,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              height: 1.0,
                              letterSpacing: -0.011,
                              color: const Color(0xFF06C44F),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      bottom: -4,
                      child: SizedBox(
                        width: 112,
                        height: 56,
                        child: SvgPicture.asset(
                          'assets/images/icons/Group 216.svg',
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : title == 'Süre'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned(
                          left: 4,
                          top: 4,
                          child: SizedBox(
                            width: 60,
                            height: 16,
                            child: Text(
                              title,
                              style: TextStyle(
                                fontFamily: AppFont.montserrat,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 1.0,
                                letterSpacing: -0.011,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: SvgPicture.asset(
                              'assets/images/icons/Group 218.svg',
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : isHighlight
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 108,
                                  height: 15,
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontFamily: AppFont.montserrat,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      height: 1.0,
                                      letterSpacing: -0.011,
                                      color: const Color(0xFFEEEEEE),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 88,
                                  height: 24,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontFamily: AppFont.montserrat,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      height: 1.0,
                                      letterSpacing: -0.011,
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  width: 48,
                                  height: 50,
                                  child: SvgPicture.asset(
                                    'assets/images/icons/Group 217.svg',
                                    fit: BoxFit.contain,
                                    alignment: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 108,
                            height: 15,
                            child: Text(
                              title,
                              style: TextStyle(
                                fontFamily: AppFont.montserrat,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 1.0,
                                letterSpacing: -0.011,
                                color: const Color(0xFF434343),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          title == 'Tamamlanan Gün'
                              ? RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: AppFont.montserrat,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      height: 1.0,
                                      letterSpacing: -0.011,
                                      color: const Color(0xFF000000),
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: '12',
                                        style: TextStyle(color: Color(0xFF06C44F)),
                                      ),
                                      TextSpan(text: '/30'),
                                    ],
                                  ),
                                )
                              : Text(
                                  value,
                                  style: TextStyle(
                                    fontFamily: AppFont.montserrat,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    height: 1.0,
                                    letterSpacing: -0.011,
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                        ],
                      ),
      ),
    );
  }

  /// Bugünkü antrenman tamamlama kartı: dairesel %86 + "Bugünkü antrenmanının %86'sını tamamladın!" + motivasyon metni
  Widget _buildTodayTrainingProgressCard() {
    const int percent = 86;
    return Container(
      width: 342,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _todayWorkoutProgress,
                  strokeWidth: 4,
                  backgroundColor: const Color(0xFFE8E8E8),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF06C44F)),
                ),
                Text(
                  '%$percent',
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    height: 1.0,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 1.3,
                      color: const Color(0xFF000000),
                    ),
                    children: [
                      const TextSpan(text: 'Bugünkü antrenmanının '),
                      TextSpan(
                        text: '%$percent',
                        style: const TextStyle(color: Color(0xFF06C44F)),
                      ),
                      const TextSpan(text: '\'sını tamamladın!'),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kısa bir mola ver, nefesini toparla ve güçlü bir şekilde devam et.',
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 1.3,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedDaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tamamlanan Günler'.tr(),
          style: TextStyle(
            fontFamily: AppFont.montserrat,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            height: 1.0,
            letterSpacing: -0.176,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 342,
          height: 165,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: const Color(0xFFEBEBEB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Tamamlanan Günler'.tr(),
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: const Color(0xFF0D0D0D),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDayNavButton(Icons.chevron_left),
                        const SizedBox(width: 8),
                        _buildDayNavButton(Icons.chevron_right),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.fromLTRB(9, 5, 9, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 7; i++) ...[
                        if (i > 0) const SizedBox(width: 6),
                        _buildCompletedDayCard(
                          dayNumber: (i + 1).toString().padLeft(2, '0'),
                          completed: i < 3,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayNavButton(IconData icon) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Icon(icon, size: 18, color: const Color(0xFF9E9E9E)),
    );
  }

  Widget _buildCompletedDayCard({
    required String dayNumber,
    required bool completed,
  }) {
    return Container(
      width: 36,
      height: 84,
      decoration: BoxDecoration(
        color: completed
            ? const Color(0xFF06C44F)
            : const Color(0x2906C44F),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (completed)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(
                Icons.local_fire_department,
                size: 18,
                color: Colors.white,
              ),
            )
          else
            const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              dayNumber,
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: completed
                    ? Colors.white
                    : const Color(0xFF9E9E9E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSection() {
    return Container(
      width: 342,
      height: 124,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment(0, -1),
          end: Alignment(0, 1),
          transform: GradientRotation(184.44 * pi / 180),
          colors: const [
            Color(0xFF20C729),
            Color(0xFF063527),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Opacity(
                opacity: 1,
                child: SvgPicture.asset(
                  'assets/images/icons/Frame 7190.svg',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 20,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Premium\'a Geç',
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.67,
                      height: 1.0,
                      letterSpacing: -0.183,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: 217,
            height: 15,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tüm gelişmiş özelliklerin kilidini aç.',
                style: TextStyle(
                  fontFamily: AppFont.montserrat,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 1.0,
                  letterSpacing: -0.132,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: SizedBox(
              width: 217,
              height: 44,
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment(0, -1),
                  end: Alignment(0, 1),
                  transform: GradientRotation(184.44 * pi / 180),
                  colors: const [
                    Color(0xFF20C729),
                    Color(0xFF063527),
                  ],
                ).createShader(bounds),
                child: SizedBox(
                  width: 105,
                  height: 20,
                  child: Center(
                    child: Text(
                      'Planı Yükselt',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.0,
                        letterSpacing: -0.176,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 342,
          height: 220,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 320,
                height: 20,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dönüşüm Verileri',
                style: TextStyle(
                  fontFamily: AppFont.montserrat,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.0,
                  letterSpacing: -0.176,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 320,
            height: 160,
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: const Color(0x8CEBEBEB),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Toplam Kilo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFont.montserrat,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            height: 1.2,
                            letterSpacing: -0.145,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        Text(
                          'Değişimi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFont.montserrat,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            height: 1.2,
                            letterSpacing: -0.145,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10.55, 19.78, 10.55, 19.78),
                      child: SvgPicture.asset(
                        'assets/images/icons/Frame 7302.svg',
                        width: 71.21052551269531,
                        height: 47.47368240356445,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 13.19),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTransformationBar('Yağ Oranı Değişimi', '(-4%)', const Color(0xFFFF383C)),
                        const SizedBox(height: 2),
                        _buildTransformationBar('Kas Kütlesi Artışı', '(+2.1)', const Color(0xFFFFB74D)),
                        const SizedBox(height: 2),
                        _buildTransformationBar('Bel Çevresi Değişimi', '(-3.2)', const Color(0xFF7E57C2)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
        ),
        const SizedBox(height: 16),
        _buildIlerlemeDurumunSection(),
      ],
    );
  }

  Widget _buildIlerlemeDurumunSection() {
    return SizedBox(
      width: 342,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 157,
                height: 24,
                child: Text(
                  'İlerleme Durumun',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFont.montserrat,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.0,
                    letterSpacing: -0.176,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/icons/iconstack.io - (Graph Up).svg',
                width: 24,
                height: 24,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIlerlemeSmallCard(
                        title: 'Toplam Aktivite',
                        value: '12',
                        iconPath: 'assets/images/icons/Frame 7231.svg',
                        isLightGreen: false,
                        iconBoxSize: 24,
                        iconBoxPadding: 4,
                        iconBoxRadius: 12,
                        iconSize: 16,
                        excludeColorFilter: true,
                      ),
                      const SizedBox(width: 7),
                      _buildIlerlemeSmallCard(
                        title: 'Yakılan Kalori',
                        value: '40 Kcal',
                        iconPath: 'assets/images/icons/Frame 7231 (1).svg',
                        isLightGreen: true,
                        backgroundColor: const Color(0xFFD4FFE4),
                        iconBoxSize: 24,
                        iconBoxPadding: 4,
                        iconBoxRadius: 12,
                        iconSize: 16,
                        excludeColorFilter: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIlerlemeSmallCard(
                        title: 'Verilen Kilo',
                        value: '-2 Kg',
                        iconPath: 'assets/images/icons/iconstack.io - (Dumbbell Large).svg',
                        isLightGreen: true,
                        backgroundColor: const Color(0xFFD4FFE4),
                        iconBoxSize: 24,
                        iconBoxPadding: 4,
                        iconBoxRadius: 12,
                        iconSize: 16,
                      ),
                      const SizedBox(width: 7),
                      _buildIlerlemeSmallCard(
                        title: 'Serilerin',
                        value: '3 Gün',
                        iconPath: 'assets/images/icons/Frame 7231 (2).svg',
                        isLightGreen: false,
                        iconBoxSize: 24,
                        iconBoxPadding: 4,
                        iconBoxRadius: 12,
                        iconSize: 16,
                        excludeColorFilter: true,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 7),
              _buildIlerlemeBigCard(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIlerlemeSmallCard({
    required String title,
    required String value,
    required String iconPath,
    required bool isLightGreen,
    Color? backgroundColor,
    double? iconBoxSize,
    double? iconBoxPadding,
    double? iconBoxRadius,
    double? iconSize,
    bool excludeColorFilter = false,
  }) {
    final double boxSize = iconBoxSize ?? 36;
    final double padding = iconBoxPadding ?? 0;
    final double radius = iconBoxRadius ?? 18;
    final double imgSize = iconSize ?? 18;
    final Color cardColor = backgroundColor ?? (isLightGreen ? const Color(0xFFE8F5E9) : Colors.white);
    return Container(
      width: 101,
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            padding: padding > 0 ? EdgeInsets.all(padding) : null,
            decoration: BoxDecoration(
              color: const Color(0xFF06C44F),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: imgSize,
                height: imgSize,
                fit: BoxFit.contain,
                colorFilter: excludeColorFilter ? null : const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w500,
              fontSize: 10,
              height: 1.0,
              letterSpacing: -0.11,
              color: const Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.0,
              letterSpacing: -0.176,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIlerlemeBigCard() {
    return Container(
      width: 125,
      height: 188,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF06C44F),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF06C44F), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 101,
              height: 17,
              child: Text(
                'Başarı Yüzden',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.0,
                letterSpacing: -0.154,
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
          const SizedBox(height: 16),
          Center(
            child: SvgPicture.asset(
              'assets/images/icons/Frame 7238.svg',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 110,
            height: 12,
            child: Text(
              'En iyini yaptığını bil. ✨',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w400,
                fontSize: 10,
                height: 1.0,
                letterSpacing: -0.11,
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: Transform.translate(
              offset: const Offset(0, 12),
              child: SizedBox(
                width: 38,
                height: 50,
                child: SvgPicture.asset(
                  'assets/images/icons/Vector (19).svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransformationBar(String label, String value, Color progressColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFont.montserrat,
            fontWeight: FontWeight.w500,
            fontSize: 11,
            color: const Color(0xFF000000),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth = constraints.maxWidth;
                  final fillWidth = (barWidth * 0.6).clamp(0.0, barWidth);
                  return SizedBox(
                    height: 7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            width: barWidth,
                            height: 7,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E2E2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(
                            width: fillWidth,
                            height: 7,
                            child: Container(
                              decoration: BoxDecoration(
                                color: progressColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                fontFamily: AppFont.montserrat,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: progressColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFont.montserrat,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: const Color(0xFF9E9E9E),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFont.montserrat,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: const Color(0xFF06C44F),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection({bool includePerformanceProgressBlock = true, bool includeBigCards = true, bool includeSmallCards = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (includeBigCards) ...[
          _buildPerformanceBigCard(
            title: 'Antrenman Tamamlama Oranın',
            value: '%72',
            progress: 0.72,
            iconPath: 'assets/images/icons/Frame 7118.svg',
            iconWidth: 54,
            iconHeight: 54,
            useFullIcon: true,
          ),
          const SizedBox(height: 8),
          _buildPerformanceBigCard(
            title: 'Toplam Yakılan Kalori',
            value: '2100 Kcal',
            progress: 0.85,
            iconPath: 'assets/images/icons/Frame 7119.svg',
            customIcon: _buildCalorieCombinedIcon(),
          ),
          const SizedBox(height: 8),
        ],
        if (includeSmallCards) ...[
          Row(
            children: [
              SizedBox(
                width: 105,
                child: _buildPerformanceSmallCard(
                  title: 'Kalp Atışın',
                  value: '82',
                  iconPath: 'assets/images/icons/Frame 7123.svg',
                  vectorPath: 'assets/images/icons/Vector (20).svg',
                  iconOffset: const Offset(0, 0),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 105,
                child: _buildPerformanceSmallCard(
                  title: 'Mevcut Ağırlık',
                  value: '62 Kg',
                  subtitle: '-3 Kg',
                  iconPath: 'assets/images/icons/Frame 7124.svg',
                  titleLines: const ['Mevcut', 'Ağırlık'],
                  iconOffset: const Offset(4, 0),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 105,
                child: _buildPerformanceSmallCard(
                  title: 'Yağ Oranın',
                  value: '%12',
                  subtitle: 'Az',
                  iconPath: 'assets/images/icons/iconstack.io - (Body Weight).svg',
                  iconOffset: const Offset(4, 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        if (includeBigCards)
          _buildPerformanceBigCard(
            title: 'Uykuda Geçirilen Süre',
            value: '10 Saat',
            progress: 0.8,
            iconPath: 'assets/images/icons/Frame 7119 (1).svg',
            customIcon: _buildSleepCombinedIcon(),
          ),
        if (includePerformanceProgressBlock) ...[
          const SizedBox(height: 8),
          _buildVerilenKiloVucutSuyuKasCard(),
        ],
      ],
    );
  }

  Widget _buildVerilenKiloVucutSuyuKasCard() {
    return Container(
      width: 345,
      height: 148,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF2F2F2), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricCircleItem(
              title: 'Verilen Kilo',
              value: '-3 Kilo',
              progress: 0.68,
              iconPath: 'assets/images/icons/Frame 7118 (1).svg',
              progressColor: const Color(0xFF06C44F),
              valueColor: const Color(0xFF06C44F),
            ),
          ),
          Expanded(
            child: _buildMetricCircleItem(
              title: 'Vücut Suyu',
              value: '%45',
              progress: 0.78,
              iconPath: 'assets/images/icons/Frame 7119 (2).svg',
              progressColor: const Color(0xFF29B6F6),
              valueColor: const Color(0xFF29B6F6),
            ),
          ),
          Expanded(
            child: _buildMetricCircleItem(
              title: 'Kas Oranı',
              value: '%10',
              progress: 0.78,
              iconPath: 'assets/images/icons/iconstack.io - (Body Part Six Pack).svg',
              progressColor: const Color(0xFFF9A825),
              valueColor: const Color(0xFFF9A825),
              showArrow: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCircleItem({
    required String title,
    required String value,
    required double progress,
    required String iconPath,
    required Color progressColor,
    required Color valueColor,
    bool showArrow = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 68,
          height: 15,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.0,
              letterSpacing: 12 * -0.011,
              color: const Color(0xFF000000),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                backgroundColor: const Color(0xFFE8E8E8),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(progressColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showArrow) ...[
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.0,
                  letterSpacing: 14 * -0.011,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 2),
              SvgPicture.asset(
                'assets/images/icons/iconstack.io - (Arrow Bear Right).svg',
                width: 14,
                height: 14,
                fit: BoxFit.contain,
              ),
            ] else
              SizedBox(
                width: 68,
                height: 17,
                child: value == '-3 Kilo'
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 1.0,
                            letterSpacing: 14 * -0.011,
                          ),
                          children: [
                            TextSpan(text: '-3 ', style: TextStyle(color: valueColor)),
                            const TextSpan(text: 'Kilo', style: TextStyle(color: Color(0xFF000000))),
                          ],
                        ),
                      )
                    : Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1.0,
                          letterSpacing: 14 * -0.011,
                          color: valueColor,
                        ),
                      ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalorieCombinedIcon() {
    return SizedBox(
      width: 70,
      height: 71,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 5,
            child: SvgPicture.asset(
              'assets/images/icons/Ellipse 75 (1).svg',
              width: 54,
              height: 33,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: -10,
            left: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.42),
              child: SizedBox(
                width: 50,
                height: 36,
                child: SvgPicture.asset(
                  'assets/images/icons/Ellipse 76.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 9,
            left: 19,
            child: SvgPicture.asset(
              'assets/images/icons/Frame 7119.svg',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepCombinedIcon() {
    return SizedBox(
      width: 70,
      height: 71,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 5,
            child: SvgPicture.asset(
              'assets/images/icons/Ellipse 75 (1).svg',
              width: 54,
              height: 33,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: -10,
            left: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.42),
              child: SizedBox(
                width: 50,
                height: 36,
                child: SvgPicture.asset(
                  'assets/images/icons/Ellipse 76.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 19,
            child: SvgPicture.asset(
              'assets/images/icons/Frame 7119 (1).svg',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceBigCard({
    required String title,
    required String value,
    required double progress,
    required String iconPath,
    double? iconWidth,
    double? iconHeight,
    bool useFullIcon = false,
    bool excludeColorFilter = false,
    Widget? customIcon,
  }) {
    return Container(
      width: 342,
      height: 76,
      padding: const EdgeInsets.fromLTRB(15, 11, 16, 11),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SizedBox(
            width: useFullIcon ? (iconWidth ?? 64) : 64,
            height: useFullIcon ? (iconHeight ?? 64) : 64,
            child: customIcon != null
                ? customIcon!
                : useFullIcon
                ? SvgPicture.asset(
                    iconPath,
                    width: iconWidth ?? 54,
                    height: iconHeight ?? 54,
                    fit: BoxFit.contain,
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 4,
                        backgroundColor: const Color(0xFFE8E8E8),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF06C44F)),
                      ),
                      SvgPicture.asset(
                        iconPath,
                        width: iconWidth ?? 24,
                        height: iconHeight ?? 24,
                        fit: BoxFit.contain,
                        colorFilter: excludeColorFilter ? null : const ColorFilter.mode(
                            Color(0xFF06C44F),
                            BlendMode.srcIn,
                          ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 226,
                  height: 17,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.0,
                      letterSpacing: 14 * -0.011,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 226,
                  height: 17,
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.0,
                      letterSpacing: 14 * -0.011,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSmallCard({
    required String title,
    required String value,
    String? subtitle,
    String? iconPath,
    String? vectorPath,
    List<String>? titleLines,
    Offset? iconOffset,
  }) {
    const double vectorTop = 30.08 - 12 - 20;
    return Container(
      width: 105,
      height: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xA8F2F2F2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: titleLines != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: titleLines.map((line) => Text(
                          line,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            height: 1.0,
                            letterSpacing: 10 * -0.011,
                            color: const Color(0xFF000000),
                          ),
                        )).toList(),
                      )
                    : Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          height: 1.0,
                          letterSpacing: 10 * -0.011,
                          color: const Color(0xFF000000),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              if (iconPath != null)
                Transform.translate(
                  offset: iconOffset ?? const Offset(-12, 0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      iconPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
          if (vectorPath != null) ...[
            SizedBox(height: vectorTop.clamp(0.0, 20.0)),
            SizedBox(
              height: 44,
              child: ClipRect(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: SvgPicture.asset(
                          vectorPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, 2),
                      child: Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1.0,
                          letterSpacing: 12 * -0.011,
                          color: const Color(0xFF484848),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            SizedBox(height: (title == 'Mevcut Ağırlık' || title == 'Yağ Oranın') ? 8 : 4),
            Text(
              value,
              style: (title == 'Mevcut Ağırlık' || title == 'Yağ Oranın')
                  ? TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 1.0,
                      letterSpacing: -0.011,
                      color: const Color(0xFF000000),
                    )
                  : TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: const Color(0xFF000000),
                    ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: (title == 'Mevcut Ağırlık' || title == 'Yağ Oranın') ? 6 : 2),
            Text(
              subtitle,
              style: (title == 'Mevcut Ağırlık' || title == 'Yağ Oranın')
                  ? TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.0,
                      letterSpacing: 12 * -0.011,
                      color: const Color(0xFF484848),
                    )
                  : TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: const Color(0xFF06C44F),
                    ),
            ),
          ],
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFEBEBEB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: const Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: const Color(0xFF0D0D0D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w500,
              fontSize: 11,
              color: const Color(0xFF06C44F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      width: 390,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: 1, color: const Color(0x1A000000)),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            offset: const Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Theme(
            data: Theme.of(context).copyWith(
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedLabelStyle: TextStyle(
                  fontFamily: AppFont.manrope,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 22 / 12,
                  letterSpacing: 0,
                  color: const Color(0xFF06C44F),
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: AppFont.manrope,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 22 / 12,
                  letterSpacing: 0,
                  color: const Color(0xFF323232),
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedTabIndex,
              onTap: (index) => setState(() => _selectedTabIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: const Color(0xFF06C44F),
              unselectedItemColor: const Color(0xFF323232),
              items: [
                BottomNavigationBarItem(
                  icon: Opacity(
                    opacity: 1,
                    child: SvgPicture.asset(
                      'assets/images/icons/iconstack.io - (Home 24).svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF323232),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  activeIcon: Opacity(
                    opacity: 1,
                    child: SvgPicture.asset(
                      'assets/images/icons/iconstack.io - (Home 24).svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF06C44F),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  label: 'Anasayfa'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Opacity(
                    opacity: 1,
                    child: SvgPicture.asset(
                      'assets/images/icons/iconstack.io - (Body Part Six Pack).svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF323232),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  activeIcon: Opacity(
                    opacity: 1,
                    child: SvgPicture.asset(
                      'assets/images/icons/iconstack.io - (Body Part Six Pack).svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF06C44F),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  label: 'Antrenman'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Opacity(
                    opacity: 1,
                    child: SvgPicture.asset(
                      'assets/images/icons/iconstack.io - (Graph Up).svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF323232),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  activeIcon: Opacity(
                    opacity: 1,
                    child: SvgPicture.asset(
                      'assets/images/icons/iconstack.io - (Graph Up).svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF06C44F),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  label: 'İlerleme'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Opacity(
                    opacity: 1,
                    child: SvgPicture.asset(
                      'assets/images/icons/iconstack.io - (User Circle Regular).svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF323232),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  activeIcon: Opacity(
                    opacity: 1,
                    child: SvgPicture.asset(
                      'assets/images/icons/iconstack.io - (User Circle Regular).svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF06C44F),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  label: 'Profil'.tr(),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class _HeightPickerSheetContent extends StatefulWidget {
  final int initialHeightCm;

  const _HeightPickerSheetContent({required this.initialHeightCm});

  @override
  State<_HeightPickerSheetContent> createState() =>
      _HeightPickerSheetContentState();
}

class _HeightPickerSheetContentState extends State<_HeightPickerSheetContent> {
  late final ScrollController _scrollController;
  late int _value;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _value = widget.initialHeightCm
        .clamp(BodyMeasureConstants.minHeightCm, BodyMeasureConstants.maxHeightCm);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onRulerScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final vh = pos.viewportDimension;
    final off = _scrollController.offset + vh / 2;
    final idx = (off / heightRulerTickSpacingPx).round().clamp(
        0, BodyMeasureConstants.maxHeightCm - BodyMeasureConstants.minHeightCm);
    final v = BodyMeasureConstants.minHeightCm + idx;
    if (v != _value) setState(() => _value = v);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final bottomSafe = mediaQuery.padding.bottom;
    final sheetHeight = screenHeight * 0.56;
    final bottomPadding = bottomSafe + 24;
    return Container(
      height: sheetHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF1FFF6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        border: Border.fromBorderSide(BorderSide(
          width: 0,
          color: Color(0xFFCECECE),
          style: BorderStyle.solid,
        )),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/icons/Grabber.svg',
                        width: 36,
                        height: 5,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/Clip path group (1).svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(_value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SizedBox(
                height: 180,
                child: HeightRuler(
                  selectedHeightCm: _value,
                  scrollController: _scrollController,
                  onScroll: _onRulerScroll,
                  heightUnit: HeightUnit.cm,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightPickerSheetContent extends StatefulWidget {
  final double initialWeightKg;

  const _WeightPickerSheetContent({required this.initialWeightKg});

  @override
  State<_WeightPickerSheetContent> createState() =>
      _WeightPickerSheetContentState();
}

class _WeightPickerSheetContentState extends State<_WeightPickerSheetContent> {
  late final ScrollController _scrollController;
  late double _value;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _value = widget.initialWeightKg.clamp(
        BodyMeasureConstants.minWeightKg, BodyMeasureConstants.maxWeightKg);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onRulerScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final vw = pos.viewportDimension;
    final off = _scrollController.offset + vw / 2;
    final range = (BodyMeasureConstants.maxWeightKg - BodyMeasureConstants.minWeightKg).round();
    final idx = (off / weightRulerTickSpacingPx).round().clamp(0, range);
    final v = BodyMeasureConstants.minWeightKg + idx;
    if ((v - _value).abs() > 0.01) setState(() => _value = v);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final bottomSafe = mediaQuery.padding.bottom;
    final sheetHeight = screenHeight * 0.56;
    final bottomPadding = bottomSafe + 24;
    return Container(
      height: sheetHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF1FFF6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        border: Border.fromBorderSide(BorderSide(
          width: 0,
          color: Color(0xFFCECECE),
          style: BorderStyle.solid,
        )),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/icons/Grabber.svg',
                        width: 36,
                        height: 5,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/Clip path group (1).svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(_value.round()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SizedBox(
                height: 180,
                child: WeightRuler(
                  selectedWeightKg: _value,
                  scrollController: _scrollController,
                  onScroll: _onRulerScroll,
                  minKg: BodyMeasureConstants.minWeightKg,
                  maxKg: BodyMeasureConstants.maxWeightKg,
                  weightUnit: WeightUnit.kg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayItem {
  final String day;
  final String label;

  const _DayItem({required this.day, required this.label});
}

