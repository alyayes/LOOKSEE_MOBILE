import 'package:flutter/material.dart';
import 'payment_details_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isSelectAllChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Select All Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Checkbox(
                  value: isSelectAllChecked,
                  activeColor: const Color(0xFFFF69B4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (val) => setState(() => isSelectAllChecked = val ?? false),
                ),
                const Text("Select All", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          // Cart List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildCartItem("Lily Top", "M", "Rp295.000", "https://images.unsplash.com/photo-1620799140408-ed5341cd2431?q=80&w=200"),
                _buildCartItem("Luxe Cardy", "S", "Rp249.900", "https://images.unsplash.com/photo-1581044777550-4cfa60707c03?q=80&w=200"),
                _buildCartItem("Sunny Top", "L", "Rp175.900", "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=200"),
                _buildCartItem("Arket Shirt", "M", "Rp247.000", "https://images.unsplash.com/photo-1554568218-0f1715e72254?q=80&w=200"),
              ],
            ),
          ),
        ],
      ),

      // Bottom Bar Checkout
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, -5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Total Price", style: TextStyle(color: Colors.grey)),
                Text("Rp967.800", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Ke halaman Payment Details
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentDetailsPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF69B4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Checkout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, String size, String price, String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Checkbox(
            value: true, 
            activeColor: const Color(0xFFFF69B4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: (v) {},
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imgUrl, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                  ],
                ),
                Text("Size: $size", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold, fontSize: 15)),
                    // Fake Quantity Buttons
                    Row(
                      children: [
                        _qtyBtn(Icons.remove),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("1")),
                        _qtyBtn(Icons.add, isPink: true),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, {bool isPink = false}) {
    return Container(
      width: 24, height: 24,
      decoration: BoxDecoration(
        color: isPink ? const Color(0xFFFF69B4) : Colors.white,
        border: Border.all(color: isPink ? const Color(0xFFFF69B4) : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 14, color: isPink ? Colors.white : Colors.grey),
    );
  }
}