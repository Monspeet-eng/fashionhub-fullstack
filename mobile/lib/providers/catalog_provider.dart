import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/mock_fallback_data.dart';

class CatalogProvider extends ChangeNotifier {
  final ApiService _apiService;

  CatalogProvider(this._apiService);

  List<ProductModel> _products = [];
  List<ProductModel> _relatedProducts = [];
  ProductModel? _selectedProduct;
  String _selectedCategory = 'All';
  String _sortBy = 'newest';
  String _showingText = 'Showing 1 - 8 of 8 results';
  bool _isLoading = false;
  String? _errorMessage;
  bool _usingOfflineFallback = false;

  List<ProductModel> get products => _products;
  List<ProductModel> get relatedProducts => _relatedProducts;
  ProductModel? get selectedProduct => _selectedProduct;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;
  String get showingText => _showingText;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get usingOfflineFallback => _usingOfflineFallback;

  Future<void> fetchProducts({String? category, String? sort}) async {
    if (category != null) _selectedCategory = category;
    if (sort != null) _sortBy = sort;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.getProducts(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        sort: _sortBy,
      );
      _products = result.products;
      _showingText = result.showingText;
      _usingOfflineFallback = false;
    } catch (e) {
      // Fallback otomatis ke data mock jika backend Golang belum dinyalakan
      _usingOfflineFallback = true;
      _errorMessage =
          'Mode Demo Offline aktif (Server API Golang tidak terjangkau). Menampilkan katalog lokal.';
      var list = List<ProductModel>.from(MockFallbackData.products);
      if (_selectedCategory != 'All') {
        list = list
            .where((p) =>
                p.category.name.toLowerCase() ==
                _selectedCategory.toLowerCase())
            .toList();
      }
      if (_sortBy == 'price_asc') {
        list.sort((a, b) => a.price.compareTo(b.price));
      } else if (_sortBy == 'price_desc') {
        list.sort((a, b) => b.price.compareTo(a.price));
      }
      _products = list;
      _showingText =
          'Showing ${list.isEmpty ? 0 : 1} - ${list.length} of ${list.length} results';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductDetail(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.getProductDetail(productId);
      _selectedProduct = result.product;
      _relatedProducts = result.relatedProducts;
      _usingOfflineFallback = false;
    } catch (_) {
      _usingOfflineFallback = true;
      final found = MockFallbackData.products.firstWhere(
        (p) => p.id == productId,
        orElse: () => MockFallbackData.products.first,
      );
      _selectedProduct = found;
      _relatedProducts = MockFallbackData.products
          .where((p) => p.categoryId == found.categoryId && p.id != found.id)
          .take(4)
          .toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
