import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/api_service.dart';
import 'providers/catalog_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/checkout_provider.dart';
import 'screens/home_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/invoice_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/contact_us_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CatalogProvider(apiService)),
        ChangeNotifierProvider(create: (_) => CartProvider(apiService)),
        ChangeNotifierProvider(create: (_) => CheckoutProvider(apiService)),
      ],
      child: const FashionHubApp(),
    ),
  );
}

class FashionHubApp extends StatelessWidget {
  const FashionHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FashionHub Mobile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A1A1A),
          primary: const Color(0xFF1A1A1A),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/catalog':
            return MaterialPageRoute(builder: (_) => const CatalogScreen());
          case '/product-detail':
            final productId = (settings.arguments as int?) ?? 1;
            return MaterialPageRoute(
              builder: (_) => ProductDetailScreen(productId: productId),
            );
          case '/checkout':
            return MaterialPageRoute(builder: (_) => const CheckoutScreen());
          case '/invoice':
            return MaterialPageRoute(builder: (_) => const InvoiceScreen());
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutUsScreen());
          case '/contact':
            return MaterialPageRoute(builder: (_) => const ContactUsScreen());
          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
    );
  }
}
