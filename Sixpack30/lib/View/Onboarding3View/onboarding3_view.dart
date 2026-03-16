import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sixpack30/Colors/app_colors.dart';
import 'package:sixpack30/Components/Buttons/primary_button.dart';
import 'package:sixpack30/View/LoginAndroidView/login_android_view.dart';
import 'package:sixpack30/View/LoginView/login_view.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/Text/height.dart';
import 'package:sixpack30/Text/size.dart';
import 'package:sixpack30/Text/width.dart';

class Onboarding3View extends StatelessWidget {
  const Onboarding3View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/resimler/Onboarding3.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          Container(
            color: const Color(0x0D000000),
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
                      'Günde Sadece',
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w700,
                        fontSize: AppFontSize.onboardingTitle,
                        height: AppTextHeight.full,
                        letterSpacing: AppTextWidth.onboardingTitle,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '10 Dakika',
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w700,
                        fontSize: AppFontSize.onboardingTitle,
                        height: AppTextHeight.full,
                        letterSpacing: AppTextWidth.onboardingTitle,
                        color: AppColors.onboardingTitleAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kısa ama hedefe odaklı antrenmanlar\nile core gücünü artır. Her gün bir\nadım at, 30 gün sonra sonuçları\naaynada gör.',
                      style: TextStyle(
                        fontFamily: AppFont.montserrat,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFontSize.body,
                        height: AppTextHeight.onboardingBody,
                        letterSpacing: AppTextWidth.onboardingTitle,
                        color: AppColors.onboardingSubtitle2,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: const [
                        _PageDot(isActive: false),
                        SizedBox(width: 8),
                        _PageDot(isActive: false),
                        SizedBox(width: 8),
                        _PageDot(isActive: true),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PrimaryButton(
                        label: 'Başlayın',
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
                          final Widget target;
                          if (kIsWeb) {
                            target = const LoginView();
                          } else if (Platform.isIOS) {
                            target = const LoginView();
                          } else {
                            target = const LoginAndroidView();
                          }

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => target),
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

