import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/home_screen.dart';
import '../screens/vocabulary_screen.dart';
import '../screens/about_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/splash_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer header
          Container(
            color: const Color(0xFF164B8F),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.0), // Padding sama di semua sisi
                    child: Image.asset(
                      'assets/images/logo-kamus-bahasa-moy.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kamus Bahasa Moy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Drawer menu items
          ListTile(
            leading: const Icon(
              Icons.home_outlined,
              color: Color(0xFF293241),
            ),
            title: const Text('Beranda'),
            textColor: const Color(0xFF293241),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/home') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.library_books_outlined,
              color: Color(0xFF293241),
            ),
            title: const Text('Kosakata'),
            textColor: const Color(0xFF293241),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/vocabulary') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const VocabularyScreen(),
                    settings: const RouteSettings(name: '/vocabulary'),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: Color(0xFF293241),
            ),
            title: const Text('Tentang'),
            textColor: const Color(0xFF293241),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.help_outline,
              color: Color(0xFF293241),
            ),
            title: const Text('Bantuan & Kontak'),
            textColor: const Color(0xFF293241),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Color(0xFF293241),
            ),
            title: const Text('Keluar'),
            textColor: const Color(0xFF293241),
            onTap: () {
              // Langsung keluar dari aplikasi
              SystemNavigator.pop();
            },
          ),
          // Development only: Reset Onboarding menu item
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              border: Border(
                top: BorderSide(color: Colors.amber.withOpacity(0.5), width: 1),
                bottom:
                    BorderSide(color: Colors.amber.withOpacity(0.5), width: 1),
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.refresh,
                color: Colors.red,
              ),
              title: const Text(
                'Reset Onboarding (Dev)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Hanya untuk pengembangan',
                style: TextStyle(fontSize: 12),
              ),
              textColor: Colors.red,
              onTap: () async {
                // Confirm before resetting
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Onboarding?'),
                    content: const Text(
                        'Ini akan menghapus status onboarding dan menampilkan kembali halaman onboarding. Lanjutkan?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  // Reset status onboarding
                  const storage = FlutterSecureStorage();
                  await storage.deleteAll();

                  // Close drawer and restart app at SplashScreen
                  if (context.mounted) {
                    Navigator.pop(context); // Close drawer
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()),
                    );
                  }
                }
              },
            ),
          ),
          const Spacer(),
          // Copyright footer
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              '© 2025 Papua Open Source',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
