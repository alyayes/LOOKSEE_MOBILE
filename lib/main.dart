import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'detail_product_page.dart';
import 'my_orders_page.dart';
import 'payment_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Looksee App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF69B4)),
        useMaterial3: true,
      ),
      // Halaman pertama yang muncul adalah Detail Product
      home: const CartPage(),
    );
  }
}