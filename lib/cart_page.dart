import 'package:flutter/material.dart';
import 'checkout_page.dart'; // Pastikan file ini sudah dibuat dari langkah sebelumnya

// Model Data untuk Keranjang
class CartItem {
  String id;
  String title;
  String size;
  double price;
  String image;
  int quantity;
  bool isSelected;

  CartItem({
    required this.id,
    required this.title,
    required this.size,
    required this.price,
    required this.image,
    this.quantity = 1,
    this.isSelected = true,
  });
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Data Dummy Produk di Keranjang
  final List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      title: "Lily Top",
      size: "M",
      price: 295000,
      image: 'assets/lily top.png',
    ),
    CartItem(
      id: '2',
      title: "Luxe Cardy",
      size: "S",
      price: 249900,
      image: 'assets/luxe cardy.png',
    ),
    CartItem(
      id: '3',
      title: "Sunny Top",
      size: "L",
      price: 175900,
      image: 'assets/sunny top.png',
    ),
    CartItem(
      id: '4',
      title: "Sweet Shirt",
      size: "M",
      price: 247000,
      image: 'assets/sweet shirt.png',
    ),
  ];

  // Hitung Total Harga (Hanya yang dicentang)
  double get _totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      if (item.isSelected) {
        total += (item.price * item.quantity);
      }
    }
    return total;
  }

  // Cek Status Select All
  bool get _isAllSelected {
    if (_cartItems.isEmpty) return false;
    return _cartItems.every((item) => item.isSelected);
  }

  // Helper Format Rupiah Manual
  String _formatCurrency(double amount) {
    return "Rp${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Cart",
          style: TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // === 1. SELECT ALL HEADER ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _customCheckbox(
                  value: _isAllSelected,
                  onChanged: (val) {
                    setState(() {
                      for (var item in _cartItems) {
                        item.isSelected = val;
                      }
                    });
                  },
                ),
                const SizedBox(width: 12),
                const Text("Select All", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // === 2. LIST ITEMS ===
          Expanded(
            child: _cartItems.isEmpty 
              ? const Center(child: Text("Keranjang kosong"))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: _cartItems.length,
                  // Garis pemisah antar item
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(thickness: 1, color: Color(0xFFF5F5F5)),
                  ),
                  itemBuilder: (context, index) {
                    return _buildCartItemTile(_cartItems[index], index);
                  },
                ),
          ),

          // === 3. BOTTOM CHECKOUT BAR ===
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Total Price", style: TextStyle(color: Color(0xFFFF69B4), fontSize: 12)),
                    Text(
                      _formatCurrency(_totalPrice),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _totalPrice > 0 
                    ? () {
                        // NAVIGASI KE HALAMAN CHECKOUT
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutPage()));
                      }
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF69B4),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text("Checkout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // WIDGET ITEM KERANJANG
  Widget _buildCartItemTile(CartItem item, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox Item
        Padding(
          padding: const EdgeInsets.only(top: 35),
          child: _customCheckbox(
            value: item.isSelected,
            onChanged: (val) {
              setState(() {
                item.isSelected = val;
              });
            },
          ),
        ),
        const SizedBox(width: 15),
        
        // Gambar Produk
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(item.image, width: 85, height: 85, fit: BoxFit.cover),
        ),
        const SizedBox(width: 15),

        // Detail Produk
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  // Tombol Hapus (Sampah Pink)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _cartItems.removeAt(index);
                      });
                    },
                    child: const Icon(Icons.delete_outline, color: Color(0xFFFF69B4), size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text("Size: ${item.size}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 8),
              Text(
                _formatCurrency(item.price), 
                style: const TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold, fontSize: 16)
              ),
              const SizedBox(height: 10),
              
              // Quantity Control
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item.quantity > 1) setState(() => item.quantity--);
                    },
                    child: _qtyBtn(Icons.remove, isFilled: false),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(item.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => item.quantity++),
                    child: _qtyBtn(Icons.add, isFilled: true),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // Widget Tombol Quantity (+/-)
  Widget _qtyBtn(IconData icon, {required bool isFilled}) {
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? const Color(0xFFFF69B4) : Colors.white,
        border: Border.all(color: const Color(0xFFFF69B4)),
      ),
      child: Icon(
        icon, 
        size: 16, 
        color: isFilled ? Colors.white : const Color(0xFFFF69B4)
      ),
    );
  }

  // Widget Checkbox Custom (Kotak Pink)
  Widget _customCheckbox({required bool value, required Function(bool) onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
          color: value ? const Color(0xFFFF69B4) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: value ? const Color(0xFFFF69B4) : Colors.grey.shade400
          ),
        ),
        child: value ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
      ),
    );
  }
}