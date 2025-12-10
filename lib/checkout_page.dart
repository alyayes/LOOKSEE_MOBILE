import 'package:flutter/material.dart';
import 'payment_details_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // 1. STATE UNTUK KATEGORI PEMBAYARAN
  // 0: Bank Transfer, 1: E-Wallet, 2: COD
  int _selectedCategory = 2; 

  // 2. STATE UNTUK SUB-OPSI (Provider Spesifik)
  String _selectedProvider = "COD"; // Default COD

  // Data List Bank & E-Wallet
  final List<String> _banks = ["Mandiri", "BCA", "BRI", "BNI"];
  final List<String> _ewallets = ["GoPay", "ShopeePay", "OVO"];

  @override
  Widget build(BuildContext context) {
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Lucy Maudy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 10),
                      Text("087654321898", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF69B4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("Default", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Jl. Raya Panjang Pisan, Kab. Kokoyashi, Provinsi Lea Loloya",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                  ),
                ],
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
                        Text(
                          "Estimated Delivery: 3-5 business days.",
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
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
                  _buildProductItem("Luxe Cardy", "S", "Rp249.900", 'https://images.unsplash.com/photo-1581044777550-4cfa60707c03?q=80&w=200'),
                  const Divider(height: 1),
                  _buildProductItem("Sunny Top", "L", "Rp175.900", 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=200'),
                  const Divider(height: 1),
                  _buildProductItem("Arket Shirt", "M", "Rp247.000", 'https://images.unsplash.com/photo-1554568218-0f1715e72254?q=80&w=200'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // === 4. PAYMENT METHOD (UPDATED) ===
            const Text("Payment Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Opsi 0: Bank Transfer (Expandable)
            _buildMainPaymentOption(
              index: 0, 
              title: "Bank Transfer", 
              subOptions: _banks
            ),
            const SizedBox(height: 10),
            
            // Opsi 1: E-Wallet (Expandable)
            _buildMainPaymentOption(
              index: 1, 
              title: "E-Wallet", 
              subOptions: _ewallets
            ),
            const SizedBox(height: 10),
            
            // Opsi 2: COD (Single)
            _buildMainPaymentOption(
              index: 2, 
              title: "COD (Cash on Delivery)", 
              subOptions: [] // Kosong karena COD tidak ada sub-opsi
            ),
            
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
                // Di sini kamu bisa kirim data _selectedProvider ke halaman selanjutnya
                print("Metode Bayar: $_selectedProvider"); 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentDetailsPage()));
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

  // === WIDGET UTAMA ITEM PEMBAYARAN ===
  Widget _buildMainPaymentOption({
    required int index, 
    required String title, 
    required List<String> subOptions
  }) {
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
          // Header Kategori (Bank / E-Wallet / COD)
          ListTile(
            onTap: () {
              setState(() {
                _selectedCategory = index;
                // Auto-select opsi pertama jika ada sub-opsi, jika tidak pilih titlenya (COD)
                if (subOptions.isNotEmpty) {
                  _selectedProvider = subOptions[0];
                } else {
                  _selectedProvider = title;
                }
              });
            },
            leading: Icon(
              isCategorySelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isCategorySelected ? const Color(0xFFFF69B4) : Colors.grey,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: isCategorySelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          // Sub-Opsi (Hanya muncul jika kategori ini dipilih DAN punya sub-opsi)
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

  // === WIDGET SUB-OPSI (Mandiri, BCA, GoPay, dll) ===
  Widget _buildSubOption(String optionName) {
    bool isSelected = _selectedProvider == optionName;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProvider = optionName;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF0F5) : Colors.grey[50], // Pink sangat muda jika dipilih
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF69B4) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            // Bisa diganti logo bank jika ada asset
            Icon(Icons.account_balance_wallet, size: 18, color: isSelected ? const Color(0xFFFF69B4) : Colors.grey),
            const SizedBox(width: 12),
            Text(
              optionName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFFF69B4) : Colors.black87
              ),
            ),
            const Spacer(),
            if (isSelected) 
              const Icon(Icons.check_circle, size: 18, color: Color(0xFFFF69B4)),
          ],
        ),
      ),
    );
  }

  // Widget Item Produk
  Widget _buildProductItem(String title, String size, String price, String imgUrl) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imgUrl, width: 70, height: 70, fit: BoxFit.cover),
          ),
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