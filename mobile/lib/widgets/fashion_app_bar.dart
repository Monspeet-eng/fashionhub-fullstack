import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class FashionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const FashionAppBar({
    super.key,
    this.title = 'FASHIONHUB',
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalItems;

    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A1A1A),
      elevation: 0.5,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            )
          : Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Menu Navigasi',
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 2.2,
          fontSize: 18,
          color: Color(0xFF1A1A1A),
        ),
      ),
      actions: [
        Builder(
          builder: (ctx) => Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                tooltip: 'Keranjang Belanja',
                onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8860B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}
