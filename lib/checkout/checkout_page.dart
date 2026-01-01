import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../payment/payment_details_page.dart';
import '../orders/my_orders_page.dart';
import '../services/api_service.dart';

class CheckoutPage extends StatefulWidget {
  final List<dynamic> selectedItems; // Menerima data dari halaman Cart
  const CheckoutPage({super.key, required this.selectedItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // DATA DARI API
  List<dynamic> _addresses = [];
  List<dynamic> _bankOptions = [];
  List<dynamic> _ewalletOptions = [];
  List<dynamic> _realProducts = []; 
  Map<String, dynamic>? _summary;

  // STATE PEMILIHAN
  int _selectedAddressIndex = 0;
  String _selectedMethodName = "COD"; // Default sesuai backend
  dynamic _selectedSubOption; // Menyimpan objek bank/ewallet yang dipilih

  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _fetchCheckoutData();
  }

  // AMBIL DATA DARI BACKEND (getCheckoutData)
  void _fetchCheckoutData() async {
    setState(() => _isLoading = true);
    try {
      // Gabungkan ID produk menjadi string dipisah koma untuk request query
      String productIds = widget.selectedItems.map((e) => e['product_id']).join(',');
      final response = await ApiService().getCheckoutSummary(productIds);

      if (response != null && response['status'] == 'success') {
        final d = response['data'];
        setState(() {
          _addresses = d['addresses'] ?? [];
          _summary = d['summary'];
          _realProducts = d['items'] ?? [];
          _bankOptions = d['payment_options']['banks'] ?? [];
          _ewalletOptions = d['payment_options']['ewallets'] ?? [];
          
          // Cari index alamat default jika ada
          _selectedAddressIndex = _addresses.indexWhere((a) => a['is_default'] == 1);
          if (_selectedAddressIndex == -1) _selectedAddressIndex = 0;

          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error Fetch Checkout: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // PROSES TEMBAK API CHECKOUT
  void _handlePlaceOrder() async {
    if (_addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please add an address first!")));
      return;
    }

    if (_selectedMethodName != "COD" && _selectedSubOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a bank or e-wallet!")));
      return;
    }

    setState(() => _isProcessing = true);

    String productIds = widget.selectedItems.map((e) => e['product_id']).join(',');
    String currentAddrId = _addresses[_selectedAddressIndex]['id'].toString();

    final result = await ApiService().processCheckout(
      selectedProducts: productIds,
      address_id: currentAddrId,
      payment_method: _selectedMethodName,
      bank_id: _selectedMethodName == "Bank Transfer" ? _selectedSubOption['id'].toString() : null,
      ewallet_id: _selectedMethodName == "E-Wallet" ? _selectedSubOption['id'].toString() : null,
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (result != null && result['status'] == 'success') {
      _showOrderSuccessDialog(result['data']['order_id'].toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result?['message'] ?? "Checkout failed"))
      );
    }
  }

  // DIALOG SUKSES (DENGAN GIF)
  void _showOrderSuccessDialog(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/sukses regis.gif', height: 120, errorBuilder: (c, e, s) => const Icon(Icons.check_circle, size: 80, color: Colors.green)),
            const SizedBox(height: 10),
            const Text("Order Placed Successfully!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text("Your order #$orderId has been processed.", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF69B4), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyOrdersPage()));
                },
                child: const Text("Check My Orders"),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _formatRp(num amount) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount);

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xFFFF69B4);
    final addr = _addresses.isNotEmpty ? _addresses[_selectedAddressIndex] : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(color: pink, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(color: pink))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader("Shipping Address"),
                _buildAddressCard(addr, pink),
                const SizedBox(height: 24),
                _sectionHeader("Shipping Method"),
                _buildShippingTile(pink),
                const SizedBox(height: 24),
                _sectionHeader("Products"),
                _buildProductList(),
                const SizedBox(height: 24),
                _sectionHeader("Payment Method"),
                _buildPaymentOptions(pink),
                const SizedBox(height: 100),
              ],
            ),
          ),
      bottomNavigationBar: _buildBottomBar(pink),
    );
  }

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );

  Widget _buildAddressCard(dynamic addr, Color pink) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: addr == null 
        ? const Center(child: Text("No address found."))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(addr['receiver_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(addr['phone_number'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              Text("${addr['full_address']}, ${addr['city']}, ${addr['province']}", style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4)),
            ],
          ),
    );
  }

  Widget _buildShippingTile(Color pink) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined, color: pink),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Regular Shipping", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("3-5 business days", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(_formatRp(_summary?['shipping_cost'] ?? 0), style: TextStyle(color: pink, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: _realProducts.map((item) {
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(item['gambar_produk'], width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.image)),
            ),
            title: Text(item['nama_produk'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text("${item['quantity']} pcs"),
            trailing: Text(_formatRp(item['subtotal']), style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentOptions(Color pink) {
    return Column(
      children: [
        _methodTile("COD", "COD (Cash on Delivery)", Icons.money, pink),
        _methodTile("Bank Transfer", "Bank Transfer", Icons.account_balance, pink, options: _bankOptions),
        _methodTile("E-Wallet", "E-Wallet", Icons.account_balance_wallet, pink, options: _ewalletOptions),
      ],
    );
  }

  Widget _methodTile(String key, String title, IconData icon, Color pink, {List<dynamic>? options}) {
    bool isSelected = _selectedMethodName == key;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? pink : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() { _selectedMethodName = key; _selectedSubOption = null; }),
            leading: Icon(icon, color: isSelected ? pink : Colors.grey),
            title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            trailing: Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? pink : Colors.grey),
          ),
          if (isSelected && options != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                children: options.map((opt) {
                  bool isSub = _selectedSubOption?['id'] == opt['id'];
                  return ChoiceChip(
                    label: Text(opt['bank_name'] ?? opt['ewallet_name'] ?? ""),
                    selected: isSub,
                    onSelected: (val) => setState(() => _selectedSubOption = opt),
                    selectedColor: pink.withOpacity(0.1),
                    labelStyle: TextStyle(color: isSub ? pink : Colors.black),
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildBottomBar(Color pink) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Total Price", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text(_formatRp(_summary?['grand_total'] ?? 0), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: _isProcessing ? null : _handlePlaceOrder,
            style: ElevatedButton.styleFrom(backgroundColor: pink, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            child: _isProcessing ? const CircularProgressIndicator(color: Colors.white) : const Text("Place Order", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.shade200),
  );
}