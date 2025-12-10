import 'package:flutter/material.dart';

// Import semua halaman yang sudah dibuat
import 'login.dart';
import 'register_page.dart';
import 'detail_product_page.dart';
import 'cart_page.dart';
import 'checkout_page.dart'; // File baru
import 'payment_details_page.dart';
import 'my_orders_page.dart';

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
        fontFamily: 'Poppins', // Pastikan font ini ada atau gunakan default
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF69B4)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Color(0xFFFF69B4),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      // Ubah ke MainMenuPage() jika ingin melihat daftar semua halaman untuk testing
      // Ubah ke RegisterPage() untuk simulasi aplikasi dari awal
      home: const MainMenuPage(), 
    );
  }
}

// === MENU TESTING NAVIGASI ===
// Halaman ini memudahkanmu untuk mengecek setiap halaman tanpa harus klik-klik dari awal
class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Navigasi Looksee")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Pilih Halaman untuk Dites:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              _navBtn(context, "0. Register Page", const RegisterPage()),
              _navBtn(context, "1. Detail Product (Home)", const DetailProductPage()),
              _navBtn(context, "2. Cart Page", const CartPage()),
              _navBtn(context, "3. Checkout Page", const CheckoutPage()), // Menu baru
              _navBtn(context, "4. Payment Details", const PaymentDetailsPage()),
              _navBtn(context, "5. My Orders", const MyOrdersPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navBtn(BuildContext context, String title, Widget page) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFFF69B4)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          title, 
          style: const TextStyle(
            color: Color(0xFFFF69B4), 
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}