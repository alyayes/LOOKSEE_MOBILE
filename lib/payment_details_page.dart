import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Wajib import ini untuk fitur Copy
import 'dart:async'; // Untuk Timer
import 'my_orders_page.dart';

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({super.key});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  // TIMER LOGIC
  late Timer _timer;
  Duration _timeLeft = const Duration(hours: 23, minutes: 59, seconds: 59);
  
  // KODE PEMBAYARAN (Simpan di variabel biar mudah dicopy)
  final String _paymentCode = "TRX-684ee79793a4f";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
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
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  // --- FUNGSI COPY CLIPBOARD ---
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _paymentCode)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment Code Copied!"),
          backgroundColor: Color(0xFFFF69B4), // Pink
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPink = Color(0xFFFF69B4);
    const Color lightPinkBg = Color(0xFFFFF0F5);
    const Color darkGrey = Color(0xFF5F6873);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("Payment Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // === 1. COUNTDOWN TIMER ===
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2), 
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.deepOrange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Complete payment in ${_formatDuration(_timeLeft)}",
                    style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // === 2. CARD ORDER INFO ===
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  // Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Status", style: TextStyle(color: Colors.grey)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: lightPinkBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryPink.withOpacity(0.3)),
                        ),
                        child: const Text("Waiting for Payment", style: TextStyle(color: primaryPink, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  _row("Order ID", "#52"),
                  const SizedBox(height: 12),
                  
                  // Payment Method
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Payment Method", style: TextStyle(color: Colors.grey)),
                      Row(
                        children: const [
                          Icon(Icons.account_balance_wallet, color: primaryPink, size: 16),
                          SizedBox(width: 6),
                          Text("E-Wallet (Dana)", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Payment Code Box (Bisa dicopy juga kalau diklik)
                  GestureDetector(
                    onTap: _copyToClipboard,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Payment Code", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Row(
                            children: [
                              Text(_paymentCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5)),
                              const SizedBox(width: 8),
                              const Icon(Icons.copy, size: 16, color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                  ),
                  
                  _row("Total Amount Due", "Rp 347.000", isPink: true),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // === 3. INSTRUCTION ===
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  iconColor: primaryPink,
                  collapsedIconColor: Colors.grey,
                  title: Row(
                    children: [
                      Container(
                        width: 30, height: 30,
                        decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
                        child: const Icon(Icons.wallet, color: Colors.blue, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Text("How to Pay via Dana", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  children: [
                    const Divider(),
                    const SizedBox(height: 10),
                    _stepCircle("1", "Open your Dana application."),
                    _stepCircle("2", "Select 'Send' or 'Transfer' menu."),
                    _stepCircle("3", "Enter destination number: 081122334455\n(Name: LOOKSEE.DANA)"),
                    _stepCircle("4", "Enter payment amount: Rp 347.000."),
                    _stepCircle("5", "Complete the payment."),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: lightPinkBg, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: primaryPink, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Order will be verified automatically after payment.",
                              style: TextStyle(fontSize: 12, color: darkGrey),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // === 4. BOTTOM BUTTONS ===
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          children: [
            // TOMBOL COPY (PINK - SESUAI GAMBAR)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy, size: 18),
                label: const Text("Copy Payment Code", style: TextStyle(fontSize: 13)), // Font agak kecil biar muat
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9EBC), // Pink agak mudaan dikit sesuai gambar
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // TOMBOL BACK (ABU TUA - SESUAI GAMBAR)
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrdersPage())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Back to My Orders", style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String val, {bool isPink = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          val,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isPink ? 18 : 14,
            color: isPink ? const Color(0xFFFF69B4) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _stepCircle(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20, height: 20,
            decoration: const BoxDecoration(color: Color(0xFFFF69B4), shape: BoxShape.circle),
            child: Center(
              child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87))),
        ],
      ),
    );
  }
}