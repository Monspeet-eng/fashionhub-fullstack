import 'product.dart';

class CartItemModel {
  final int id;
  final int productId;
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.product,
    required this.quantity,
  });

  int get subtotal => product.price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      product: ProductModel.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 1,
    );
  }
}

class CartSummaryModel {
  final List<CartItemModel> items;
  final int totalItems;
  final int subtotal;
  final bool freeShipping;

  CartSummaryModel({
    required this.items,
    required this.totalItems,
    required this.subtotal,
    required this.freeShipping,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List<dynamic>? ?? [])
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return CartSummaryModel(
      items: list,
      totalItems: json['total_items'] ?? 0,
      subtotal: (json['subtotal'] ?? 0).toInt(),
      freeShipping: json['free_shipping'] ?? true,
    );
  }
}
