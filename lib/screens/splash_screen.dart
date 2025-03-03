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
    // Tambahkan timer untuk pindah ke halaman berikutnya setelah beberapa detik
    Timer(const Duration(seconds: 3), () {
      // Navigasi ke halaman onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1976D2), // Warna biru yang sesuai dengan gambar
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo putih berbentuk rounded rectangle
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 20),
              // Judul aplikasi
              const Text(
                'Kamus Bahasa Moy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Deskripsi aplikasi
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48.0),
                child: Text(
                  'Jelajahi dan pelajari kosakata bahasa Moy dengan mudah melalui kamus digital ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              // Spacer untuk mendorong copyright ke bawah
              const Spacer(),
              // Copyright text
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  '© 2025 Papua Open Source',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
