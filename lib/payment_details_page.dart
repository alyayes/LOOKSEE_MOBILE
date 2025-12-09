import 'package:flutter/material.dart';
import 'my_orders_page.dart';

class PaymentDetailsPage extends StatelessWidget {
  const PaymentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card 1: Details
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  _row("Order ID", "#52"),
                  const Divider(height: 24),
                  _row("Payment Code", "TRX-684ee79793a4f", isBold: true),
                  const SizedBox(height: 12),
                  _row("Total Amount", "Rp 347.000", isPink: true),
                  const SizedBox(height: 12),
                  _row("Pay Before", "16 Jun 2025, 22:32 WIB", isSmall: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Card 2: Instructions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Logo_dana_blue.svg/1200px-Logo_dana_blue.svg.png", height: 20), // Logo Dana Dummy
                      const SizedBox(width: 10),
                      const Text("How to Pay via Dana", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "1. Buka aplikasi Dana Anda.\n2. Pilih menu 'Kirim' atau 'Transfer'.\n3. Masukkan nomor tujuan: 081122334455\n4. (Atas nama: LOOKSEE.DANA)\n5. Masukkan jumlah: Rp 347.000.\n6. Selesaikan pembayaran.",
                    style: TextStyle(height: 1.8, color: Colors.black87, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFFFF69B4)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Copy Code", style: TextStyle(color: Color(0xFFFF69B4))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                   // Navigasi ke My Orders setelah bayar
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrdersPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Check Orders", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String val, {bool isBold = false, bool isPink = false, bool isSmall = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(val, style: TextStyle(
          fontWeight: isBold || isPink ? FontWeight.bold : FontWeight.w500,
          color: isPink ? const Color(0xFFFF69B4) : (isSmall ? Colors.red : Colors.black),
          fontSize: isPink ? 18 : (isSmall ? 12 : 14)
        )),
      ],
    );
  }
}