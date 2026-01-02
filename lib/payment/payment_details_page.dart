import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class PaymentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> orderData; // Menerima data pesanan utuh dari MyOrdersPage
  const PaymentDetailsPage({super.key, required this.orderData});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  late Timer _timer;
  Duration _timeLeft = const Duration(hours: 23, minutes: 59, seconds: 59);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() => _timeLeft = _timeLeft - const Duration(seconds: 1));
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data payment dari map orderData
    final payment = widget.orderData['payment'] ?? {};
    final String trxCode = payment['transaction_code'] ?? "N/A";

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("Payment Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(30)),
              child: Text("Selesaikan pembayaran dalam ${_formatDuration(_timeLeft)}", 
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), 
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: Column(
                children: [
                  _row("Order ID", "#${widget.orderData['order_id']}"),
                  const Divider(),
                  _row("Status", widget.orderData['status'].toString().toUpperCase()),
                  const Divider(),
                  _row("Total Tagihan", "Rp ${widget.orderData['grand_total']}", isPink: true),
                  const SizedBox(height: 20),
                  const Text("Kode Pembayaran", style: TextStyle(color: Colors.grey)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(trxCode, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: trxCode));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kode disalin")));
                        }, 
                        icon: const Icon(Icons.copy)
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF69B4), padding: const EdgeInsets.symmetric(vertical: 15)),
          child: const Text("Kembali ke Pesanan Saya", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _row(String label, String val, {bool isPink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(val, style: TextStyle(fontWeight: FontWeight.bold, color: isPink ? const Color(0xFFFF69B4) : Colors.black)),
        ],
      ),
    );
  }
}