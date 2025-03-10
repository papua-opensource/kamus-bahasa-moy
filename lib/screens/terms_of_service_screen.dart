import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Syarat Layanan',
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
            const Text(
              'Terakhir diperbarui: 1 Maret 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Penerimaan Ketentuan',
              'Dengan mengunduh, menginstal, atau menggunakan aplikasi Kamus Bahasa Moy, Anda setuju untuk terikat oleh syarat dan ketentuan layanan ini. Jika Anda tidak setuju dengan ketentuan ini, Anda tidak boleh menggunakan aplikasi kami.',
            ),
            _buildSection(
              '2. Penggunaan Aplikasi',
              'Aplikasi Kamus Bahasa Moy disediakan untuk tujuan pendidikan dan pelestarian bahasa. Anda setuju untuk menggunakan aplikasi ini hanya untuk tujuan yang sah dan sesuai dengan hukum dan peraturan yang berlaku.',
            ),
            _buildSection(
              '3. Hak Kekayaan Intelektual',
              'Semua konten yang tersedia di aplikasi Kamus Bahasa Moy, termasuk tetapi tidak terbatas pada teks, grafik, logo, ikon, gambar, klip audio, dan perangkat lunak, adalah milik Papua Open Source atau pemberi lisensinya dan dilindungi oleh hukum hak cipta Indonesia dan internasional.',
            ),
            _buildSection(
              '4. Lisensi Penggunaan',
              'Kami memberi Anda lisensi terbatas, non-eksklusif, tidak dapat dialihkan, dan dapat dicabut untuk mengunduh dan menggunakan aplikasi Kamus Bahasa Moy secara pribadi dan non-komersial.',
            ),
            _buildSection(
              '5. Batasan',
              'Anda tidak boleh:\n\n'
                  '• Menggunakan aplikasi untuk tujuan komersial tanpa izin tertulis dari kami\n'
                  '• Memodifikasi, mendekompilasi, atau merekayasa balik aplikasi\n'
                  '• Menghapus pemberitahuan hak cipta atau kepemilikan lainnya dari aplikasi\n'
                  '• Menggunakan aplikasi dengan cara yang melanggar hukum atau peraturan yang berlaku',
            ),
            _buildSection(
              '6. Penafian Jaminan',
              'Aplikasi Kamus Bahasa Moy disediakan "sebagaimana adanya" dan "sebagaimana tersedia" tanpa jaminan apa pun, baik tersurat maupun tersirat.',
            ),
            _buildSection(
              '7. Perubahan pada Syarat Layanan',
              'Kami berhak untuk mengubah atau mengganti syarat layanan ini kapan saja. Kami akan memberi tahu Anda tentang perubahan yang signifikan dengan memperbarui tanggal "Terakhir diperbarui" di bagian atas dokumen ini.',
            ),
            _buildSection(
              '8. Kontak',
              'Jika Anda memiliki pertanyaan tentang Syarat Layanan ini, silakan hubungi kami di contact@papuaopensource.org.',
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
