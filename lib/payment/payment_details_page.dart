import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class PaymentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> orderData; // Tambahkan parameter untuk menerima data order
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
        if (mounted) setState(() => _timeLeft -= const Duration(seconds: 1));
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Code Copied!"), backgroundColor: Color(0xFFFF69B4)));
    });
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFF69B4);
    // Ambil data payment dari map orderData
    final payment = widget.orderData['payment'] ?? {};
    final String trxCode = payment['transaction_code'] ?? "N/A";
    final String method = widget.orderData['payment_method'] ?? "Transfer";

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(title: const Text("Payment Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), centerTitle: true, elevation: 0, backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.deepOrange, size: 20),
                  const SizedBox(width: 8),
                  Text("Complete payment in ${_formatDuration(_timeLeft)}", style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: Column(
                children: [
                  _row("Status", "Waiting for Payment", isPink: true),
                  const Divider(height: 30),
                  _row("Order ID", "#${widget.orderData['order_id']}"),
                  const SizedBox(height: 12),
                  _row("Payment Method", method),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Payment Code", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Row(children: [
                          Text(trxCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(onPressed: () => _copyToClipboard(trxCode), icon: const Icon(Icons.copy, size: 18, color: pink))
                        ])
                      ],
                    ),
                  ),
                  const Divider(height: 30),
                  _row("Total Amount", "Rp ${widget.orderData['grand_total']}", isBold: true, fontSize: 18),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInstructions(method),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: pink, padding: const EdgeInsets.symmetric(vertical: 15), shape: const StadiumBorder()),
          child: const Text("Back to My Orders", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildInstructions(String method) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("How to pay via $method", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(height: 20),
            const Text("1. Open your payment app\n2. Choose Transfer or Pay menu\n3. Enter the payment code provided above\n4. Ensure the amount matches exactly\n5. Confirm and complete your transaction"),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String val, {bool isPink = false, bool isBold = false, double fontSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(val, style: TextStyle(fontWeight: isBold || isPink ? FontWeight.bold : FontWeight.normal, fontSize: fontSize, color: isPink ? const Color(0xFFFF69B4) : Colors.black)),
      ],
    );
  }
}