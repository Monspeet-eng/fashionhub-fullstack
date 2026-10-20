import 'package:flutter/material.dart';
import '../widgets/fashion_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cart_drawer.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const FashionAppBar(
        title: 'ABOUT US',
        showBackButton: true,
      ),
      drawer: const AppDrawer(),
      endDrawer: const CartDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1000&q=80',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'OUR STORY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF8B6508),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Crafting Timeless Contemporary Fashion for Everyday Confidence',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'FashionHub hadir untuk menjembatani desain minimalis kontemporer '
              'dengan kenyamanan pakaian kasual sehari-hari. Setiap koleksi '
              'kami dirancang secara cermat menggunakan bahan berkualitas '
              'tinggi yang ramah di kulit dan tahan lama.\n\n'
              'Kami percaya bahwa berpakaian rapi dan trendi seharusnya '
              'mudah diakses, transparan, dan memberikan pengalaman '
              'berbelanja digital yang cepat tanpa hambatan.',
              style: TextStyle(
                fontSize: 14,
                height: 1.65,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 28),

            // Metrik Statistik sesuai PRD 3.1.7
            // Quality Products, Happy Customers, Years Experience
            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    number: '500+',
                    label: 'Quality\nProducts',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    number: '12K+',
                    label: 'Happy\nCustomers',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    number: '6+ Yrs',
                    label: 'Years\nExperience',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}