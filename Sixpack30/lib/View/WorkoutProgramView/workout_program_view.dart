import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sixpack30/View/HomeView/home_view.dart';

enum WorkoutStatus { completed, current, locked }

class WorkoutDay {
  final String title;
  final String duration;
  final String thumbnailAsset;
  final WorkoutStatus status;

  const WorkoutDay({
    required this.title,
    required this.duration,
    required this.thumbnailAsset,
    required this.status,
  });
}

class WorkoutProgramView extends StatelessWidget {
  final VoidCallback? onBack;

  const WorkoutProgramView({super.key, this.onBack});

  /// 30 günlük program görselleri: 1. gün = Frame 6975.jpg, 2. gün = Frame 6975 (1).jpg, ...
  static const List<String> _programThumbnails = [
    'assets/images/resimler/30GunlukProgram/Frame 6975.jpg',       // 1
    'assets/images/resimler/30GunlukProgram/Frame 6975 (1).jpg',  // 2
    'assets/images/resimler/30GunlukProgram/Frame 6975 (2).jpg',  // 3
    'assets/images/resimler/30GunlukProgram/Frame 6975 (3).jpg',  // 4
    'assets/images/resimler/30GunlukProgram/Frame 6975 (4).jpg',  // 5
    'assets/images/resimler/30GunlukProgram/Frame 6975 (5).jpg',  // 6
    'assets/images/resimler/30GunlukProgram/Frame 6975 (6).jpg',  // 7
    'assets/images/resimler/30GunlukProgram/Frame 6975 (7).jpg',  // 8
    'assets/images/resimler/30GunlukProgram/Frame 6975 (8).jpg',  // 9
    'assets/images/resimler/30GunlukProgram/Frame 6975 (9).jpg',  // 10
    'assets/images/resimler/30GunlukProgram/Frame 6975 (10).jpg', // 11
    'assets/images/resimler/30GunlukProgram/Frame 6975 (11).jpg', // 12
    'assets/images/resimler/30GunlukProgram/Frame 6975 (12).jpg', // 13
    'assets/images/resimler/30GunlukProgram/Frame 6975 (13).jpg', // 14
    'assets/images/resimler/30GunlukProgram/Frame 6975 (14).jpg', // 15
    'assets/images/resimler/30GunlukProgram/Frame 6975 (15).jpg', // 16
    'assets/images/resimler/30GunlukProgram/Frame 6975 (16).jpg', // 17
    'assets/images/resimler/30GunlukProgram/Frame 6975 (17).jpg', // 18
    'assets/images/resimler/30GunlukProgram/Frame 6975 (18).jpg', // 19
    // 20–30: ilk 10 görsel döngüyle (1–10)
    'assets/images/resimler/30GunlukProgram/Frame 6975.jpg',       // 20
    'assets/images/resimler/30GunlukProgram/Frame 6975 (1).jpg',  // 21
    'assets/images/resimler/30GunlukProgram/Frame 6975 (2).jpg',  // 22
    'assets/images/resimler/30GunlukProgram/Frame 6975 (3).jpg',  // 23
    'assets/images/resimler/30GunlukProgram/Frame 6975 (4).jpg',  // 24
    'assets/images/resimler/30GunlukProgram/Frame 6975 (5).jpg',  // 25
    'assets/images/resimler/30GunlukProgram/Frame 6975 (6).jpg',  // 26
    'assets/images/resimler/30GunlukProgram/Frame 6975 (7).jpg',  // 27
    'assets/images/resimler/30GunlukProgram/Frame 6975 (8).jpg',  // 28
    'assets/images/resimler/30GunlukProgram/Frame 6975 (9).jpg',  // 29
    'assets/images/resimler/30GunlukProgram/Frame 6975.jpg',       // 30 (ilk görsel)
  ];

  List<WorkoutDay> get _workouts => List.generate(30, (index) {
        final dayNumber = index + 1;
        final status = dayNumber <= 2
            ? WorkoutStatus.completed
            : dayNumber == 3
                ? WorkoutStatus.current
                : WorkoutStatus.locked;

        String title;
        if (dayNumber == 1) {
          title = '1. Gün: Aktivasyon yap';
        } else if (dayNumber == 2) {
          title = '2. Gün: Kontrol';
        } else if (dayNumber == 3) {
          title = '3. Gün: Yakıcı';
        } else if (dayNumber == 4) {
          title = '4. Gün: Aktif Dinlenme';
        } else if (dayNumber == 5) {
          title = '5. Gün: Güçlendirme';
        } else if (dayNumber == 6) {
          title = '6. Gün: Kontrol+Oblik';
        } else if (dayNumber == 7) {
          title = '7. Gün: Aktif Dinlenme';
          } else if (dayNumber == 8) {
          title = '8. Gün: Aktif Dinlenme';
          } else if (dayNumber == 9) {
          title = '9. Gün: Core Güçlendirme';
          } else if (dayNumber == 10) {
          title = '10. Gün: Kontrol + Oblik';
          } else if (dayNumber == 11) {
          title = '11. Gün: Yakıcı+Dayanıklılık';
          } else if (dayNumber == 12) {
          title = '12. Gün: Aktif Dinlenme';
          } else if (dayNumber == 13) {
          title = '13. Gün: Core Güç + Kontrol';
          } else if (dayNumber == 14) {
          title = '14. Gün: Alt Karın + Oblik';
          } else if (dayNumber == 15) {
          title = '15. Gün: Yakıcı(Hafta finali)';
          } else if (dayNumber == 16) {
          title = '16. Gün: Aktif Dinlenme';
          } else if (dayNumber == 17) {
          title = '17. Gün: Core Dayanıklılık';
          } else if (dayNumber == 18) {
          title = '18. Gün: Alt Karın + Oblik';
          } else if (dayNumber == 19) {
          title = '19. Gün: Yakıcı Kontrol';
        } else {
          title = '$dayNumber. Gün Antrenman';
        }

        // 30GunlukProgram: Frame 6975.jpg = 1. gün, Frame 6975 (1).jpg = 2. gün, ... (19 görsel; 20–30 son görsel tekrarlanır)
        final thumbnail = _programThumbnails[dayNumber - 1];

        return WorkoutDay(
          title: title,
          duration: '30 Dakika',
          thumbnailAsset: thumbnail,
          status: status,
        );
      });

