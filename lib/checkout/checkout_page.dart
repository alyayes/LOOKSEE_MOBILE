import 'package:flutter/material.dart';
import '../payment/payment_details_page.dart';
import '../orders/my_orders_page.dart';

// MODEL DATA ALAMAT
class Address {
  String id;
  String name;
  String phone;
  String fullAddress;
  bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.fullAddress,
    this.isDefault = false,
  });
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // STATE PAYMENT
  int _selectedCategory = 2; 
  String _selectedProvider = "COD"; 
  final List<String> _banks = ["Mandiri", "BCA", "BRI", "BNI"];
  final List<String> _ewallets = ["GoPay", "ShopeePay", "OVO"];

  // STATE ADDRESS (Data Dummy)
  List<Address> _addresses = [
    Address(
      id: '1',
      name: "Lucy Maudy",
      phone: "087654321898",
      fullAddress: "Jl. Raya Panjang Pisan, Kab. Kokoyashi, Provinsi Lea Loloya",
      isDefault: true,
    ),
    Address(
      id: '2',
      name: "Lucy Kantor",
      phone: "081234567890",
      fullAddress: "Gedung Cyber 2, Jl. HR Rasuna Said, Jakarta Selatan",
      isDefault: false,
    ),
  ];

  int _selectedAddressIndex = 0;

  // --- LOGIC MODAL SUKSES ORDER (UPDATED WITH GIF) ---
  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User tidak bisa tutup sembarangan
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                // === BAGIAN INI DIGANTI JADI GIF ===
                SizedBox(
                  height: 120, // Ukuran disesuaikan agar pas
                  width: 120,
                  child: Image.asset(
                    'assets/sukses regis.gif', 
                    fit: BoxFit.contain,
                  ),
                ),
                // ===================================

                const SizedBox(height: 10),
                
                // Judul
                const Text(
                  "Order Placed Successfully!",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // Deskripsi
                const Text(
                  "Your order #52 has been processed. Please complete the payment to proceed with shipping.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 30),

                // TOMBOL 1: PAY NOW (Ke Payment Details)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const PaymentDetailsPage())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF69B4),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Pay Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                
                const SizedBox(height: 12),

                // TOMBOL 2: CHECK MY ORDERS (Ke My Orders)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const MyOrdersPage())
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF69B4)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      "Check My Orders", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF69B4))
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- LOGIC ALAMAT ---
  void _showAddressModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Select Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: _addresses.isEmpty 
                    ? const Center(child: Text("No address yet."))
                    : ListView.builder(
                        itemCount: _addresses.length,
                        itemBuilder: (context, index) {
                          final address = _addresses[index];
                          bool isSelected = index == _selectedAddressIndex;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFF0F5) : Colors.white,
                              border: Border.all(color: isSelected ? const Color(0xFFFF69B4) : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() { _selectedAddressIndex = index; });
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(address.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 8),
                                        Text("| ${address.phone}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                        const Spacer(),
                                        if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFFF69B4), size: 20),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(address.fullAddress, style: TextStyle(color: Colors.grey[800], fontSize: 13)),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _showAddressForm(existingAddress: address, index: index);
                                          },
                                          icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
                                          label: const Text("Edit", style: TextStyle(color: Colors.blue, fontSize: 12)),
                                        ),
                                        TextButton.icon(
                                          onPressed: () {
                                            if (_addresses.length > 1) {
                                              setModalState(() {
                                                _addresses.removeAt(index);
                                                if (_selectedAddressIndex >= index) _selectedAddressIndex = 0;
                                              });
                                              setState(() {});
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot delete the last address")));
                                            }
                                          },
                                          icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                                          label: const Text("Delete", style: TextStyle(color: Colors.red, fontSize: 12)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showAddressForm();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF69B4)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("Add New Address", style: TextStyle(color: Color(0xFFFF69B4))),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddressForm({Address? existingAddress, int? index}) {
    final nameCtrl = TextEditingController(text: existingAddress?.name ?? "");
    final phoneCtrl = TextEditingController(text: existingAddress?.phone ?? "");
    final addressCtrl = TextEditingController(text: existingAddress?.fullAddress ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingAddress == null ? "Add Address" : "Edit Address"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name")),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone Number"), keyboardType: TextInputType.phone),
                TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: "Full Address"), maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF69B4), foregroundColor: Colors.white),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && addressCtrl.text.isNotEmpty) {
                  setState(() {
                    if (existingAddress == null) {
                      _addresses.add(Address(
                        id: DateTime.now().toString(),
                        name: nameCtrl.text,
                        phone: phoneCtrl.text,
                        fullAddress: addressCtrl.text,
                      ));
                    } else {
                      _addresses[index!] = Address(
                        id: existingAddress.id,
                        name: nameCtrl.text,
                        phone: phoneCtrl.text,
                        fullAddress: addressCtrl.text,
                        isDefault: existingAddress.isDefault,
                      );
                    }
                  });
                  Navigator.pop(context);
                  _showAddressModal();
                }
              },
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentAddress = _addresses.isNotEmpty ? _addresses[_selectedAddressIndex] : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === 1. ADDRESS SECTION ===
            const Text("Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            InkWell(
              onTap: _showAddressModal,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: currentAddress != null 
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(currentAddress.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(width: 10),
                          Text(currentAddress.phone, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                          const Spacer(),
                          const Text("Change", style: TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(currentAddress.fullAddress, style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4)),
                    ],
                  )
                : const Center(child: Text("Please add an address")),
              ),
            ),

            const SizedBox(height: 24),

            // === 2. SHIPPING METHOD ===
            const Text("Shipping Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Row(
                children: [
                  const Icon(Icons.radio_button_checked, color: Color(0xFFFF69B4), size: 24),
                  const SizedBox(width: 12),
                  const Icon(Icons.local_shipping_outlined, color: Color(0xFFFF69B4), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            children: [
                              TextSpan(text: "Regular Shipping  ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "Rp 0", style: TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("Estimated Delivery: 3-5 business days.", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // === 3. PRODUCTS ===
            const Text("Products (3 items)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildProductItem("Luxe Cardy", "S", "Rp249.900", 'assets/luxe cardy.png'),
                  const Divider(height: 1),
                  _buildProductItem("Sunny Top", "L", "Rp175.900", 'assets/sunny top.png'),
                  const Divider(height: 1),
                  _buildProductItem("Sweet Shirt", "M", "Rp247.000", 'assets/sweet shirt.png'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // === 4. PAYMENT METHOD ===
            const Text("Payment Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildMainPaymentOption(index: 0, title: "Bank Transfer", subOptions: _banks),
            const SizedBox(height: 10),
            _buildMainPaymentOption(index: 1, title: "E-Wallet", subOptions: _ewallets),
            const SizedBox(height: 10),
            _buildMainPaymentOption(index: 2, title: "COD (Cash on Delivery)", subOptions: []),
            
            const SizedBox(height: 100),
          ],
        ),
      ),

      // === 5. BOTTOM BAR ===
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Total Price", style: TextStyle(color: Color(0xFFFF69B4), fontSize: 12)),
                Text("Rp672.800", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _showOrderSuccessDialog(); // PANGGIL DIALOG DENGAN GIF
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF69B4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: const Text("Place Order", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildMainPaymentOption({required int index, required String title, required List<String> subOptions}) {
    bool isCategorySelected = _selectedCategory == index;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCategorySelected ? const Color(0xFFFF69B4) : Colors.grey.shade200,
          width: isCategorySelected ? 1.5 : 1
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _selectedCategory = index;
                if (subOptions.isNotEmpty) _selectedProvider = subOptions[0];
                else _selectedProvider = title;
              });
            },
            leading: Icon(
              isCategorySelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isCategorySelected ? const Color(0xFFFF69B4) : Colors.grey,
            ),
            title: Text(title, style: TextStyle(fontWeight: isCategorySelected ? FontWeight.bold : FontWeight.w500)),
          ),
          if (isCategorySelected && subOptions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                children: subOptions.map((option) => _buildSubOption(option)).toList(),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildSubOption(String optionName) {
    bool isSelected = _selectedProvider == optionName;
    return GestureDetector(
      onTap: () => setState(() => _selectedProvider = optionName),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF0F5) : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFFFF69B4) : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(Icons.account_balance_wallet, size: 18, color: isSelected ? const Color(0xFFFF69B4) : Colors.grey),
            const SizedBox(width: 12),
            Text(optionName, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFFFF69B4) : Colors.black87)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, size: 18, color: Color(0xFFFF69B4)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(String title, String size, String price, String imgUrl) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(imgUrl, width: 70, height: 70, fit: BoxFit.cover)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text("Size: $size", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold, fontSize: 15)),
                    Text("1 pcs", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}