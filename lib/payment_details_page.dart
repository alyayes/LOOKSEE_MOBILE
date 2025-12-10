import 'package:flutter/material.dart';
import 'my_orders_page.dart';

class PaymentDetailsPage extends StatelessWidget {
  const PaymentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("Payment Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CARD 1: ORDER INFO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _row("Order ID", "#52"),
                  const SizedBox(height: 12),
                  _row("Payment Code", "TRX-684ee79793a4f", isBold: true),
                  const SizedBox(height: 12),
                  _row("Payment Method", "E-Wallet"),
                  const SizedBox(height: 12),
                  _row("E-Wallet Provider", "Dana"),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    // Divider biasa tanpa parameter style
                    child: Divider(thickness: 1, color: Color(0xFFF0F0F0)),
                  ),
                  _row("Total Amount Due", "Rp 347.000", isPink: true),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Pay Before", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text("16 Jun 2025, 22:32 WIB", style: TextStyle(fontSize: 12, color: const Color(0xFFFF69B4))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CARD 2: INSTRUCTIONS
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("How to Pay via Dana", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 15),
                  _step("1. Buka aplikasi Dana Anda."),
                  _step("2. Pilih menu 'Kirim' atau 'Transfer'."),
                  _step("3. Masukkan nomor tujuan: 081122334455"),
                  _step("4. (Atas nama: LOOKSEE.DANA)"),
                  _step("5. Masukkan jumlah pembayaran: Rp 347.000."),
                  _step("6. Selesaikan pembayaran."),
                  const SizedBox(height: 20),
                  Text(
                    "Once payment is successful, your order will be processed immediately. You can check the order status on the My Orders page.",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5),
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
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.copy, size: 16),
                label: const Text("Copy Payment Code"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9EBC), // Pink muda seperti gambar
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrdersPage())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F6873), // Abu-abu tua seperti gambar
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Back to My Orders"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String val, {bool isBold = false, bool isPink = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
        Text(
          val,
          style: TextStyle(
            fontWeight: (isBold || isPink) ? FontWeight.bold : FontWeight.w500,
            fontSize: isPink ? 18 : 13, // Harga lebih besar
            color: isPink ? const Color(0xFFFF69B4) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _step(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87)),
    );
  }
}