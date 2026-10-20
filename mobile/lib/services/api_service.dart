import 'dart:math';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order_invoice.dart';

class ApiService {
  late final Dio _dio;
  String? _sessionId;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 6),
        receiveTimeout: const Duration(seconds: 6),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final sessionId = await _getOrCreateSessionId();
          options.headers['X-Session-ID'] = sessionId;
          return handler.next(options);
        },
      ),
    );
  }

  Future<String> _getOrCreateSessionId() async {
    if (_sessionId != null) return _sessionId!;
    final prefs = await SharedPreferences.getInstance();
    var saved = prefs.getString('fashionhub_session_id');
    if (saved == null || saved.isEmpty) {
      saved = 'sess_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
      await prefs.setString('fashionhub_session_id', saved);
    }
    _sessionId = saved;
    return saved;
  }

  Future<ProductListResult> getProducts({
    String? category,
    int page = 1,
    int limit = 24,
    String sort = 'newest',
  }) async {
    final response = await _dio.get(
      '/products',
      queryParameters: {
        if (category != null && category.isNotEmpty && category != 'All')
          'category': category,
        'page': page,
        'limit': limit,
        'sort': sort,
      },
    );
    return ProductListResult.fromJson(response.data['data']);
  }

  Future<ProductDetailResult> getProductDetail(int id) async {
    final response = await _dio.get('/products/$id');
    return ProductDetailResult.fromJson(response.data['data']);
  }

  Future<CartSummaryModel> getCart() async {
    final response = await _dio.get('/cart');
    return CartSummaryModel.fromJson(response.data['data']);
  }

  Future<CartSummaryModel> addToCart(int productId, int quantity) async {
    final response = await _dio.post(
      '/cart',
      data: {
        'product_id': productId,
        'quantity': quantity,
      },
    );
    return CartSummaryModel.fromJson(response.data['data']);
  }

  Future<CartSummaryModel> updateCartQuantity(int cartItemId, int quantity) async {
    final response = await _dio.put(
      '/cart/$cartItemId',
      data: {'quantity': quantity},
    );
    return CartSummaryModel.fromJson(response.data['data']);
  }

  Future<CartSummaryModel> removeCartItem(int cartItemId) async {
    final response = await _dio.delete('/cart/$cartItemId');
    return CartSummaryModel.fromJson(response.data['data']);
  }

  Future<OrderInvoiceModel> submitCheckout({
    required String email,
    required String firstName,
    required String lastName,
    required String address,
    required String zipCode,
    required String phone,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    String couponCode = '',
    int amountPaid = 0,
  }) async {
    final response = await _dio.post(
      '/checkout',
      data: {
        'contact': {'email': email},
        'shipping': {
          'first_name': firstName,
          'last_name': lastName,
          'address': address,
          'zip_code': zipCode,
          'phone': phone,
        },
        'payment': {
          'card_number': cardNumber,
          'expiry_date': expiryDate,
          'cvv': cvv,
        },
        'coupon_code': couponCode,
        'amount_paid': amountPaid,
      },
    );
    return OrderInvoiceModel.fromJson(response.data['data']);
  }

  Future<void> submitContactMessage({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    await _dio.post(
      '/contact',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'message': message,
      },
    );
  }
}
