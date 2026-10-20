import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/currency_formatter.dart';
import '../widgets/fashion_app_bar.dart';
import '../widgets/cart_drawer.dart';
import '../widgets/product_card.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogProvider>().fetchProductDetail(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final product = catalog.selectedProduct;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const FashionAppBar(title: 'PRODUCT DETAIL', showBackButton: true),
      endDrawer: const CartDrawer(),
      body: catalog.isLoading || product == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Preview Gambar Produk
                  AspectRatio(
                    aspectRatio: 0.9,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.checkroom, size: 64),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F0E6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.category.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8B6508),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          CurrencyFormatter.formatIdr(product.price),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF8B6508),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Stepper Kuantitas (-, angka, +) & Add To Cart
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18),
                                    onPressed: () {
                                      if (_quantity > 1) {
                                        setState(() => _quantity--);
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      '$_quantity',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    onPressed: () {
                                      setState(() => _quantity++);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Builder(
                                builder: (ctx) => ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A1A1A),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 18),
                                  label: const Text(
                                    'ADD TO CART',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await context
                                        .read<CartProvider>()
                                        .addToCart(product, _quantity);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${product.name} ($_quantity pcs) ditambahkan ke keranjang!'),
                                        action: SnackBarAction(
                                          label: 'LIHAT CART',
                                          textColor: const Color(0xFFFFD54F),
                                          onPressed: () {
                                            Scaffold.of(ctx).openEndDrawer();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 36),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Rekomendasi "You May Also Like" sesuai PRD 3.1.3
                        const Text(
                          'YOU MAY ALSO LIKE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: catalog.relatedProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.66,
                          ),
                          itemBuilder: (context, idx) {
                            final rel = catalog.relatedProducts[idx];
                            return ProductCard(
                              product: rel,
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed(
                                  '/product-detail',
                                  arguments: rel.id,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