  @override
  Widget build(BuildContext context) {
    final workouts = _workouts;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        _ProgramHeader(
          size: size,
          onBack: onBack,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            itemCount: workouts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final day = workouts[index];
              final dayNumber = index + 1;
              final bool isFirst = index == 0;
              final bool isLast = index == workouts.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TimelineIndicator(
                    status: day.status,
                    isFirst: isFirst,
                    isLast: isLast,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WorkoutCard(
                      day: day,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => WorkoutDayDetailPage(
                              day: day,
                              dayNumber: dayNumber,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProgramHeader extends StatelessWidget {
  final Size size;
  final VoidCallback? onBack;

  const _ProgramHeader({
    required this.size,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final w = size.width;
    return SizedBox(
      height: 338,
      width: w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            height: 338,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: Image.asset(
                'assets/images/resimler/antrenman1.jpg',
                width: w,
                height: 338,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 18,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _backIconButton(context),
                const SizedBox(width: 24),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '30 Günlük',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 22 / 16,
                    letterSpacing: 0,
                    color: const Color(0xFF00EF5B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Karın Kası Programı',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 22 / 18,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _backIconButton(BuildContext context) {
    return IconButton(
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
      onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 25, minHeight: 24),
      style: IconButton.styleFrom(
        minimumSize: const Size(25, 24),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class TimelineIndicator extends StatelessWidget {
  final WorkoutStatus status;
  final bool isFirst;
  final bool isLast;

  const TimelineIndicator({
    super.key,
    required this.status,
    required this.isFirst,
    required this.isLast,
  });

  Color get _activeColor {
    switch (status) {
      case WorkoutStatus.completed:
        return const Color(0xFF3CF278);
      case WorkoutStatus.current:
        return const Color(0xFF2F80ED);
      case WorkoutStatus.locked:
        return const Color(0xFFBDBDBD);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isFirst)
          SizedBox(
            width: 2,
            height: 14,
            child: FittedBox(
              fit: BoxFit.fill,
              child: SvgPicture.asset(
                'assets/images/icons/Line 34.svg',
                width: 1,
                height: 56,
              ),
            ),
          ),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: _activeColor,
              width: status == WorkoutStatus.current ? 2.2 : 1.5,
            ),
          ),
          child: _buildInnerIcon(),
        ),
        if (!isLast)
          SizedBox(
            width: 2,
            height: 48,
            child: FittedBox(
              fit: BoxFit.fill,
              child: SvgPicture.asset(
                'assets/images/icons/Line 34.svg',
                width: 1,
                height: 56,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInnerIcon() {
    switch (status) {
      case WorkoutStatus.completed:
        return SvgPicture.asset(
          'assets/images/icons/Ellipse 63.svg',
          width: 14,
          height: 14,
        );
      case WorkoutStatus.current:
        return SvgPicture.asset(
          'assets/images/icons/Ellipse 65.svg',
          width: 14,
          height: 14,
        );
      case WorkoutStatus.locked:
        return SvgPicture.asset(
          'assets/images/icons/Ellipse 65.svg',
          width: 14,
          height: 14,
        );
    }
  }
}

class WorkoutCard extends StatelessWidget {
  final WorkoutDay day;
  final VoidCallback? onTap;

  const WorkoutCard({
    super.key,
    required this.day,
    this.onTap,
  });

  bool get _isLocked => day.status == WorkoutStatus.locked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Ink(
          width: 331,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFEBEBEB),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: (day.title.startsWith('1. Gün') ||
                          day.title.startsWith('2. Gün') ||
                          day.title.startsWith('3. Gün') ||
                          day.title.startsWith('4. Gün') ||
                          day.title.startsWith('5. Gün') ||
                          day.title.startsWith('6. Gün'))
                      ? const BorderRadius.only(
                          topRight: Radius.circular(3),
                          bottomRight: Radius.circular(3),
                        )
                      : BorderRadius.circular(12),
                  child: SizedBox(
                    width: (day.title.startsWith('1. Gün') ||
                            day.title.startsWith('2. Gün') ||
                            day.title.startsWith('3. Gün') ||
                            day.title.startsWith('4. Gün') ||
                            day.title.startsWith('5. Gün') ||
                            day.title.startsWith('6. Gün'))
                        ? 115
                        : 100,
                    height: (day.title.startsWith('1. Gün') ||
                            day.title.startsWith('2. Gün') ||
                            day.title.startsWith('3. Gün') ||
                            day.title.startsWith('4. Gün') ||
                            day.title.startsWith('5. Gün') ||
                            day.title.startsWith('6. Gün'))
                        ? 70
                        : 80,
                    child: Image.asset(
                      day.thumbnailAsset,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.title,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 22 / 14,
                          letterSpacing: 0,
                          color: const Color(0xFF000000),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: Color(0xFF7B7B7B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            day.duration,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 19.32 / 12,
                              letterSpacing: 0,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (_isLocked)
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 18,
                    color: Color(0xFFBDBDBD),
                  ),
              ],
            ),
          ),
        ),
      );
  }
}

class WorkoutDayDetailPage extends StatelessWidget {
  final WorkoutDay day;
  final int dayNumber;

  const WorkoutDayDetailPage({
    super.key,
    required this.day,
    required this.dayNumber,
  });

  String _thumbnailForExercise(_WorkoutExercise exercise) {
    if (exercise.name == 'Toe Touch Crunch') {
      return 'assets/images/resimler/1GunlukAktivasyon/Frame 6975 (1).jpg';
    } else if (exercise.name == 'Bent Knee Leg Raise') {
      return 'assets/images/resimler/1GunlukAktivasyon/Frame 6975 (4).jpg';
    } else if (exercise.name == 'Lying Knee Raise') {
      return 'assets/images/resimler/egzersizler/lyingkneeraise.jpg';
    } else if (exercise.name == 'Heel Touch') {
      return 'assets/images/resimler/egzersizler/heeltouch.jpg';
    } else if (exercise.name == 'Standing Side Crunch') {
      return 'assets/images/resimler/egzersizler/standingsidecrunch.jpg';
    } else if (exercise.name == 'Forearm Plank') {
      return 'assets/images/resimler/egzersizler/forearmplank.jpg';
    } else if (exercise.name == 'Mountain Climber' ||
        exercise.name == 'Mountain Climber (orta tempo)' ||
        exercise.name == 'Mountain Climber (orta–hızlı tempo)') {
      return 'assets/images/resimler/egzersizler/mountainclimber.jpg';
    } else if (exercise.name == 'Bicycle Crunch') {
      return 'assets/images/resimler/egzersizler/bicyclecrunch.jpg';
    } else if (exercise.name == 'Dead Bug') {
      return 'assets/images/resimler/egzersizler/deadbug.jpg';
    } else if (exercise.name == 'Double Crunch') {
      return 'assets/images/resimler/egzersizler/doublecrunch.jpg';
    } else if (exercise.name == 'Flutter Kicks') {
      return 'assets/images/resimler/egzersizler/flutterkicks.jpg';
    } else if (exercise.name == 'High Knees') {
      return 'assets/images/resimler/egzersizler/highknees.jpg';
    } else if (exercise.name == 'High Plank Knee Drive') {
      return 'assets/images/resimler/egzersizler/highplankkneedrive.jpg';
    } else if (exercise.name == 'Jackknife') {
      return 'assets/images/resimler/egzersizler/jackknife.jpg';
    } else if (exercise.name == 'Leg Raise (düz bacak)') {
      return 'assets/images/resimler/egzersizler/legraise.jpg';
    } else if (exercise.name == 'Lying Leg Hold') {
      return 'assets/images/resimler/egzersizler/lyingleghold.jpg';
    } else if (exercise.name == 'Oblique V-Up') {
      return 'assets/images/resimler/egzersizler/obliquevup.jpg';
    } else if (exercise.name == 'Plank Hip Dip') {
      return 'assets/images/resimler/egzersizler/plankhipdip.jpg';
    } else if (exercise.name == 'Plank Shoulder Tap') {
      return 'assets/images/resimler/egzersizler/plankshouldertap.jpg';
    } else if (exercise.name == 'Reach Up Crunch') {
      return 'assets/images/resimler/egzersizler/reachupcrunch.jpg';
    } else if (exercise.name == 'Reverse Crunch') {
      return 'assets/images/resimler/egzersizler/reversecrunch.jpg';
    } else if (exercise.name == 'Russian Twist') {
      return 'assets/images/resimler/egzersizler/russiantwist.jpg';
    } else if (exercise.name == 'Scissor Kicks') {
      return 'assets/images/resimler/egzersizler/scissorkicks.jpg';
    } else if (exercise.name == 'Seated Twist') {
      return 'assets/images/resimler/egzersizler/seatedtwist.jpg';
    } else if (exercise.name == 'Side Crunch') {
      return 'assets/images/resimler/egzersizler/sidecrunch.jpg';
    } else if (exercise.name == 'Side Plank Reach') {
      return 'assets/images/resimler/egzersizler/sideplankreach.jpg';
    } else if (exercise.name == 'Sit-Up') {
      return 'assets/images/resimler/egzersizler/sit-up.jpg';
    } else if (exercise.name == 'Standing Oblique Crunch') {
      return 'assets/images/resimler/egzersizler/standingobliquecrunch.jpg';
    } else if (exercise.name == 'V-Up') {
      return 'assets/images/resimler/egzersizler/v-up.jpg';
    } else if (exercise.name == 'Cross Crunch') {
      return 'assets/images/resimler/egzersizler/crosscrunch.jpg';
    }
    // Varsayılan görsel
    return 'assets/images/resimler/1GunlukAktivasyon/Frame 6975.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final List<_WorkoutExercise> exercises;

    if (dayNumber == 2) {
      // Gün 2 – Kontrol
      exercises = const [
        _WorkoutExercise(
          name: 'Sit-Up',
          repeatInfo: '3 set × 15 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Cross Crunch',
          repeatInfo: '3 set × 20 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Leg Raise',
          repeatInfo: '3 set × 12 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Reverse Crunch',
          repeatInfo: '3 set × 15 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Bicycle Crunch',
          repeatInfo: '3 set × 20 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Crunch',
          repeatInfo: '3 set × 15 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Plank Shoulder Tap',
          repeatInfo: '3 set × 20 tekrar (toplam)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Dead Bug',
          repeatInfo: '3 set × 20 tekrar (toplam)',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 3) {
      // Gün 3 – Yakıcı
      exercises = const [
        _WorkoutExercise(
          name: 'V-Up',
          repeatInfo: '3 set × 12 tekrar',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Double Crunch',
          repeatInfo: '3 set × 15 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Flutter Kicks',
          repeatInfo: '3 set × 40 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Scissor Kicks',
          repeatInfo: '3 set × 40 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Russian Twist',
          repeatInfo: '3 set × 20 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Oblique V-Up',
          repeatInfo: '3 set × 12 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Plank',
          repeatInfo: '3 set × 25–30 saniye (her iki taraf)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Knees',
          repeatInfo: '3 set × 40 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 4) {
      // Gün 4 – Aktif Dinlenme
      exercises = const [
        _WorkoutExercise(
          name: 'Aktif Dinlenme',
          repeatInfo: 'Bugün karın antrenmanı yok.',
          restInfo: 'Vücudun toparlanıyor, güçleniyor.',
        ),
      ];
    } else if (dayNumber == 5) {
      // Gün 5 – Güçlendirme
      exercises = const [
        _WorkoutExercise(
          name: 'Crunch',
          repeatInfo: '3 set × 25 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Reach Up Crunch',
          repeatInfo: '3 set × 20 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Leg Raise (düz bacak)',
          repeatInfo: '3 set × 15 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Reverse Crunch',
          repeatInfo: '3 set × 18 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Heel Touch',
          repeatInfo: '3 set × 24 tekrar (toplam)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Standing Side Crunch',
          repeatInfo: '3 set × 24 tekrar (sağ + sol)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Forearm Plank',
          repeatInfo: '3 set × 40 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Mountain Climber (orta tempo)',
          repeatInfo: '3 set × 40 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 6) {
      // Gün 6 – Kontrol + Oblik
      exercises = const [
        _WorkoutExercise(
          name: 'Sit-Up',
          repeatInfo: '3 set × 18 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Cross Crunch',
          repeatInfo: '3 set × 24 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Bent Knee Leg Raise',
          repeatInfo: '3 set × 20 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Lying Knee Raise',
          repeatInfo: '3 set × 20 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Bicycle Crunch',
          repeatInfo: '3 set × 24 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Crunch',
          repeatInfo: '3 set × 18 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Plank Shoulder Tap',
          repeatInfo: '3 set × 24 tekrar (toplam)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Dead Bug',
          repeatInfo: '3 set × 24 tekrar (toplam)',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 7) {
      // Gün 7 – Yakıcı (Hafta Finali)
      exercises = const [
        _WorkoutExercise(
          name: 'V-Up',
          repeatInfo: '3 set × 15 tekrar',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Double Crunch',
          repeatInfo: '3 set × 18 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Flutter Kicks',
          repeatInfo: '3 set × 45 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Scissor Kicks',
          repeatInfo: '3 set × 45 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Russian Twist',
          repeatInfo: '3 set × 30 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Oblique V-Up',
          repeatInfo: '3 set × 15 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Plank',
          repeatInfo: '3 set × 30 saniye (her iki taraf)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Knees',
          repeatInfo: '3 set × 45 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 8) {
      // Gün 8 – Aktif Dinlenme
      exercises = const [
        _WorkoutExercise(
          name: 'Aktif Dinlenme',
          repeatInfo: 'Bugün karın antrenmanı yok.',
          restInfo: 'Vücudun toparlanıyor, güçleniyor.',
        ),
      ];
    } else if (dayNumber == 9) {
      // Gün 9 – Core Güçlendirme
      exercises = const [
        _WorkoutExercise(
          name: 'Crunch',
          repeatInfo: '3 set × 30 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Toe Touch Crunch',
          repeatInfo: '3 set × 20 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Leg Raise (düz bacak)',
          repeatInfo: '3 set × 18 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Reverse Crunch',
          repeatInfo: '3 set × 20 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Heel Touch',
          repeatInfo: '3 set × 30 tekrar (toplam)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Standing Side Crunch',
          repeatInfo: '3 set × 30 tekrar (sağ + sol)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Forearm Plank',
          repeatInfo: '3 set × 45 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Mountain Climber (orta tempo)',
          repeatInfo: '3 set × 45 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 10) {
      // Gün 10 – Kontrol + Oblik Odak
      exercises = const [
        _WorkoutExercise(
          name: 'Sit-Up',
          repeatInfo: '3 set × 20 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Cross Crunch',
          repeatInfo: '3 set × 30 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Bent Knee Leg Raise',
          repeatInfo: '3 set × 25 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Lying Knee Raise',
          repeatInfo: '3 set × 25 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Bicycle Crunch',
          repeatInfo: '3 set × 30 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Crunch',
          repeatInfo: '3 set × 20 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Plank Shoulder Tap',
          repeatInfo: '3 set × 30 tekrar (toplam)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Dead Bug',
          repeatInfo: '3 set × 30 tekrar (toplam)',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 11) {
      // Gün 11 – Yakıcı + Dayanıklılık
      exercises = const [
        _WorkoutExercise(
          name: 'V-Up',
          repeatInfo: '3 set × 18 tekrar',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Double Crunch',
          repeatInfo: '3 set × 20 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Flutter Kicks',
          repeatInfo: '3 set × 60 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Scissor Kicks',
          repeatInfo: '3 set × 60 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Russian Twist',
          repeatInfo: '3 set × 40 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Oblique V-Up',
          repeatInfo: '3 set × 18 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Plank',
          repeatInfo: '3 set × 35–40 saniye (her iki taraf)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Knees',
          repeatInfo: '3 set × 60 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 12) {
      // Gün 12 – Aktif Dinlenme
      exercises = const [
        _WorkoutExercise(
          name: 'Aktif Dinlenme',
          repeatInfo: 'Bugün karın antrenmanı yok.',
          restInfo: 'Vücudun toparlanıyor, güçleniyor.',
        ),
      ];
    } else if (dayNumber == 13) {
      // Gün 13 – Core Güç + Kontrol
      exercises = const [
        _WorkoutExercise(
          name: 'Crunch',
          repeatInfo: '3 set × 35 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Reach Up Crunch',
          repeatInfo: '3 set × 25 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Leg Raise (düz bacak)',
          repeatInfo: '3 set × 20 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Lying Leg Hold',
          repeatInfo: '3 set × 25 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Heel Touch',
          repeatInfo: '3 set × 35 tekrar (toplam)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Standing Oblique Crunch',
          repeatInfo: '3 set × 30 tekrar (sağ + sol)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Plank',
          repeatInfo: '3 set × 60 saniye',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Mountain Climber (orta tempo)',
          repeatInfo: '3 set × 60 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 14) {
      // Gün 14 – Alt Karın + Oblik Baskı
      exercises = const [
        _WorkoutExercise(
          name: 'Sit-Up',
          repeatInfo: '3 set × 22 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Pulse Crunch',
          repeatInfo: '3 set × 25 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Reverse Crunch',
          repeatInfo: '3 set × 22 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Scissor Kicks',
          repeatInfo: '3 set × 60 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Russian Twist',
          repeatInfo: '3 set × 45 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Crunch',
          repeatInfo: '3 set × 25 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Plank Hip Dip',
          repeatInfo: '3 set × 30 tekrar (toplam)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Plank Knee Drive',
          repeatInfo: '3 set × 45 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 15) {
      // Gün 15 – Yakıcı (Hafta Finali)
      exercises = const [
        _WorkoutExercise(
          name: 'V-Up',
          repeatInfo: '3 set × 20 tekrar',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Double Crunch',
          repeatInfo: '3 set × 22 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Flutter Kicks',
          repeatInfo: '3 set × 70 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Jackknife',
          repeatInfo: '3 set × 18 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Oblique V-Up',
          repeatInfo: '3 set × 20 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Seated Twist',
          repeatInfo: '3 set × 40 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Plank Reach',
          repeatInfo: '3 set × 35 saniye (her iki taraf)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Knees',
          repeatInfo: '3 set × 70 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 16) {
      // Gün 16 – Aktif Dinlenme
      exercises = const [
        _WorkoutExercise(
          name: 'Aktif Dinlenme',
          repeatInfo: 'Bugün karın antrenmanı yok.',
          restInfo: 'Vücudun toparlanıyor, güçleniyor.',
        ),
      ];
    } else if (dayNumber == 17) {
      // Gün 17 – Core Dayanıklılık
      exercises = const [
        _WorkoutExercise(
          name: 'Crunch',
          repeatInfo: '4 set × 35 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Reach Up Crunch',
          repeatInfo: '3 set × 30 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Leg Raise (düz bacak)',
          repeatInfo: '3 set × 22 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Lying Knee Raise',
          repeatInfo: '3 set × 30 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Heel Touch',
          repeatInfo: '3 set × 40 tekrar (toplam)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Standing Side Crunch',
          repeatInfo: '3 set × 35 tekrar (sağ + sol)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Forearm Plank',
          repeatInfo: '3 set × 75 saniye',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Mountain Climber (orta–hızlı tempo)',
          repeatInfo: '3 set × 75 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 18) {
      // Gün 18 – Alt Karın + Oblik Baskı
      exercises = const [
        _WorkoutExercise(
          name: 'Sit-Up',
          repeatInfo: '4 set × 25 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Pulse Crunch',
          repeatInfo: '3 set × 30 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Reverse Crunch',
          repeatInfo: '3 set × 25 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Scissor Kicks',
          repeatInfo: '3 set × 75 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Russian Twist',
          repeatInfo: '3 set × 50 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Crunch',
          repeatInfo: '3 set × 30 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Plank Hip Dip',
          repeatInfo: '3 set × 40 tekrar (toplam)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Plank Knee Drive',
          repeatInfo: '3 set × 60 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 19) {
      // Gün 19 – Yakıcı Kontrol Günü
      exercises = const [
        _WorkoutExercise(
          name: 'V-Up',
          repeatInfo: '4 set × 22 tekrar',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Double Crunch',
          repeatInfo: '3 set × 25 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Flutter Kicks',
          repeatInfo: '3 set × 80 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Jackknife',
          repeatInfo: '3 set × 22 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Oblique V-Up',
          repeatInfo: '3 set × 25 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Seated Twist',
          repeatInfo: '3 set × 50 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Plank Reach',
          repeatInfo: '3 set × 45 saniye (her iki taraf)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Knees',
          repeatInfo: '3 set × 80 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 20) {
      // Gün 20 – Aktif Dinlenme
      exercises = const [
        _WorkoutExercise(
          name: 'Aktif Dinlenme',
          repeatInfo: 'Bugün karın antrenmanı yok.',
          restInfo: 'Vücudun toparlanıyor, güçleniyor.',
        ),
      ];
    } else if (dayNumber == 21) {
      // Gün 21 – Core Güç + Süre
      exercises = const [
        _WorkoutExercise(
          name: 'Crunch',
          repeatInfo: '4 set × 40 tekrar',
          restInfo: 'Set arası: 20–25 sn',
        ),
        _WorkoutExercise(
          name: 'Reach Up Crunch',
          repeatInfo: '3 set × 35 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Leg Raise (düz bacak)',
          repeatInfo: '3 set × 25 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Lying Leg Hold',
          repeatInfo: '3 set × 35 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Heel Touch',
          repeatInfo: '3 set × 45 tekrar (toplam)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Standing Side Crunch',
          repeatInfo: '3 set × 40 tekrar (sağ + sol)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Forearm Plank',
          repeatInfo: '3 set × 90 saniye',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Mountain Climber (orta–hızlı tempo)',
          repeatInfo: '3 set × 90 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 22) {
      // Gün 22 – Alt Karın & Oblik Netleştirme
      exercises = const [
        _WorkoutExercise(
          name: 'Sit-Up',
          repeatInfo: '4 set × 30 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Pulse Crunch',
          repeatInfo: '3 set × 35 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Reverse Crunch',
          repeatInfo: '3 set × 30 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Scissor Kicks',
          repeatInfo: '3 set × 90 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Russian Twist',
          repeatInfo: '3 set × 60 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Crunch',
          repeatInfo: '3 set × 35 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Plank Hip Dip',
          repeatInfo: '3 set × 50 tekrar (toplam)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Plank Knee Drive',
          repeatInfo: '3 set × 75 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 23) {
      // Gün 23 – Yakıcı Dayanıklılık (Final Öncesi)
      exercises = const [
        _WorkoutExercise(
          name: 'V-Up',
          repeatInfo: '4 set × 25 tekrar',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Double Crunch',
          repeatInfo: '3 set × 30 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Flutter Kicks',
          repeatInfo: '3 set × 90 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Jackknife',
          repeatInfo: '3 set × 25 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Oblique V-Up',
          repeatInfo: '3 set × 30 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Seated Twist',
          repeatInfo: '3 set × 60 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Plank Reach',
          repeatInfo: '3 set × 55 saniye (her iki taraf)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Knees',
          repeatInfo: '3 set × 90 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 24) {
      // Gün 24 – Aktif Dinlenme
      exercises = const [
        _WorkoutExercise(
          name: 'Aktif Dinlenme',
          repeatInfo: 'Bugün karın antrenmanı yok.',
          restInfo: 'Vücudun toparlanıyor, güçleniyor.',
        ),
      ];
    } else if (dayNumber == 25) {
      // Gün 25 – Core Dayanıklılık Zirvesi
      exercises = const [
        _WorkoutExercise(
          name: 'Crunch',
          repeatInfo: '4 set × 45 tekrar',
          restInfo: 'Set arası: 20–25 sn',
        ),
        _WorkoutExercise(
          name: 'Reach Up Crunch',
          repeatInfo: '3 set × 40 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Leg Raise (düz bacak)',
          repeatInfo: '3 set × 28 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Lying Leg Hold',
          repeatInfo: '3 set × 45 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Heel Touch',
          repeatInfo: '3 set × 50 tekrar (toplam)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Standing Side Crunch',
          repeatInfo: '3 set × 45 tekrar (sağ + sol)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Forearm Plank',
          repeatInfo: '3 set × 100 saniye',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Mountain Climber (orta–hızlı tempo)',
          repeatInfo: '3 set × 100 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 26) {
      // Gün 26 – Alt Karın + Oblik Maksimum Hacim
      exercises = const [
        _WorkoutExercise(
          name: 'Sit-Up',
          repeatInfo: '4 set × 35 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Pulse Crunch',
          repeatInfo: '3 set × 40 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Reverse Crunch',
          repeatInfo: '3 set × 35 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Scissor Kicks',
          repeatInfo: '3 set × 100 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Russian Twist',
          repeatInfo: '3 set × 70 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Crunch',
          repeatInfo: '3 set × 40 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Plank Hip Dip',
          repeatInfo: '3 set × 60 tekrar (toplam)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Plank Knee Drive',
          repeatInfo: '3 set × 90 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 27) {
      // Gün 27 – Final Öncesi Yakıcı Kombin
      exercises = const [
        _WorkoutExercise(
          name: 'V-Up',
          repeatInfo: '4 set × 30 tekrar',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Double Crunch',
          repeatInfo: '3 set × 35 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Flutter Kicks',
          repeatInfo: '3 set × 100 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Jackknife',
          repeatInfo: '3 set × 30 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Oblique V-Up',
          repeatInfo: '3 set × 35 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Seated Twist',
          repeatInfo: '3 set × 70 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Plank Reach',
          repeatInfo: '3 set × 65 saniye (her iki taraf)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Knees',
          repeatInfo: '3 set × 100 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 28) {
      // Gün 28 – Aktif Dinlenme
      exercises = const [
        _WorkoutExercise(
          name: 'Aktif Dinlenme',
          repeatInfo: 'Bugün karın antrenmanı yok.',
          restInfo: 'Vücudun toparlanıyor, güçleniyor.',
        ),
      ];
    } else if (dayNumber == 29) {
      // Gün 29 – Final Güç Testi
      exercises = const [
        _WorkoutExercise(
          name: 'Crunch',
          repeatInfo: '4 set × 50 tekrar',
          restInfo: 'Set arası: 20–25 sn',
        ),
        _WorkoutExercise(
          name: 'Reach Up Crunch',
          repeatInfo: '3 set × 45 tekrar',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Leg Raise (düz bacak)',
          repeatInfo: '3 set × 30 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Lying Leg Hold',
          repeatInfo: '3 set × 60 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Heel Touch',
          repeatInfo: '3 set × 60 tekrar (toplam)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Standing Side Crunch',
          repeatInfo: '3 set × 50 tekrar (sağ + sol)',
          restInfo: 'Set arası: 25 sn',
        ),
        _WorkoutExercise(
          name: 'Forearm Plank',
          repeatInfo: '3 set × 120 saniye',
          restInfo: 'Set arası: 45 sn',
        ),
        _WorkoutExercise(
          name: 'Mountain Climber (orta–hızlı tempo)',
          repeatInfo: '3 set × 120 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else if (dayNumber == 30) {
      // Gün 30 – Final Burn & Kapanış
      exercises = const [
        _WorkoutExercise(
          name: 'V-Up',
          repeatInfo: '4 set × 35 tekrar',
          restInfo: 'Set arası: 40 sn',
        ),
        _WorkoutExercise(
          name: 'Double Crunch',
          repeatInfo: '3 set × 40 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Flutter Kicks',
          repeatInfo: '3 set × 120 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Jackknife',
          repeatInfo: '3 set × 35 tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Oblique V-Up',
          repeatInfo: '3 set × 40 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Seated Twist',
          repeatInfo: '3 set × 80 tekrar (sağ + sol)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Side Plank Reach',
          repeatInfo: '3 set × 75 saniye (her iki taraf)',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'High Knees',
          repeatInfo: '3 set × 120 saniye',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    } else {
      // Varsayılan (Gün 1 ve diğer günler için mevcut liste)
      exercises = const [
        _WorkoutExercise(
          name: 'Crunch',
          repeatInfo: '3 Set x 20 Tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Toe Touch Crunch',
          repeatInfo: '3 Set x 15 Tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Bent Knee Leg Raise',
          repeatInfo: '3 Set x 15 Tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Lying Knee Raise',
          repeatInfo: '3 Set x 15 Tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Heel Touch',
          repeatInfo: '3 Set x 20 Tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Standing Side Crunch',
          repeatInfo: '3 Set x 15 Tekrar',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Forearm Plank',
          repeatInfo: '3 Set x 30 sn',
          restInfo: 'Set arası: 30 sn',
        ),
        _WorkoutExercise(
          name: 'Mountain Climber',
          repeatInfo: '3 Set x 30 sn',
          restInfo: 'Set arası: 30 sn',
        ),
      ];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Üst görsel alanı + geri butonu
              SizedBox(
                height: 280,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        WorkoutProgramView._programThumbnails
                            [(dayNumber - 1).clamp(0, WorkoutProgramView._programThumbnails.length - 1)],
                        width: 390,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: const Color(0x61000000),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 12,
                        left: 16,
                        child: IconButton(
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
                          onPressed: () => Navigator.of(context).maybePop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 25,
                            minHeight: 24,
                          ),
                          style: IconButton.styleFrom(
                            minimumSize: const Size(25, 24),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // İçerik alanı — kart fotoğrafın üzerine taşar (negatif margin yerine translate)
              Transform.translate(
                offset: const Offset(0, -24),
                child: Container(
                  width: double.infinity,
                  height: 900,
                  decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x1A000000),
                      offset: const Offset(0, -2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              day.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                height: 22 / 20,
                                letterSpacing: 0,
                                color: const Color(0xFF100F0F),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.of(context).maybePop(),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Color(0xFF100F0F),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: const [
                            _InfoChip(label: '30 Dakika'),
                            _InfoChip(label: 'Bölge: Karın'),
                            _InfoChip(label: '8 Egzersiz'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 342,
                        height: 24,
                        child: Text(
                          'Program',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            height: 1.0, // 100% line-height
                            letterSpacing: 0,
                            color: const Color(0xFF100F0F),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width - 24,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var i = 0; i < exercises.length; i++) ...[
                                    _ExerciseDetailCard(
                                      exercise: exercises[i],
                                      thumbnailAsset:
                                          _thumbnailForExercise(exercises[i]),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: 342,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const WorkoutPlayerPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00EF5B),
                              foregroundColor: const Color(0xFF0A0A0A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 151,
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      'Antrenmana Başla',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        height: 1.0, // 100% line-height
                                        letterSpacing: -0.011 * 16, // -1.1%
                                        color: const Color(0xFF0A0A0A),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Transform.rotate(
                                  angle: -pi / 2,
                                  child: SvgPicture.asset(
                                    'assets/images/icons/iconstack.io - (Arrow Down).svg',
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.contain,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF0A0A0A),
                                      BlendMode.srcIn,
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
                ),
              ),
            ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _WorkoutBottomNavBar(),
    );
  }
}

class WorkoutPlayerPage extends StatefulWidget {
  const WorkoutPlayerPage({super.key});

  @override
  State<WorkoutPlayerPage> createState() => _WorkoutPlayerPageState();
}

class _WorkoutPlayerPageState extends State<WorkoutPlayerPage> {
  bool _isPlaying = false;
  double _progress = 0.25; // 0 - 1 arası, şimdilik sabit örnek

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Üstte egzersiz görseli / video alanı
          SizedBox(
            height: 320,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/resimler/Frame 7243.jpg',
                    fit: BoxFit.cover,
                  ),
                  // İleride backend'den gelecek video burada gösterilecek.
                  Positioned(
                    top: paddingTop + 12,
                    left: 8,
                    child: IconButton(
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
                      onPressed: () => Navigator.of(context).maybePop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 25,
                        minHeight: 24,
                      ),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(25, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Alt kart bölümü
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 68,
                        height: 22,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Crunch',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              height: 1.0,
                              letterSpacing: 0,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 342,
                        height: 18, // yükseklik + top boşluğu için biraz fazla
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            // Gri arka plan bar (SVG)
                            Positioned(
                              top: 3,
                              child: Container(
                                width: 342,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD5D5D5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/icons/Frame 7246.svg',
                                  width: 342,
                                  height: 12,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Yeşil dolu kısım
                            Positioned(
                              top: 3,
                              child: Container(
                                width: 342 * _progress,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00EF5B),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            // Daire (thumb)
                            Positioned(
                              top: 0,
                              left: (342 * _progress).clamp(0, 342 - 18),
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF05A642),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/icons/Ellipse 91.svg',
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            // Tıklanabilir alan
                            Positioned.fill(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onHorizontalDragUpdate: (details) {
                                  final box =
                                      context.findRenderObject() as RenderBox?;
                                  if (box == null) return;
                                  final localPos = box
                                      .globalToLocal(details.globalPosition);
                                  final dx = localPos.dx.clamp(0, 342);
                                  setState(() {
                                    _progress = dx / 342;
                                  });
                                },
                                onTapDown: (details) {
                                  final box =
                                      context.findRenderObject() as RenderBox?;
                                  if (box == null) return;
                                  final localPos = box
                                      .globalToLocal(details.globalPosition);
                                  final dx = localPos.dx.clamp(0, 342);
                                  setState(() {
                                    _progress = dx / 342;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 74,
                        height: 12,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'kalan süre 6:58',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w300,
                              fontSize: 10,
                              height: 1.0,
                              letterSpacing: 0,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          '10:00',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                            color: const Color(0xFF00B341),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _roundControlButton(
                            onTap: () {},
                            angle: 0, // sola baksın (orijinal yön)
                          ),
                          const SizedBox(width: 24),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPlaying = !_isPlaying;
                              });
                            },
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00EF5B),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(
                                _isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 36,
                                color: const Color(0xFF0A0A0A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          _roundControlButton(
                            onTap: () {},
                            angle: pi, // sağa baksın (ters yönde)
                          ),
                        ],
                      ),
                      const SizedBox(height: 140),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 1/8
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: const Color(0xFF7B7B7B),
                              ),
                              children: const [
                                TextSpan(
                                  text: '1',
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                TextSpan(text: '/8'),
                              ],
                            ),
                          ),
                          // Sıradaki Hareket
                          SizedBox(
                            width: 101,
                            height: 15,
                            child: Text(
                              'Sıradaki Hareket',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 1.0,
                                letterSpacing: 0,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ),
                          // Bent Knee Leg Raise border
                          Container(
                            width: 156,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFEBEBEB),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                      'assets/images/resimler/Frame 7243.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 148,
                                      height: 13,
                                      child: Text(
                                        'Bent Knee Leg Raise',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          height: 1.0,
                                          letterSpacing: 0,
                                          color: const Color(0xFF100F0F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundControlButton({
    required VoidCallback onTap,
    required double angle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 31.764705657958984,
        decoration: const BoxDecoration(), // arka plan rengi yok, şeffaf
        padding: const EdgeInsets.all(2.54),
        child: Transform.rotate(
          angle: angle,
          child: SvgPicture.asset(
            'assets/images/icons/Frame 7252.svg',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _WorkoutExercise {
  final String name;
  final String repeatInfo;
  final String restInfo;

  const _WorkoutExercise({
    required this.name,
    required this.repeatInfo,
    required this.restInfo,
  });
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFEBEBEB),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (label == '30 Dakika') ...[
            SvgPicture.asset(
              'assets/images/icons/iconstack.io - (Clock).svg',
              width: 18,
              height: 18,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
          ] else if (label.startsWith('Bölge')) ...[
            SvgPicture.asset(
              'assets/images/icons/iconstack.io - (Dumbbell Large).svg',
              width: 18,
              height: 18,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
          ] else if (label.contains('Egzersiz')) ...[
            SvgPicture.asset(
              'assets/images/icons/iconstack.io - (Back Muscle Body).svg',
              width: 18,
              height: 18,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.1,
                letterSpacing: 0,
                color: const Color(0xFF100F0F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseDetailCard extends StatelessWidget {
  final _WorkoutExercise exercise;
  final String thumbnailAsset;

  const _ExerciseDetailCard({
    super.key,
    required this.exercise,
    required this.thumbnailAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEBEBEB),
          width: 1,
        ),
      ),
      height: 88,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 76,
                height: 64,
                child: Image.asset(
                  thumbnailAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    exercise.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      height: 1.1,
                      letterSpacing: 0,
                      color: const Color(0xFF100F0F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.repeatInfo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.1,
                      letterSpacing: 0,
                      color: const Color(0xFF100F0F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    exercise.restInfo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.1,
                      letterSpacing: 0,
                      color: const Color(0xFF686868),
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
}

class _WorkoutBottomNavBar extends StatelessWidget {
  const _WorkoutBottomNavBar();

  @override
  Widget build(BuildContext context) {
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
              selectedLabelStyle: GoogleFonts.manrope(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 22 / 12,
                color: const Color(0xFF06C44F),
              ),
              unselectedLabelStyle: GoogleFonts.manrope(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 22 / 12,
                color: const Color(0xFF323232),
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) {
              if (index == 1) return;
              if (index == 0 || index == 2) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => HomeView(
                      initialTabIndex: index,
                    ),
                  ),
                  (route) => false,
                );
              }
            },
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
                label: 'Anasayfa',
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
                label: 'Antrenman',
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
                label: 'İlerleme',
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
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

