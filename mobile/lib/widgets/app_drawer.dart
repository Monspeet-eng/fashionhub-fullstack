import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalog_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigateToCatalog(BuildContext context, String category) {
    Navigator.of(context).pop();
    context.read<CatalogProvider>().fetchProducts(category: category);
    Navigator.of(context).pushNamed('/catalog');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF1A1A1A),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FASHIONHUB',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Contemporary & Casual Essentials',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (r) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view_outlined),
              title: const Text('Semua Koleksi (All)'),
              onTap: () => _navigateToCatalog(context, 'All'),
            ),
            ListTile(
              leading: const Icon(Icons.male_outlined),
              title: const Text('Koleksi Pria (Men)'),
              onTap: () => _navigateToCatalog(context, 'Men'),
            ),
            ListTile(
              leading: const Icon(Icons.female_outlined),
              title: const Text('Koleksi Wanita (Women)'),
              onTap: () => _navigateToCatalog(context, 'Women'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.mail_outline),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/contact');
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '© 2026 FashionHub Mobile App\n'
                'Capstone Project Edition',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}