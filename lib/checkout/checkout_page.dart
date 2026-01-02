import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../payment/payment_details_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<String> selectedProductIds;
  const CheckoutPage({super.key, required this.selectedProductIds});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<dynamic> _addresses = [];
  Map<String, dynamic>? _summary;
  int _selectedAddressIndex = 0;
  String _selectedMethod = "COD";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final res = await ApiService().getCheckoutSummary(widget.selectedProductIds.join(','));
    if (res != null) {
      setState(() {
        _addresses = res['data']['addresses'];
        _summary = res['data']['summary'];
        _isLoading = false;
      });
    }
  }

  void _handlePlaceOrder() async {
    if (_addresses.isEmpty) return;
    
    final res = await ApiService().processCheckout(
      selectedProducts: widget.selectedProductIds.join(','),
      address_id: _addresses[_selectedAddressIndex]['id'].toString(),
      payment_method: _selectedMethod,
    );

    if (res != null && res['status'] == 'success') {
      if (_selectedMethod == "COD") {
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        // Ambil detail order terbaru untuk payment
        final detail = await ApiService().getOrderDetail(res['data']['order_id'].toString());
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PaymentDetailsPage(orderData: detail!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Alamat Pengiriman", style: TextStyle(fontWeight: FontWeight.bold)),
            ..._addresses.map((a) => RadioListTile(
              title: Text(a['receiver_name']),
              value: _addresses.indexOf(a),
              groupValue: _selectedAddressIndex,
              onChanged: (v) => setState(() => _selectedAddressIndex = v!),
            )),
            const Divider(),
            DropdownButton<String>(
              value: _selectedMethod,
              items: ["COD", "Bank Transfer", "E-Wallet"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedMethod = v!),
            ),
            const Spacer(),
            Text("Total: Rp ${_summary?['grand_total']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _handlePlaceOrder, child: const Text("Buat Pesanan")))
          ],
        ),
      ),
    );
  }
}