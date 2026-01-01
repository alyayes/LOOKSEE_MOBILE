import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../orders/my_orders_page.dart';
import '../services/api_service.dart';

class CheckoutPage extends StatefulWidget {
  final List<dynamic> selectedItems;
  const CheckoutPage({super.key, required this.selectedItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // DATA DARI API
  List<dynamic> _addresses = [];
  List<dynamic> _bankOptions = [];
  List<dynamic> _ewalletOptions = [];
  List<dynamic> _realProducts = []; // Produk hasil kalkulasi server
  Map<String, dynamic>? _summary;

  int _selectedAddressIndex = 0;
  String _selectedMethodName = "COD";
  dynamic _selectedSubOption;

  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _fetchCheckoutData();
  }

  // 1. AMBIL DATA DARI getCheckoutData (Alamat, Produk Real, Summary, Payment Options)
  void _fetchCheckoutData() async {
    setState(() => _isLoading = true);
    try {
      String productIds = widget.selectedItems.map((e) => e.productId).join(',');
      final response = await ApiService().getCheckoutSummary(productIds);

      if (response != null && response['status'] == 'success') {
        final d = response['data'];
        setState(() {
          _addresses = d['addresses'] ?? [];
          _summary = d['summary'];
          _realProducts = d['items'] ?? []; // Mengambil data produk dari server
          _bankOptions = d['payment_options']['banks'] ?? [];
          _ewalletOptions = d['payment_options']['ewallets'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error Fetch Checkout: $e");
      setState(() => _isLoading = false);
    }
  }

  // --- MODAL MANAJEMEN ALAMAT ---
  void _showAddressSelectionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Select Shipping Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: _addresses.isEmpty
                      ? _emptyAddressState()
                      : ListView.builder(
                          itemCount: _addresses.length,
                          itemBuilder: (context, index) {
                            final addr = _addresses[index];
                            bool isSelected = _selectedAddressIndex == index;
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: isSelected ? const Color(0xFFFF69B4) : Colors.grey[200]!),
                              ),
                              child: ListTile(
                                onTap: () {
                                  setState(() => _selectedAddressIndex = index);
                                  Navigator.pop(context);
                                },
                                title: Text(addr['receiver_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("${addr['phone_number']}\n${addr['full_address']}"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () async {
                                    bool ok = await ApiService().deleteAddress(addr['id'].toString());
                                    if (ok) {
                                      _fetchCheckoutData();
                                      setModalState(() => _addresses.removeAt(index));
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _showAddressFormModal(),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFF69B4))),
                    child: const Text("Add New Address", style: TextStyle(color: Color(0xFFFF69B4))),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget _emptyAddressState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_off_outlined, size: 60, color: Colors.grey[400]),
        const SizedBox(height: 10),
        const Text("No address saved yet.", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  // --- FORM TAMBAH ALAMAT (DIALOG) ---
  void _showAddressFormModal() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addrCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final provinceCtrl = TextEditingController();
    final zipCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Address"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Receiver Name")),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone Number")),
              TextField(controller: addrCtrl, decoration: const InputDecoration(labelText: "Full Address")),
              TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: "City")),
              TextField(controller: provinceCtrl, decoration: const InputDecoration(labelText: "Province")),
              TextField(controller: zipCtrl, decoration: const InputDecoration(labelText: "Postal Code")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF69B4), foregroundColor: Colors.white),
            onPressed: () async {
              final data = {
                "receiver_name": nameCtrl.text,
                "phone_number": phoneCtrl.text,
                "full_address": addrCtrl.text,
                "city": cityCtrl.text,
                "province": provinceCtrl.text,
                "postal_code": zipCtrl.text,
              };
              bool ok = await ApiService().addAddress(data);
              if (ok) {
                _fetchCheckoutData();
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Tutup modal list
                _showAddressSelectionModal(); // Buka lagi modal list biar terupdate
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _handlePlaceOrder() async {
    if (_addresses.isEmpty) {
      _showAddressSelectionModal();
      return;
    }

    if (_selectedMethodName != "COD" && _selectedSubOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a bank or e-wallet option!"))
      );
      return;
    }

    setState(() => _isProcessing = true);

    String productIds = widget.selectedItems.map((e) => e.productId).join(',');
    
    // Ambil ID dari alamat yang sedang dipilih
    String currentAddrId = _addresses[_selectedAddressIndex]['id'].toString();

    // Panggil ApiService dengan nama parameter yang sudah disinkronkan
    final result = await ApiService().processCheckout(
      selectedProducts: productIds,
      address_id: currentAddrId,
      payment_method: _selectedMethodName,
      bank_id: _selectedMethodName == "Bank Transfer" ? _selectedSubOption?['id'].toString() : null,
      ewallet_id: _selectedMethodName == "E-Wallet" ? _selectedSubOption?['id'].toString() : null,
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (result != null && result['status'] == 'success') {
      _showSuccessGif(result['data']['order_id'].toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result?['message'] ?? "Gagal memproses pesanan"))
      );
    }
  }

  void _showSuccessGif(String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/gif/sukses regis.gif', height: 120),
            const Text("Order Placed!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 10),
            Text("Order #$id is being processed."),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF69B4), foregroundColor: Colors.white),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyOrdersPage())),
                child: const Text("Go to My Orders"),
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
    const pink = Color(0xFFFF69B4);
    final addr = _addresses.isNotEmpty ? _addresses[_selectedAddressIndex] : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(title: const Text("Checkout", style: TextStyle(color: pink, fontWeight: FontWeight.bold)), centerTitle: true, backgroundColor: Colors.white, elevation: 0, leading: const BackButton(color: Colors.black)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: pink))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _buildAddressPreview(addr, pink),
                  
                  const SizedBox(height: 25),
                  const Text("Shipping Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _buildShippingTile(pink),

                  const SizedBox(height: 25),
                  Text("Products (${_realProducts.length} items)", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _buildProductList(),

                  const SizedBox(height: 25),
                  const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _methodTile("COD", "COD (Cash on Delivery)", Icons.money, pink),
                  _methodTile("Bank Transfer", "Bank Transfer", Icons.account_balance, pink, options: _bankOptions),
                  _methodTile("E-Wallet", "E-Wallet", Icons.account_balance_wallet, pink, options: _ewalletOptions),
                  const SizedBox(height: 120),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomBar(pink),
    );
  }

  Widget _buildAddressPreview(dynamic addr, Color pink) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: addr == null
          ? Center(child: TextButton(onPressed: _showAddressSelectionModal, child: const Text("+ Add Shipping Address")))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(addr['receiver_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    GestureDetector(onTap: _showAddressSelectionModal, child: Text("Change", style: TextStyle(color: pink, fontWeight: FontWeight.bold, fontSize: 12))),
                  ],
                ),
                Text(addr['phone_number'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                Text(addr['full_address'], style: const TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
    );
  }

  Widget _buildShippingTile(Color pink) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(12), 
      border: Border.all(color: Colors.grey[200]!)
    ),
    child: Row(
      children: [
        Icon(Icons.radio_button_checked, color: pink),
        const SizedBox(width: 15),
        // HAPUS kata 'const' di depan Expanded atau Column di bawah ini
        Expanded( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Regular Shipping", style: TextStyle(fontWeight: FontWeight.bold)),
              const Text("Estimated Delivery: 3-5 days", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Text(
          _formatRp(_summary?['shipping_cost'] ?? 0), 
          style: TextStyle(color: pink, fontWeight: FontWeight.bold)
        ),
      ],
    ),
  );
}

  Widget _buildProductList() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: _realProducts.map((item) {
          // Ambil nama file saja untuk assets lokal
          String fullUrl = item['gambar_produk'] ?? '';
          String fileName = fullUrl.split('/').last; 
          return ListTile(
            leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('assets/produk-looksee/$fileName', width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (ctx,e,s) => const Icon(Icons.image))),
            title: Text(item['nama_produk'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text("Qty: ${item['quantity']}"),
            trailing: Text(_formatRp(item['subtotal']), style: const TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold)),
          );
        }).toList(),
      ),
    );
  }

  Widget _methodTile(String key, String title, IconData icon, Color pink, {List<dynamic>? options}) {
    bool isSelected = _selectedMethodName == key;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? pink : Colors.grey[200]!)),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() { _selectedMethodName = key; _selectedSubOption = null; }),
            leading: Icon(icon, color: isSelected ? pink : Colors.grey),
            title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            trailing: Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? pink : Colors.grey),
          ),
          if (isSelected && options != null && options.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: Wrap(
                spacing: 10,
                children: options.map((opt) {
                  bool isSub = _selectedSubOption?['id'] == opt['id'];
                  return ChoiceChip(
                    label: Text(opt['bank_name'] ?? opt['ewallet_name'] ?? ""),
                    selected: isSub,
                    onSelected: (val) => setState(() => _selectedSubOption = opt),
                    selectedColor: pink.withOpacity(0.2),
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
    num grandTotal = _summary?['grand_total'] ?? 0;
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            const Text("Total Price", style: TextStyle(color: Colors.grey, fontSize: 11)),
            Text(_formatRp(grandTotal), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          ElevatedButton(
            onPressed: _isProcessing ? null : _handlePlaceOrder,
            style: ElevatedButton.styleFrom(backgroundColor: pink, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
            child: _isProcessing ? const SizedBox(width:20, height:20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Place Order"),
          )
        ],
      ),
    );
  }
}