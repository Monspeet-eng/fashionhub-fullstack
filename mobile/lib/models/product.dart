class CategoryModel {
  final int id;
  final String name;
  final String slug;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class ProductModel {
  final int id;
  final int categoryId;
  final CategoryModel category;
  final String name;
  final String slug;
  final String description;
  final int price;
  final int stock;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.category,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      category: CategoryModel.fromJson(json['category'] ?? {}),
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toInt(),
      stock: json['stock'] ?? 100,
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class ProductListResult {
  final List<ProductModel> products;
  final int total;
  final int page;
  final int limit;
  final String showingText;

  ProductListResult({
    required this.products,
    required this.total,
    required this.page,
    required this.limit,
    required this.showingText,
  });

  factory ProductListResult.fromJson(Map<String, dynamic> json) {
    final list = (json['products'] as List<dynamic>? ?? [])
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return ProductListResult(
      products: list,
      total: json['total'] ?? list.length,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 24,
      showingText:
          json['showing_text'] ?? 'Showing 1 - ${list.length} of ${list.length} results',
    );
  }
}

class ProductDetailResult {
  final ProductModel product;
  final List<ProductModel> relatedProducts;

  ProductDetailResult({
    required this.product,
    required this.relatedProducts,
  });

  factory ProductDetailResult.fromJson(Map<String, dynamic> json) {
    final related = (json['related_products'] as List<dynamic>? ?? [])
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return ProductDetailResult(
      product: ProductModel.fromJson(json['product'] ?? {}),
      relatedProducts: related,
    );
  }
}
