import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kebijakan Privasi',
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
              'Terakhir diperbarui: 1 Maret 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Pengantar',
              'Kamus Bahasa Moy menghargai privasi Anda. Kebijakan ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi yang Anda berikan saat menggunakan aplikasi kami.',
            ),
            _buildSection(
              'Informasi yang Kami Kumpulkan',
              'Kami hanya mengumpulkan informasi yang diperlukan untuk menyediakan dan meningkatkan layanan kami. Ini mungkin termasuk:\n\n'
                  '• Data penggunaan anonim\n'
                  '• Kata-kata favorit yang Anda simpan\n'
                  '• Preferensi aplikasi',
            ),
            _buildSection(
              'Penggunaan Informasi',
              'Informasi yang kami kumpulkan digunakan untuk:\n\n'
                  '• Menyediakan dan memelihara layanan kami\n'
                  '• Meningkatkan, mempersonalisasi, dan memperluas layanan kami\n'
                  '• Memahami dan menganalisis bagaimana Anda menggunakan layanan kami\n'
                  '• Mengembangkan produk, layanan, fitur, dan fungsionalitas baru',
            ),
            _buildSection(
              'Berbagi dan Pengungkapan Data',
              'Kami tidak menjual, menukarkan, atau mentransfer informasi pribadi Anda kepada pihak ketiga. Ini tidak termasuk pihak ketiga tepercaya yang membantu kami dalam mengoperasikan aplikasi kami, selama pihak-pihak tersebut setuju untuk menjaga kerahasiaan informasi ini.',
            ),
            _buildSection(
              'Keamanan Data',
              'Kami menerapkan tindakan keamanan yang sesuai untuk melindungi informasi pribadi Anda. Namun, perlu diingat bahwa tidak ada metode transmisi melalui internet atau metode penyimpanan elektronik yang 100% aman dan andal.',
            ),
            _buildSection(
              'Perubahan pada Kebijakan Privasi Ini',
              'Kami dapat memperbarui Kebijakan Privasi kami dari waktu ke waktu. Kami akan memberi tahu Anda tentang perubahan dengan memposting Kebijakan Privasi baru di halaman ini.',
            ),
            _buildSection(
              'Kontak',
              'Jika Anda memiliki pertanyaan atau kekhawatiran tentang Kebijakan Privasi kami, silakan hubungi kami di papuaopensource@example.com.',
            ),
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

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF293241),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF293241),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
