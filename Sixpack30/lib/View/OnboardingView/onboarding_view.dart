import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sixpack30/Colors/app_colors.dart';
import 'package:sixpack30/Components/Buttons/primary_button.dart';
import 'package:sixpack30/View/LoginAndroidView/login_android_view.dart';
import 'package:sixpack30/View/LoginView/login_view.dart';
import 'package:sixpack30/View/Onboarding2View/onboarding2_view.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/Text/height.dart';
import 'package:sixpack30/Text/size.dart';
import 'package:sixpack30/Text/width.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    const designWidth = 390.0;
    const designHeight = 844.0;
    const skipWidthDesign = 37.0;
    const skipHeightDesign = 22.0;
    const skipTopDesign = 81.0;
    const skipLeftDesign = 319.0;

    final size = MediaQuery.of(context).size;
    final skipWidth = size.width * (skipWidthDesign / designWidth);
    final skipHeight = size.height * (skipHeightDesign / designHeight);
    final skipTop = size.height * (skipTopDesign / designHeight);
    final skipRight = size.width *
        ((designWidth - skipLeftDesign - skipWidthDesign) / designWidth);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/resimler/Onboarding.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: AppColors.onboardingOverlay,
          ),
          Positioned(
            top: skipTop,
            right: skipRight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                final Widget target;
                if (kIsWeb) {
                  target = const LoginView();
                } else if (Platform.isIOS) {
                  target = const LoginView();
                } else {
                  target = const LoginAndroidView();
                }

                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (_, animation, __) => target,
                    transitionsBuilder: (_, animation, __, child) {
                      final offsetAnimation = Tween(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).chain(
                        CurveTween(curve: Curves.easeInOut),
                      ).animate(animation);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                  (route) => false,
                );
              },
              child: SizedBox(
                width: skipWidth,
                height: skipHeight,
                child: Center(
                  child: Text(
                    'Atla',
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: AppFontSize.onboardingSkip,
                      height: AppTextHeight.full,
                      letterSpacing: AppTextWidth.normal,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '30 Günde',
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w700,
                        fontSize: AppFontSize.onboardingTitle,
                        height: AppTextHeight.full,
                        letterSpacing: AppTextWidth.onboardingTitle,
                        color: AppColors.onboardingTitleAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Karın Kasına Giden Yol',
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w700,
                        fontSize: AppFontSize.onboardingTitle,
                        height: AppTextHeight.full,
                        letterSpacing: AppTextWidth.onboardingTitle,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SixPack30, karın kaslarını görünür hale getirmek için özel olarak tasarlanmış 30 günlük ev egzersiz programı sunar.\nEkipmansız, kısa ve etkili.',
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFontSize.body,
                        height: AppTextHeight.onboardingBody,
                        letterSpacing: AppTextWidth.onboardingTitle,
                        color: AppColors.onboardingSubtitle,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        _PageDot(isActive: true),
                        const SizedBox(width: 8),
                        const _PageDot(isActive: false),
                        const SizedBox(width: 8),
                        const _PageDot(isActive: false),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PrimaryButton(
                        label: 'Devam Et',
                        width: 342,
                        height: 44,
                        borderRadius: 10,
                        backgroundColor: const Color(0xFF00EF5B),
                        textColor: AppColors.onboardingButtonText,
                        trailingIcon: SvgPicture.asset(
                          'assets/images/icons/iconstack.io - (Arrow Down).svg',
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            AppColors.onboardingButtonText,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                              pageBuilder: (_, animation, __) =>
                                  const Onboarding2View(),
                              transitionsBuilder: (_, animation, __, child) {
                                final offsetAnimation = Tween(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).chain(
                                  CurveTween(curve: Curves.easeInOut),
                                ).animate(animation);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
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

class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isActive ? 24 : 8,
      height: 6,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.onboardingTitleAccent
            : AppColors.onboardingSubtitle.withOpacity(0.6),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

