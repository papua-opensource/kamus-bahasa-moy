import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../utils/storage_util.dart'; // Import storage utility

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;
  final String buttonText;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.buttonText,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Akses Kosakata Berdasarkan Abjad',
      description:
          'Telusuri kosakata bahasa Moy dengan mudah berdasarkan urutan alfabet.',
      imagePath: 'assets/images/onboarding-ilustration-1.png',
      buttonText: 'Berikutnya',
    ),
    OnboardingItem(
      title: 'Detail Informasi Setiap Kata',
      description:
          'Setiap kata dilengkapi dengan contoh kalimat dalam bahasa Moy dan bahasa Indonesia.',
      imagePath: 'assets/images/onboarding-ilustration-2.png',
      buttonText: 'Berikutnya',
    ),
    OnboardingItem(
      title: 'Pelajari dan Lestarikan Bahasa Moy',
      description:
          'Jadikan kamus ini sebagai media untuk memahami dan melestarikan bahasa Moy!',
      imagePath: 'assets/images/onboarding-ilustration-3.png',
      buttonText: 'Mulai',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _onboardingItems.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return buildOnboardingPage(
                      _onboardingItems[index], index, isTablet);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildOnboardingPage(OnboardingItem item, int index, bool isTablet) {
    double imageSize = isTablet ? 300 : 200;
    double titleFontSize = isTablet ? 26 : 20;
    double descFontSize = isTablet ? 18 : 16;
    double buttonFontSize = isTablet ? 18 : 16;

    return Container(
      color: const Color(0xFF164B8F),
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'Kamus Bahasa Moy',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          Image.asset(
            item.imagePath,
            width: imageSize,
            height: imageSize,
          ),
          const SizedBox(height: 30),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: descFontSize,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    for (int i = 0; i < _onboardingItems.length; i++)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _currentPage
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (index == _onboardingItems.length - 1) {
                      // Save that user has completed onboarding
                      await StorageUtil.setOnboardingCompleted();

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF1976D2),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    item.buttonText,
                    style: TextStyle(
                      color: const Color(0xFF164B8F),
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
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
}
