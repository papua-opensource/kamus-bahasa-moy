import 'package:flutter/material.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Colors.white),
            onPressed: () {
              // Navigate to favorites page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          ),
        ],
        title: const Text(
          'Kamus Bahasa Moy',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: const Center(
        child: Text(
          'Isi halaman utama disini',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            color: Colors.blue,
          ),
          _buildDrawerItem(Icons.settings, 'Setelan', () {
            Navigator.pop(context);
            // Add navigation to Settings page if needed
          }),
          _buildDrawerItem(Icons.help_outline, 'Bantuan & masukkan', () {
            Navigator.pop(context);
            // Add navigation to Help page if needed
          }),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Kebijakan Privasi',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Persyaratan Layanan',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      onTap: onTap,
    );
  }
}
