import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingItem {
  final String title;
  final String description;
  final Widget image;
  final String buttonText;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
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
      image: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      buttonText: 'Berikutnya',
    ),
    OnboardingItem(
      title: 'Detail Informasi Setiap Kata',
      description:
          'Setiap kata dilengkapi dengan contoh kalimat dalam bahasa Moy dan bahasa Indonesia.',
      image: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      buttonText: 'Berikutnya',
    ),
    OnboardingItem(
      title: 'Pelajari dan Lestarikan Bahasa Moy',
      description:
          'Jadikan kamus ini sebagai media untuk memahami dan melestarikan bahasa Moy!',
      image: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      buttonText: 'Mulai',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView untuk halaman onboarding
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingItems.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return buildOnboardingPage(_onboardingItems[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget buildOnboardingPage(OnboardingItem item, int index) {
    return Container(
      color: const Color(0xFF1976D2),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Judul aplikasi
          const Text(
            'Kamus Bahasa Moy',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          // Gambar container
          item.image,
          const SizedBox(height: 30),
          // Judul onboarding
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          // Deskripsi
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          // Indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 20),
          // Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (index == _onboardingItems.length - 1) {
                    // Jika ini adalah halaman terakhir, navigasi ke halaman utama
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  } else {
                    // Jika bukan halaman terakhir, navigasi ke halaman berikutnya
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  item.buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
