import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'home/home.dart';
import 'product/product.dart';
import 'favorite/favorite.dart';
import 'product/detail_product_page.dart'; // Import detail product

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LOOKSEE',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF69B4)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(), 
        '/product': (context) => const ProductPage(),
        '/favorite': (context) => const FavoritePage(),
        '/detail': (context) => const DetailProductPage(), 
      },
    );
  }
}