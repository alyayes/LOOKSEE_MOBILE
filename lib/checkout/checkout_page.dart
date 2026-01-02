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
  List<dynamic> _addresses = [];
  List<dynamic> _bankOptions = [];
  List<dynamic> _ewalletOptions = [];
  List<dynamic> _realProducts = [];
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

  void _fetchCheckoutData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
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
          
          _selectedAddressIndex = _addresses.indexWhere((a) => a['is_default'] == 1);
          if (_selectedAddressIndex == -1) _selectedAddressIndex = 0;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddressSelectionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.75,
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
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: isSelected ? const Color(0xFFFF69B4) : Colors.grey.shade200),
                              ),
                              child: ListTile(
                                onTap: () {
                                  setState(() => _selectedAddressIndex = index);
                                  Navigator.pop(context);
                                },
                                title: Text(addr['receiver_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("${addr['phone_number']}\n${addr['full_address']}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                                      onPressed: () => _showAddressFormModal(existingData: addr),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                      onPressed: () async {
                                        bool ok = await ApiService().deleteAddress(addr['id'].toString());
                                        if (ok) {
                                          _fetchCheckoutData();
                                          setModalState(() => _addresses.removeAt(index));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showAddressFormModal(),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF69B4), foregroundColor: Colors.white),
                    child: const Text("Add New Address"),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  void _showAddressFormModal({Map<String, dynamic>? existingData}) {
    final bool isEdit = existingData != null;
    final nameCtrl = TextEditingController(text: isEdit ? existingData['receiver_name'] : "");
    final phoneCtrl = TextEditingController(text: isEdit ? existingData['phone_number'] : "");
    final addrCtrl = TextEditingController(text: isEdit ? existingData['full_address'] : "");
    final cityCtrl = TextEditingController(text: isEdit ? existingData['city'] : "");
    final districtCtrl = TextEditingController(text: isEdit ? existingData['district'] : "");
    final provinceCtrl = TextEditingController(text: isEdit ? existingData['province'] : "");
    final zipCtrl = TextEditingController(text: isEdit ? existingData['postal_code'] : "");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEdit ? "Edit Address" : "New Address"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Receiver Name*")),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone Number*"), keyboardType: TextInputType.phone),
              TextField(controller: addrCtrl, decoration: const InputDecoration(labelText: "Full Address*")),
              TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: "City*")),
              TextField(controller: districtCtrl, decoration: const InputDecoration(labelText: "District*")), 
              TextField(controller: provinceCtrl, decoration: const InputDecoration(labelText: "Province*")),
              TextField(controller: zipCtrl, decoration: const InputDecoration(labelText: "Postal Code*"), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF69B4), foregroundColor: Colors.white),
            onPressed: () async {
              if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty || addrCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data tidak boleh kosong!")));
                return;
              }
              final data = {
                "receiver_name": nameCtrl.text,
                "phone_number": phoneCtrl.text,
                "full_address": addrCtrl.text,
                "city": cityCtrl.text,
                "district": districtCtrl.text,
                "province": provinceCtrl.text,
                "postal_code": zipCtrl.text,
              };
              Navigator.pop(context); 
              setState(() => _isLoading = true);
              bool ok = isEdit 
                  ? await ApiService().updateAddress(existingData['id'].toString(), data)
                  : await ApiService().addAddress(data);
              if (ok) {
                _fetchCheckoutData();
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Address saved successfully!")));
              } else {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to save address.")));
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
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

  void _handlePlaceOrder() async {
    if (_addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tambahkan alamat dulu!")));
      return;
    }
    if (_selectedMethodName != "COD" && _selectedSubOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih Bank atau E-Wallet!")));
      return;
    }
    setState(() => _isProcessing = true);
    String productIds = widget.selectedItems.map((e) => e['product_id']).join(',');
    String currentAddrId = _addresses[_selectedAddressIndex]['id'].toString();

    String? bankId = _selectedMethodName == "Bank Transfer" ? _selectedSubOption['bank_payment_id'].toString() : null;
    String? ewalletId = _selectedMethodName == "E-Wallet" ? _selectedSubOption['e_wallet_payment_id'].toString() : null;

    final result = await ApiService().processCheckout(
      selectedProducts: productIds,
      address_id: currentAddrId,
      payment_method: _selectedMethodName,
      bank_id: bankId,
      ewallet_id: ewalletId,
    );

    setState(() => _isProcessing = false);
    if (result != null && result['status'] == 'success') {
      _showSuccessDialog(result['data']['order_id'].toString());
    } else {
      String msg = result?['message'] ?? "Checkout failed";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void _showSuccessDialog(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 10),
            const Text("Order Placed!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text("Order #$orderId is being processed."),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF69B4), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyOrdersPage())),
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
                  const Text("Shipping Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildAddressSection(addr, pink),
                  const SizedBox(height: 24),
                  const Text("Shipping Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildShippingTile(pink),
                  const SizedBox(height: 24),
                  const Text("Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildProductList(),
                  const SizedBox(height: 24),
                  const Text("Payment Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildPaymentOptions(pink),
                  const SizedBox(height: 120),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomBar(pink),
    );
  }

  Widget _buildAddressSection(dynamic addr, Color pink) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: addr == null
          ? ElevatedButton.icon(onPressed: () => _showAddressFormModal(), icon: const Icon(Icons.add), label: const Text("Add Address"), style: ElevatedButton.styleFrom(backgroundColor: pink, foregroundColor: Colors.white))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(addr['receiver_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    GestureDetector(onTap: _showAddressSelectionModal, child: Text("Change", style: TextStyle(color: pink, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 5),
                Text(addr['phone_number'], style: TextStyle(color: Colors.grey[600])),
                Text(addr['full_address'], style: const TextStyle(height: 1.4)),
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
          const Expanded(child: Text("Regular Shipping (3-5 Days)", style: TextStyle(fontWeight: FontWeight.bold))),
          Text(_formatRp(_summary?['shipping_cost'] ?? 0), style: TextStyle(color: pink, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: _realProducts.map((item) => ListTile(
          leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(item['gambar_produk'], width: 45, height: 45, fit: BoxFit.cover, errorBuilder: (c,e,s)=>const Icon(Icons.image))),
          title: Text(item['nama_produk'], style: const TextStyle(fontSize: 14)),
          subtitle: Text("${item['quantity']} pcs"),
          trailing: Text(_formatRp(item['subtotal']), style: const TextStyle(fontWeight: FontWeight.bold)),
        )).toList(),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? pink : Colors.grey.shade200)),
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
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Wrap(
                spacing: 8, runSpacing: 8,
                children: options.map((opt) {
                  final optId = opt['bank_payment_id'] ?? opt['e_wallet_payment_id'];
                  final selId = _selectedSubOption?['bank_payment_id'] ?? _selectedSubOption?['e_wallet_payment_id'];
                  bool isSub = optId == selId && selId != null;
                  String displayName = opt['bank_name'] ?? opt['ewallet_provider_name'] ?? "Unknown";
                  return ChoiceChip(
                    label: Text(displayName),
                    selected: isSub,
                    onSelected: (val) => setState(() => _selectedSubOption = opt),
                    selectedColor: pink.withOpacity(0.1),
                    labelStyle: TextStyle(color: isSub ? pink : Colors.black, fontSize: 12),
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
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            const Text("Total Price", style: TextStyle(color: Colors.grey, fontSize: 12)),
            Text(_formatRp(_summary?['grand_total'] ?? 0), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]),
          ElevatedButton(
            onPressed: _isProcessing ? null : _handlePlaceOrder,
            style: ElevatedButton.styleFrom(backgroundColor: pink, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            child: _isProcessing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Place Order", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200));
}
