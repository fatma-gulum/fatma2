import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sixpack30/Text/font.dart';

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  int? _expandedIndex;

  static const List<Map<String, String>> _faqItems = [
    {
      'question': 'SixPack30 nedir?',
      'answer':
          'SixPack30, kullanıcıların 30 günlük karın kası egzersiz programını takip etmelerine yardımcı olan bir fitness uygulamasıdır. Günlük egzersiz planları, ilerleme takibi ve hatırlatıcılar sayesinde düzenli antrenman yapmayı kolaylaştırır.',
    },
    {
      'question': 'SixPack30 ile nasıl çalışırım?',
      'answer':
          'Uygulama, 30 gün boyunca adım adım ilerleyen bir egzersiz programı sunar. Her gün farklı karın kası egzersizleri önerilir ve kullanıcılar tamamladıkları antrenmanları işaretleyerek ilerlemelerini takip edebilir.',
    },
    {
      'question': 'Egzersizler yeni başlayanlar için uygun mu?',
      'answer':
          'Evet. SixPack30 programı farklı seviyelerdeki kullanıcılar için uygundur. Egzersizler başlangıç seviyesinden başlayarak zamanla daha yoğun hale gelecek şekilde planlanmıştır.',
    },
    {
      'question': 'Egzersizler için spor ekipmanı gerekiyor mu?',
      'answer':
          'Hayır. SixPack30’daki egzersizlerin büyük bölümü vücut ağırlığı ile yapılabilecek şekilde tasarlanmıştır. Bu sayede antrenmanlar evde veya spor salonunda ekipman olmadan da yapılabilir.',
    },
    {
      'question': 'Ücretsiz kullanımda hangi özellikler sunulur?',
      'answer':
          'Ücretsiz kullanım kapsamında belirli sayıda egzersiz planı, günlük antrenman takibi ve temel ilerleme özellikleri sunulabilir. Bazı gelişmiş özellikler sınırlı olabilir.',
    },
    {
      'question': 'Premium paket aldığımda ne değişir?',
      'answer':
          'Premium kullanıcılar aşağıdaki avantajlardan yararlanabilir:\n\n- Tüm egzersiz programlarına erişim\n- Gelişmiş antrenman planları\n- Reklamsız kullanım\n- Daha detaylı ilerleme takibi\n- Yeni eklenen fitness programlarına erken erişim',
    },
    {
      'question': 'Egzersiz geçmişimi ve ilerlememi görebilir miyim?',
      'answer':
          'Evet. SixPack30, tamamladığınız antrenmanları ve ilerlemenizi takip etmenize yardımcı olur. Premium kullanıcılar geçmiş egzersiz verilerine daha detaylı şekilde erişebilir.',
    },
    {
      'question': 'Egzersizleri yaparken nelere dikkat etmeliyim?',
      'answer':
          'Egzersizleri kendi fiziksel durumunuza uygun şekilde uygulamanız önerilir. Herhangi bir sağlık sorununuz varsa egzersiz programına başlamadan önce bir sağlık uzmanına danışmanız tavsiye edilir.',
    },
    {
      'question': 'Aboneliğimi nasıl iptal edebilirim?',
      'answer':
          'Abonelikler App Store veya Google Play hesap ayarları üzerinden yönetilebilir ve istenildiği zaman iptal edilebilir.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: Center(
        child: Container(
          width: 390,
          constraints: BoxConstraints(
            maxWidth: 390,
            minHeight: MediaQuery.of(context).size.height,
          ),
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
                        onPressed: () => Navigator.of(context).maybePop(),
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
                              'Sıkça Sorulan Sorular',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: AppFont.montserrat,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                height: 1.5,
                                letterSpacing: -0.22,
                                color: Color(0xFF0D0D0D),
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
                  const SizedBox(height: 28),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 4,
                      ),
                      itemCount: _faqItems.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = _faqItems[index];
                        final isExpanded = _expandedIndex == index;
                        return Container(
                          width: 345,
                          constraints: BoxConstraints(
                            minHeight: isExpanded ? 120 : 58,
                          ),
                          decoration: BoxDecoration(
                            color: isExpanded
                                ? const Color(0xF1F9F9F9) // #F9F9F991 approx
                                : const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(
                              isExpanded ? 15 : 10,
                            ),
                            border: Border.all(
                              width: 1,
                              color: isExpanded
                                  ? const Color(0x9E4E4949) // #4E49499E
                                  : const Color(0xFFF3F3F3),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _expandedIndex =
                                      isExpanded ? null : index;
                                });
                              },
                              borderRadius: BorderRadius.circular(
                                isExpanded ? 15 : 10,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['question']!,
                                            style: const TextStyle(
                                              fontFamily:
                                                  AppFont.montserrat,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              height: 1.5,
                                              letterSpacing: -0.154,
                                              color: Color(0xFF0D0D0D),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Transform.rotate(
                                          angle: isExpanded ? pi : 0,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(
                                              top: 1.04,
                                              left: 1.04,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/icons/iconstack.io - (Round Alt Arrow Right) (1).svg',
                                              width: 17.92,
                                              height: 17.92,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Color(0x66101010),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isExpanded) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        item['answer']!,
                                        style: const TextStyle(
                                          fontFamily: AppFont.montserrat,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          height: 1.0,
                                          letterSpacing: -0.132,
                                          color: Color(0xFF4E4949),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
