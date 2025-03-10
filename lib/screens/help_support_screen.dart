import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'contact_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'usage_guide_screen.dart';
import 'package:flutter/services.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  // Fungsi untuk menampilkan dialog informasi URL
  void _showFeedbackDialog(BuildContext context) {
    final String feedbackUrl = 'https://forms.gle/zz5DnkvhNiHWSnpr8';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Saran dan Umpan Balik'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buka URL berikut di browser Anda:'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: feedbackUrl));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('URL disalin ke clipboard'),
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
                        feedbackUrl,
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
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bantuan & Kontak',
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
            const Text(
              'Silakan pilih salah satu opsi di bawah ini untuk mendapatkan informasi atau bantuan yang Anda perlukan.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF293241),
              ),
            ),
            const SizedBox(height: 32),

            // Menu items
            _buildMenuCard(
              context,
              'Kontak',
              'Hubungi kami jika Anda memiliki pertanyaan atau saran.',
              Icons.contact_mail_outlined,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const ContactScreen()),
                );
              },
            ),

            // Card Saran atau Umpan Balik
            _buildMenuCard(
              context,
              'Saran atau Umpan Balik',
              'Bantu kami meningkatkan aplikasi dengan memberikan masukan.',
              Icons.feedback_outlined,
              () {
                _showFeedbackDialog(context);
              },
            ),

            _buildMenuCard(
              context,
              'Kebijakan Privasi',
              'Informasi tentang kebijakan privasi dan data Anda.',
              Icons.privacy_tip_outlined,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen()),
                );
              },
            ),

            _buildMenuCard(
              context,
              'Syarat Layanan',
              'Ketentuan penggunaan aplikasi Kamus Bahasa Moy.',
              Icons.description_outlined,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const TermsOfServiceScreen()),
                );
              },
            ),

            _buildMenuCard(
              context,
              'Panduan Penggunaan',
              'Pelajari cara menggunakan fitur-fitur aplikasi.',
              Icons.help_outline,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const UsageGuideScreen()),
                );
              },
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

  Widget _buildMenuCard(BuildContext context, String title, String description,
      IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF164B8F), size: 28),
              const SizedBox(width: 16),
              Expanded(
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
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF293241),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
