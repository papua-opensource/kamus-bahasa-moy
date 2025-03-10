import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                color: Color(0xFF293241),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sumber Data',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aplikasi ini menggunakan data kosakata dan definisi dari Kamus Dwibahasa Mooi yang diterbitkan oleh Balai Bahasa Provinsi Papua. Kamus tersebut merupakan sumber otoritatif untuk bahasa Moy/Mooi dan telah disusun melalui penelitian bahasa yang ekstensif oleh ahli linguistik dari Balai Bahasa.',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Penggunaan data dari sumber resmi ini memastikan bahwa pengguna mendapatkan informasi bahasa yang akurat dan otentik, sejalan dengan upaya pelestarian bahasa daerah di Papua.',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Open Source',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aplikasi ini berbasis open source. Kode sumber dapat ditemukan pada repository GitHub:',
                  style: TextStyle(
                    color: Color(0xFF293241),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    final repoUrl =
                        'https://github.com/papua-opensource/kamus-bahasa-moy';
                    Clipboard.setData(ClipboardData(text: repoUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('URL GitHub disalin ke clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'https://github.com/papua-opensource/kamus-bahasa-moy',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.copy, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kontribusi dan masukan dari komunitas sangat dihargai untuk pengembangan dan perbaikan aplikasi ini lebih lanjut.',
                  style: TextStyle(
                    color: Color(0xFF293241),
                    fontSize: 16,
                  ),
                ),
              ],
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
