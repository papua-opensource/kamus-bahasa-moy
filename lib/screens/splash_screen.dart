// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'onboarding_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Tambahkan timer untuk pindah ke halaman berikutnya setelah beberapa detik
//     Timer(const Duration(seconds: 3), () {
//       // Navigasi ke halaman onboarding
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const OnboardingScreen()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: const Color(0xFF1976D2), // Warna biru yang sesuai dengan gambar
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo putih berbentuk rounded rectangle
//               Container(
//                 width: 80,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Judul aplikasi
//               const Text(
//                 'Kamus Bahasa Moy',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Deskripsi aplikasi
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 48.0),
//                 child: Text(
//                   'Jelajahi dan pelajari kosakata bahasa Moy dengan mudah melalui kamus digital ini.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               // Spacer untuk mendorong copyright ke bawah
//               const Spacer(),
//               // Copyright text
//               const Padding(
//                 padding: EdgeInsets.only(bottom: 20.0),
//                 child: Text(
//                   '© 2025 Papua Open Source',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer to navigate to next page after a few seconds
    Timer(const Duration(seconds: 3), () {
      // Navigate to onboarding page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;

    return Scaffold(
      body: Container(
        color: const Color(
            0xFFFCFCFC), // Background color as per requirement (#FCFCFC)
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo using PNG file
                      Image.asset(
                        'assets/images/logo-kamus-bahasa-moy.png',
                        width: isTablet ? 180 : 120,
                        height: isTablet ? 180 : 120,
                      ),
                      SizedBox(height: isTablet ? 32 : 20),
                      // App title
                      Text(
                        'Kamus Bahasa Moy',
                        style: TextStyle(
                          color: const Color(
                              0xFF2973B2), // Text color as per requirement (#2973B2)
                          fontSize: isTablet ? 32 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isTablet ? 24 : 16),
                      // App description
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Jelajahi dan pelajari kosakata bahasa Moy dengan mudah melalui kamus digital ini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(
                                0xFF2973B2), // Text color as per requirement (#2973B2)
                            fontSize: isTablet ? 20 : 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Copyright text at bottom
                Padding(
                  padding: EdgeInsets.only(bottom: isTablet ? 32.0 : 20.0),
                  child: Text(
                    '© 2025 Papua Open Source',
                    style: TextStyle(
                      color: const Color(
                          0xFF2973B2), // Text color as per requirement (#2973B2)
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
