import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareAppView extends StatelessWidget {
  const ShareAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: Center(
        child: Container(
          width: 390,
          height: 894,
          decoration: const BoxDecoration(
            color: Color(0xFFFEFEFE),
          ),
          child: SafeArea(
            child: Padding(
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
                        onPressed: () => Navigator.of(context).pop(),
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
                              'Uygulamayı Paylaş',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
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
                  const SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: 217,
                      height: 196.2236,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Yeşil halka (arka plan)
                          SvgPicture.asset(
                            'assets/images/icons/Group 249.svg',
                            width: 217,
                            height: 196.2236,
                            fit: BoxFit.contain,
                          ),
                          // paylas.jpg görseli (alt sol tarafta, SVG içindeki dikdörtgene denk gelecek şekilde)
                          Positioned(
                            top: 144.667,
                            left: 3.07812,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/resimler/paylas.jpg',
                                width: 40.68988800048828,
                                height: 36.92230224609375,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 86.1846,
                            left: 30.7812,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Image.asset(
                                'assets/images/resimler/paylas4.jpg',
                                width: 32.22495651245117,
                                height: 29.241165161132812,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 111.578,
                            left: 174.678,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images/resimler/paylas2.jpg',
                                width: 42.32273864746094,
                                height: 38.40396499633789,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 125.429,
                            left: 102.344,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/resimler/paylas3.jpg',
                                width: 41.94622039794922,
                                height: 38.06230926513672,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16.16,
                            left: 14.59,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/resimler/paylas6.jpg',
                                width: 45.338321685791016,
                                height: 41.14033126831055,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 134.66,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                'assets/images/resimler/paylas5.jpg',
                                width: 36.07286071777344,
                                height: 32.73278045654297,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 320,
                          height: 42,
                          alignment: Alignment.center,
                          child: Text(
                            'Arkadaşlarını Davet Et',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              height: 1.0,
                              letterSpacing: 0,
                              color: const Color(0xFF0D0D0D),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 320,
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            'Arkadaşlarını davet et,\n birlikte güçlenin!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 1.0,
                              letterSpacing: 0,
                              color: const Color(0xFF4E4949),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 342,
                    height: 15,
                    child: Text(
                      'Paylaşım Linki',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.0,
                        letterSpacing: 0,
                        color: const Color(0xFF0D0D0D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 342,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFFF3F3F3),
                        width: 1,
                      ),
                      color: const Color(0xFFFEFEFE),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 137,
                          height: 15,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'https://sixpack30.com',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 1.0,
                                letterSpacing: -0.011 * 12,
                                color: const Color(0xFF4E4949),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 44,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              backgroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Clipboard.setData(const ClipboardData(
                                  text: 'https://sixpack30.com'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Bağlantı kopyalandı'),
                                ),
                              );
                            },
                            child: Text(
                              'Kopyala',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Container(
                      width: 342,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFF3F3F3),
                          width: 1,
                        ),
                        color: const Color(0xFFFEFEFE),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40000000),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSocialButton(
                            iconAsset:
                                'assets/images/icons/Frame 5869.svg',
                            label: 'Instagram',
                          ),
                          _buildSocialButton(
                            iconAsset:
                                'assets/images/icons/Frame 5869 (1).svg',
                            label: 'LinkedIn',
                          ),
                          _buildSocialButton(
                            iconAsset:
                                'assets/images/icons/Frame 5869 (2).svg',
                            label: 'WhatsApp',
                          ),
                          _buildSocialButton(
                            iconAsset:
                                'assets/images/icons/Frame 5869 (3).svg',
                            label: 'Twitter',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String assetPath) {
    return Container(
      width: 45.338321685791016,
      height: 41.14033126831055,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFFD9D9D9),
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String iconAsset,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40.42856979370117,
          height: 40.42856979370117,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Center(
            child: SvgPicture.asset(
              iconAsset,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 71.5922622680664,
          height: 12,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 10,
                height: 1.0,
                letterSpacing: -0.011 * 10,
                color: const Color(0xFF0D0D0D),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

