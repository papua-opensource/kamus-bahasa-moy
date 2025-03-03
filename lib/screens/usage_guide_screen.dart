import 'package:flutter/material.dart';

class UsageGuideScreen extends StatelessWidget {
  const UsageGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panduan Penggunaan',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menghapus judul yang redundan dengan AppBar
            const Text(
              'Berikut adalah panduan untuk membantu Anda mempelajari dan menjelajahi kosakata bahasa Moy.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            _buildGuideItem(
              context,
              '1. Mencari Kata',
              'Anda dapat mencari kata bahasa Moy menggunakan fitur pencarian di halaman utama atau menelusuri kata berdasarkan abjad di halaman Kosakata.',
              'assets/images/search_illustration.png',
            ),

            _buildGuideItem(
              context,
              '2. Melihat Detail Kata',
              'Tap pada kata untuk melihat detail lengkap termasuk arti, pelafalan, dan contoh penggunaan dalam kalimat bahasa Moy dan terjemahan Indonesia.',
              'assets/images/detail_illustration.png',
            ),

            _buildGuideItem(
              context,
              '3. Menandai Favorit',
              'Tap ikon bookmark pada kartu kata untuk menandainya sebagai favorit. Anda dapat melihat semua kata favorit di halaman Favorit.',
              'assets/images/favorite_illustration.png',
            ),

            _buildGuideItem(
              context,
              '4. Kata Hari Ini',
              'Di halaman utama, Anda akan melihat "Kata Hari Ini" yang berubah setiap hari untuk membantu Anda mempelajari kata baru.',
              'assets/images/daily_word_illustration.png',
            ),

            _buildGuideItem(
              context,
              '5. Melihat Statistik',
              'Halaman utama juga menampilkan statistik tentang jumlah kata dalam kamus dan informasi lainnya tentang perkembangan kamus.',
              'assets/images/statistics_illustration.png',
            ),

            // Menambahkan bagian baru tentang cara membaca kelas kata
            const Text(
              'Cara Membaca Kelas Kata',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Setiap kata dalam kamus ini dilengkapi dengan informasi kelas kata yang ditunjukkan dengan singkatan berikut:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            _buildClassExplanation(
                'n', 'nomina', 'kata benda (contoh: rumah, meja, buku)'),
            _buildClassExplanation(
                'v', 'verba', 'kata kerja (contoh: makan, tidur, berjalan)'),
            _buildClassExplanation('a', 'adjektiva',
                'kata sifat yang menjelaskan nomina (contoh: besar, kecil, indah)'),
            _buildClassExplanation('adv', 'adverbia',
                'kata yang menjelaskan verba, adjektiva, atau adverbia lain (contoh: sangat, dengan cepat)'),
            _buildClassExplanation('pron', 'pronomina',
                'kata ganti, kata tunjuk, dan kata tanya (contoh: saya, ini, apa)'),
            _buildClassExplanation('num', 'numeralia',
                'kata bilangan (contoh: satu, dua, pertama)'),
            _buildClassExplanation('p', 'partikel',
                'kelas kata yang meliputi kata depan, kata sambung, kata seru (contoh: di, dan, oh)'),

            const SizedBox(height: 32),
            const Text(
              'Tips Penggunaan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTip(
                'Gunakan fitur favorit untuk menyimpan kata-kata yang ingin Anda pelajari lebih lanjut.'),
            _buildTip(
                'Periksa "Kata Hari Ini" setiap hari untuk memperkaya kosakata Anda.'),
            _buildTip(
                'Manfaatkan contoh kalimat untuk memahami penggunaan kata dalam konteks yang tepat.'),
            _buildTip(
                'Perhatikan kelas kata untuk memahami fungsi dan penggunaan kata tersebut dalam kalimat.'),
            _buildTip(
                'Bagikan aplikasi ini kepada teman dan keluarga untuk membantu melestarikan bahasa Moy.'),

            const SizedBox(height: 24),
            const Center(
              child: Text(
                '© 2025 Papua Open Source',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideItem(BuildContext context, String title, String description,
      String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Placeholder for image with border instead of shadow
          Center(
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Center(
                child: Icon(
                  _getIconForTitle(title),
                  size: 64,
                  color: const Color(0xFF1976D2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassExplanation(String code, String name, String explanation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  explanation,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    if (title.contains('Mencari')) {
      return Icons.search;
    } else if (title.contains('Detail')) {
      return Icons.article_outlined;
    } else if (title.contains('Favorit')) {
      return Icons.bookmark_outlined;
    } else if (title.contains('Hari Ini')) {
      return Icons.calendar_today_outlined;
    } else if (title.contains('Statistik')) {
      return Icons.bar_chart;
    }
    return Icons.info_outline;
  }

  Widget _buildTip(String tipText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.tips_and_updates_outlined,
            color: Color(0xFF1976D2),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tipText,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
