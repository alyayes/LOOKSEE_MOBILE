import 'package:flutter/material.dart';

import 'auth/login.dart';
import 'home/home.dart';
import 'product/product.dart'; 
import 'landing/landing_page.dart';

import 'auth/register_page.dart';
import 'cart/cart_page.dart';
import 'checkout/checkout_page.dart';
import 'orders/my_orders_page.dart';
import 'payment/payment_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterPage(),
        '/cart': (context) => const CartPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/home': (context) => const HomeScreen(), 
        '/product': (context) => const ProductPage(),
      },
    );
  }
}