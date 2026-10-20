import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalog_provider.dart';
import '../widgets/fashion_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cart_drawer.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: FashionAppBar(
        title: catalog.selectedCategory == 'All'
            ? 'ALL COLLECTIONS'
            : '${catalog.selectedCategory.toUpperCase()} COLLECTION',
        showBackButton: true,
      ),
      drawer: const AppDrawer(),
      endDrawer: const CartDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter Kategori (All / Men / Women) & Sort Dropdown
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _CategoryChip(
                      label: 'All',
                      selected: catalog.selectedCategory == 'All',
                      onSelected: () =>
                          catalog.fetchProducts(category: 'All'),
                    ),
                    const SizedBox(width: 8),
                    _CategoryChip(
                      label: 'Men',
                      selected: catalog.selectedCategory == 'Men',
                      onSelected: () =>
                          catalog.fetchProducts(category: 'Men'),
                    ),
                    const SizedBox(width: 8),
                    _CategoryChip(
                      label: 'Women',
                      selected: catalog.selectedCategory == 'Women',
                      onSelected: () =>
                          catalog.fetchProducts(category: 'Women'),
                    ),
                    const Spacer(),
                    // Dropdown Sort
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: catalog.sortBy,
                        icon: const Icon(Icons.sort, size: 18),
                        style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                        items: const [
                          DropdownMenuItem(
                            value: 'newest',
                            child: Text('Terbaru'),
                          ),
                          DropdownMenuItem(
                            value: 'price_asc',
                            child: Text('Harga: Rendah - Tinggi'),
                          ),
                          DropdownMenuItem(
                            value: 'price_desc',
                            child: Text('Harga: Tinggi - Rendah'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            catalog.fetchProducts(sort: val);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Indikator Pagination / Count sesuai PRD 3.1.2
                Text(
                  catalog.showingText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Grid Produk 2 Kolom
          Expanded(
            child: catalog.isLoading
                ? const Center(child: CircularProgressIndicator())
                : catalog.products.isEmpty
                    ? const Center(
                        child: Text('Tidak ada produk pada kategori ini.'),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: catalog.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.66,
                        ),
                        itemBuilder: (context, idx) {
                          final product = catalog.products[idx];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/product-detail',
                                arguments: product.id,
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: const Color(0xFF1A1A1A),
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}
