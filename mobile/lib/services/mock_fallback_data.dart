import '../models/product.dart';

/// Data fallback lokal agar aplikasi tetap dapat didemokan secara mulus
/// apabila server backend Golang sedang tidak aktif/terputus.
class MockFallbackData {
  static final CategoryModel menCategory =
      CategoryModel(id: 1, name: 'Men', slug: 'men');
  static final CategoryModel womenCategory =
      CategoryModel(id: 2, name: 'Women', slug: 'women');

  static final List<ProductModel> products = [
    ProductModel(
      id: 1,
      categoryId: 1,
      category: menCategory,
      name: 'Structured Oversized Trench Coat',
      slug: 'structured-oversized-trench-coat',
      description:
          'Mantel trench pria berpotongan modern oversized dengan bahan katun gabardine tahan angin. Cocok untuk tampilan kasual maupun semi-formal.',
      price: 789000,
      stock: 45,
      imageUrl:
          'https://images.unsplash.com/photo-1516826957135-700dedea698c?auto=format&fit=crop&w=800&q=80',
    ),
    ProductModel(
      id: 2,
      categoryId: 1,
      category: menCategory,
      name: 'Essential Heavyweight Boxy Tee',
      slug: 'essential-heavyweight-boxy-tee',
      description:
          'Kaos pria dengan siluet boxy fit dari 100% combed cotton 280gsm yang lembut, tebal, dan mempertahankan bentuk seharian.',
      price: 249000,
      stock: 120,
      imageUrl:
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80',
    ),
    ProductModel(
      id: 3,
      categoryId: 1,
      category: menCategory,
      name: 'Urban Utility Cargo Trousers',
      slug: 'urban-utility-cargo-trousers',
      description:
          'Celana kargo kontemporer dengan 6 saku fungsional dan bahan ripstop stretch yang nyaman untuk mobilitas tinggi.',
      price: 459000,
      stock: 80,
      imageUrl:
          'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=800&q=80',
    ),
    ProductModel(
      id: 4,
      categoryId: 1,
      category: menCategory,
      name: 'Vintage Washed Selvedge Denim Jacket',
      slug: 'vintage-washed-selvedge-denim-jacket',
      description:
          'Jaket denim pria 14oz dengan detail jahitan kontras dan efek washed klasik yang memberi karakter maskulin dan timeless.',
      price: 649000,
      stock: 55,
      imageUrl:
          'https://images.unsplash.com/photo-1576871337622-98d48d1cf531?auto=format&fit=crop&w=800&q=80',
    ),
    ProductModel(
      id: 5,
      categoryId: 2,
      category: womenCategory,
      name: 'Satin Draped Midi Slip Dress',
      slug: 'satin-draped-midi-slip-dress',
      description:
          'Dress midi berbahan silk-satin mewah dengan detail kerah cowl neck yang anggun untuk acara malam maupun pesta kasual.',
      price: 589000,
      stock: 75,
      imageUrl:
          'https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&w=800&q=80',
    ),
    ProductModel(
      id: 6,
      categoryId: 2,
      category: womenCategory,
      name: 'Double-Breasted Tailored Belted Blazer',
      slug: 'double-breasted-tailored-belted-blazer',
      description:
          'Blazer wanita berpotongan tegas dengan sabuk pinggang lepasan yang menciptakan siluet modern dan profesional.',
      price: 749000,
      stock: 50,
      imageUrl:
          'https://images.unsplash.com/photo-1548624313-0396c75e4b1a?auto=format&fit=crop&w=800&q=80',
    ),
    ProductModel(
      id: 7,
      categoryId: 2,
      category: womenCategory,
      name: 'High-Waist Wide Leg Palazzo Trousers',
      slug: 'high-waist-wide-leg-palazzo-trousers',
      description:
          'Celana kulot high-waist berbahan tencel jatuh yang memberikan kesan kaki jenjang dan kenyamanan sepanjang hari.',
      price: 449000,
      stock: 110,
      imageUrl:
          'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=800&q=80',
    ),
    ProductModel(
      id: 8,
      categoryId: 2,
      category: womenCategory,
      name: 'Ribbed Cashmere Blend Cropped Cardigan',
      slug: 'ribbed-cashmere-blend-cropped-cardigan',
      description:
          'Kardigan rajut bertekstur rib dengan kancing mutiara imitasi, mudah dipadukan dengan rok maupun celana jeans.',
      price: 389000,
      stock: 85,
      imageUrl:
          'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?auto=format&fit=crop&w=800&q=80',
    ),
  ];
}
