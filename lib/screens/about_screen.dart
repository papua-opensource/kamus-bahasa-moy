import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tentang',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menghapus judul "Kamus Bahasa Moy" karena redundant dengan subtitle di bawah
            const SizedBox(height: 16),
            const Text(
              'Kamus Bahasa Moy adalah proyek pelestarian bahasa yang dikembangkan untuk membantu melestarikan dan mempromosikan bahasa Moy dari Jayapura, Papua.',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Versi Aplikasi',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'v1.0.0',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tentang Bahasa Moy',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bahasa Moy adalah salah satu bahasa daerah dari Papua yang saat ini terancam punah. Kamus digital ini bertujuan untuk mendokumentasikan dan melestarikan kekayaan bahasa dan budaya Moy untuk generasi mendatang.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF293241),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tim Pengembang',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kamus Bahasa Moy dikembangkan oleh Papua Open Source, sebuah komunitas pengembang perangkat lunak yang berfokus pada pelestarian bahasa dan budaya Papua melalui teknologi.',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                '© 2025 Papua Open Source',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
