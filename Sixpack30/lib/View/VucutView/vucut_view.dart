import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/View/VucutOzellikleriView/vucut_ozellikleri_view.dart';

class Onboarding2View extends StatelessWidget {
  const Onboarding2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const VucutOzellikleriView(),
            ),
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
            'assets/images/resimler/vucut.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const ColoredBox(
              color: Color(0xFF333333),
              child: Center(
                child: Icon(Icons.image_not_supported, color: Colors.white),
              ),
            ),
          ),
          Container(
            color: const Color(0xA8000000), // #000000A8 66%
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 246.91,
                  height: 49,
                  child: Text(
                    'Vücut',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFont.montserrat,
                      fontWeight: FontWeight.w600,
                      fontSize: 40,
                      height: 1.0,
                      letterSpacing: 0.0,
                      color: Color(0xFFFFFFFF), // #FFFFFF
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }
}
