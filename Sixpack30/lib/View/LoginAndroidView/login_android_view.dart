import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sixpack30/Colors/app_colors.dart';
import 'package:sixpack30/View/HedefOdakView/hedef_odak_view.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/Text/height.dart';
import 'package:sixpack30/Text/width.dart';

class LoginAndroidView extends StatelessWidget {
  const LoginAndroidView({super.key});

  static const double _designWidth = 390;
  static const double _baseImageSize = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final imageSize =
                _baseImageSize * (screenWidth / _designWidth).clamp(0.8, 1.2);

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/splash.png',
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(height: 16),
                    const Text(
                      'Hoşgeldin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFont.manrope,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                        height: AppTextHeight.full,
                        letterSpacing: AppTextWidth.normal,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Seni tekrar görmek güzel! Giriş yaparak\nter dökmeye hazır mısın?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFont.primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: AppTextWidth.normal,
                        color: const Color(0xFF464646),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: SizedBox(
                        width: 342,
                        child: _SocialButton(
                          label: 'Google ile giriş yapın',
                          leadingIconPath:
                              'assets/images/icons/google.svg',
                          height: 44,
                          borderRadius: 20,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HedefOdakView(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: SizedBox(
                        width: 342,
                        child: Row(
                          children: [
                            Expanded(
                              child: _SocialButton(
                                label: 'Apple',
                                leadingIconPath:
                                    'assets/images/icons/Vector (1).svg',
                                height: 44,
                                borderRadius: 20,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const HedefOdakView(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _SocialButton(
                                label: 'Facebook',
                                leadingIconPath:
                                    'assets/images/icons/Vector (2).svg',
                                height: 44,
                                borderRadius: 20,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const HedefOdakView(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const HedefOdakView(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/iconstack.io - (User Outline).svg',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Misafir Olarak Devam Et',
                            style: TextStyle(
                              fontFamily: AppFont.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: AppTextHeight.full,
                              letterSpacing: AppTextWidth.normal,
                              color: Color(0xFF464646),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _TermsText(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String? leadingIconPath;
  final double height;
  final double borderRadius;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.label,
    this.leadingIconPath,
    this.height = 48,
    this.borderRadius = 999,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Color(0xFF000000),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIconPath != null) ...[
              SvgPicture.asset(
                leadingIconPath!,
                width: 28,
                height: 28,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                fontFamily: AppFont.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                height: AppTextHeight.full,
                letterSpacing: AppTextWidth.normal,
                color: Color(0xFF0D0D0D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsText extends StatefulWidget {
  const _TermsText({
    this.onTapTerms,
    this.onTapPrivacy,
    this.onTapCookies,
  });

  final VoidCallback? onTapTerms;
  final VoidCallback? onTapPrivacy;
  final VoidCallback? onTapCookies;

  @override
  State<_TermsText> createState() => _TermsTextState();
}

class _TermsTextState extends State<_TermsText> {
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;
  late TapGestureRecognizer _cookiesRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = widget.onTapTerms;
    _privacyRecognizer = TapGestureRecognizer()..onTap = widget.onTapPrivacy;
    _cookiesRecognizer = TapGestureRecognizer()..onTap = widget.onTapCookies;
  }

  @override
  void didUpdateWidget(covariant _TermsText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _termsRecognizer.onTap = widget.onTapTerms;
    _privacyRecognizer.onTap = widget.onTapPrivacy;
    _cookiesRecognizer.onTap = widget.onTapCookies;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _cookiesRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(
      fontFamily: AppFont.montserrat,
      fontWeight: FontWeight.w500,
      fontSize: 10,
      height: AppTextHeight.full,
      letterSpacing: AppTextWidth.normal,
      color: Color(0xFF464646),
    );

    final linkStyle = baseStyle.copyWith(
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(
            text: 'SixPack30’ a kaydolmakla ',
          ),
          TextSpan(
            text: 'Hizmet Şartlarımızı',
            style: linkStyle,
            recognizer: _termsRecognizer,
          ),
          const TextSpan(
            text:
                ' kabul etmiş olursunuz. Verilerinizi nasıl işlediğimiz hakkında daha fazla bilgi edinmek için ',
          ),
          TextSpan(
            text: 'Gizlilik Politikamızı',
            style: linkStyle,
            recognizer: _privacyRecognizer,
          ),
          const TextSpan(
            text: ' ve ',
          ),
          TextSpan(
            text: 'Çerez Politikamızı',
            style: linkStyle,
            recognizer: _cookiesRecognizer,
          ),
          const TextSpan(
            text: ' inceleyiniz.',
          ),
        ],
      ),
    );
  }
}

