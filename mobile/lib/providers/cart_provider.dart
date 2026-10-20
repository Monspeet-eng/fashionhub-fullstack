import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class CartProvider extends ChangeNotifier {
  final ApiService _apiService;

  CartProvider(this._apiService);

  List<CartItemModel> _items = [];
  bool _isLoading = false;
  String _couponCode = '';
  int _discountAmount = 0;
  String? _couponMessage;

  List<CartItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String get couponCode => _couponCode;
  int get discountAmount => _discountAmount;
  String? get couponMessage => _couponMessage;

  int get totalItems =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  int get subtotal =>
      _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  int get grandTotal {
    final total = subtotal - _discountAmount;
    return total < 0 ? 0 : total;
  }

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _apiService.getCart();
      _items = res.items;
      _recalculateDiscount();
    } catch (_) {
      // Gunakan state lokal jika offline
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(ProductModel product, int quantity) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _apiService.addToCart(product.id, quantity);
      _items = res.items;
    } catch (_) {
      // Fallback lokal jika offline
      final index = _items.indexWhere((i) => i.productId == product.id);
      if (index >= 0) {
        _items[index].quantity += quantity;
      } else {
        _items.add(
          CartItemModel(
            id: DateTime.now().millisecondsSinceEpoch,
            productId: product.id,
            product: product,
            quantity: quantity,
          ),
        );
      }
    } finally {
      _recalculateDiscount();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateQuantity(int cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(cartItemId);
      return;
    }
    try {
      final res = await _apiService.updateCartQuantity(cartItemId, newQuantity);
      _items = res.items;
    } catch (_) {
      final idx = _items.indexWhere((i) => i.id == cartItemId);
      if (idx >= 0) {
        _items[idx].quantity = newQuantity;
      }
    }
    _recalculateDiscount();
    notifyListeners();
  }

  Future<void> removeItem(int cartItemId) async {
    try {
      final res = await _apiService.removeCartItem(cartItemId);
      _items = res.items;
    } catch (_) {
      _items.removeWhere((i) => i.id == cartItemId);
    }
    _recalculateDiscount();
    notifyListeners();
  }

  void applyCoupon(String code) {
    final clean = code.trim().toUpperCase();
    _couponCode = clean;
    if (clean.isEmpty) {
      _discountAmount = 0;
      _couponMessage = null;
    } else if (clean == 'FASHION10') {
      _discountAmount = (subtotal * 0.10).round();
      _couponMessage = 'Kupon FASHION10 aktif (Diskon 10%)';
    } else if (clean == 'HEMAT50K') {
      if (subtotal >= 300000) {
        _discountAmount = 50000;
        _couponMessage = 'Kupon HEMAT50K aktif (Potongan Rp 50.000)';
      } else {
        _discountAmount = 0;
        _couponMessage = 'Minimum belanja Rp 300.000 untuk kupon HEMAT50K';
      }
    } else {
      _discountAmount = 0;
      _couponMessage = 'Kode kupon tidak ditemukan (Coba: FASHION10)';
    }
    notifyListeners();
  }

  void _recalculateDiscount() {
    if (_couponCode.isNotEmpty) {
      applyCoupon(_couponCode);
    }
  }

  void clearLocalCart() {
    _items = [];
    _couponCode = '';
    _discountAmount = 0;
    _couponMessage = null;
    notifyListeners();
  }
}
