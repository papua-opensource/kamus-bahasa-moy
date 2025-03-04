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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/logo-kamus-bahasa-moy.png',
                    width: isTablet ? 180 : 120,
                    height: isTablet ? 180 : 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kamus Bahasa Moy',
                    style: TextStyle(
                      color: Color(0xFF293241),
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Jelajahi kekayaan bahasa Moy dengan kamus digital interaktif ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF293241),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Statistik',
                    style: TextStyle(
                      color: Color(0xFF293241),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Kamus ini berisi 1000+ kata bahasa Moy dengan contoh penggunaan dan arti.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF293241),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Kata hari ini',
                      style: TextStyle(
                        color: Color(0xFF293241),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
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
                        color: const Color(0xFF164B8F),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ABLETSING',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
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
          );
        },
      ),
    );
  }
}
