import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/word.dart';
import 'vocabulary_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Beranda',
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Logo container
              Center(
                child: Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Judul aplikasi
              const Text(
                'Kamus Bahasa Moy',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Teks deskripsi
              const Text(
                'Jelajahi kekayaan bahasa Moy dengan kamus digital interaktif ini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              // Statistik section
              const Text(
                'Statistik',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Statistik deskripsi
              const Text(
                'Kamus ini berisi 2.500+ kata bahasa Moy dengan contoh penggunaan dan arti.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              // Kata hari ini section
              const Text(
                'Kata hari ini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Kata hari ini card with border instead of shadow
              InkWell(
                onTap: () {
                  // Navigasi ke halaman detail kata hari ini
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          VocabularyDetailScreen(word: dailyWord),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ABLETSING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Format inline untuk pelafalan, kelas kata dan arti
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(text: dailyWord.phoneticSpelling),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: dailyWord.wordClass,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(text: dailyWord.meaning),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
