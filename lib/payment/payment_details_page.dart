import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class PaymentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> orderData;
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

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xFFFF69B4);
    final payment = widget.orderData['payment'] ?? {};
    final String trxCode = payment['transaction_code'] ?? "N/A";
    final String method = widget.orderData['payment_method'] ?? "Transfer";

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(title: const Text("Payment Details"), centerTitle: true, elevation: 0, backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(30)),
              child: Text("Complete payment in ${_formatDuration(_timeLeft)}", 
                style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: Column(
                children: [
                  _row("Order ID", "#${widget.orderData['order_id']}"),
                  const Divider(),
                  _row("Payment Method", method),
                  const SizedBox(height: 20),
                  const Text("Payment Code", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(trxCode, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.copy, color: pink, size: 20),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: trxCode));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Code Copied!")));
                        },
                      )
                    ],
                  ),
                  const Divider(height: 40),
                  _row("Total Payment", "Rp ${widget.orderData['grand_total']}", isPink: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
            Text("How to pay via $method", style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(height: 20),
            const Text("1. Open your payment/banking application.\n2. Select the Transfer/Payment menu.\n3. Enter the payment code above.\n4. Input the exact total amount.\n5. Keep your receipt until verification is complete."),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String val, {bool isPink = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, color: isPink ? const Color(0xFFFF69B4) : Colors.black, fontSize: isPink ? 18 : 14)),
      ],
    );
  }
}