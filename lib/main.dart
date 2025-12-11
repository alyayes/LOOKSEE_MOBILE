import 'package:flutter/material.dart';

// Import Landing Page
import 'landing_page.dart';

// Import halaman lain untuk testing (opsional)
import 'register_page.dart';
import 'login.dart';
import 'detail_product_page.dart';
import 'cart_page.dart';
import 'checkout_page.dart';
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
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF69B4)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      ),
      
      // JADIKAN LANDING PAGE SEBAGAI HALAMAN PERTAMA
      home: const LandingPage(), 
    );
  }
}