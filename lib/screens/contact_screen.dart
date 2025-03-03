import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kontak',
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
              'Kami senang menerima pertanyaan, saran, dan masukan dari Anda untuk meningkatkan aplikasi Kamus Bahasa Moy.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Contact methods
            _buildContactMethod(
              'Email',
              'papuaopensource@example.com',
              Icons.email_outlined,
            ),

            _buildContactMethod(
              'Telepon',
              '+62 812 3456 7890',
              Icons.phone_outlined,
            ),

            _buildContactMethod(
              'Website',
              'www.papuaopensource.org',
              Icons.language_outlined,
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

  Widget _buildContactMethod(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1976D2),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
