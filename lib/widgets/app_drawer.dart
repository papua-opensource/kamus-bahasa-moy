import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/home_screen.dart';
import '../screens/vocabulary_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/about_screen.dart';
import '../screens/help_support_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer header
          Container(
            color: const Color(0xFF1976D2),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo container
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
            leading: const Icon(Icons.home_outlined),
            title: const Text('Beranda'),
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
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('Kosakata'),
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
            leading: const Icon(Icons.bookmark_border_outlined),
            title: const Text('Favorit'),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/favorites') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                    settings: const RouteSettings(name: '/favorites'),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Bantuan & Kontak'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Keluar'),
            onTap: () {
              // Langsung keluar dari aplikasi
              SystemNavigator.pop();
            },
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
