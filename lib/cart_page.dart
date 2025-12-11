import 'package:flutter/material.dart';
import 'checkout_page.dart'; 

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
  // Data Dummy Produk
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

  // Hitung Total
  double get _totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      if (item.isSelected) {
        total += (item.price * item.quantity);
      }
    }
    return total;
  }

  // Cek Select All
  bool get _isAllSelected {
    if (_cartItems.isEmpty) return false;
    return _cartItems.every((item) => item.isSelected);
  }

  // Format Rupiah
  String _formatCurrency(double amount) {
    return "Rp${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Ubah background jadi abu muda biar Card Putih terlihat jelas
      backgroundColor: const Color(0xFFF9F9F9), 
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
          // === HEADER SELECT ALL (Tetap Putih) ===
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                const Text("Select All", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          // === LIST ITEM DENGAN CARD STYLE ===
          Expanded(
            child: _cartItems.isEmpty 
              ? const Center(child: Text("Keranjang kosong"))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _cartItems.length,
                  // Ganti Divider dengan Jarak (SizedBox) karena sudah pakai Card
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildCartItemCard(_cartItems[index], index);
                  },
                ),
          ),

          // === BOTTOM BAR ===
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
                    ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutPage()))
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

  // === WIDGET ITEM BERBENTUK KARTU (CARD) ===
  Widget _buildCartItemCard(CartItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(12), // Padding dalam kartu
      decoration: BoxDecoration(
        color: Colors.white, // Warna kartu putih
        borderRadius: BorderRadius.circular(16), // Sudut membulat
        boxShadow: [
          // Efek bayangan halus biar "pop up"
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Checkbox (di tengah vertikal gambar)
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
          const SizedBox(width: 12),
          
          // 2. Gambar Produk
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(item.image, width: 85, height: 85, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),

          // 3. Detail Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul & Sampah
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _cartItems.removeAt(index);
                        });
                      },
                      child: const Icon(Icons.delete_outline, color: Color(0xFFFF69B4), size: 22),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                Text("Size: ${item.size}", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                const SizedBox(height: 10),
                
                // Harga & Quantity Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatCurrency(item.price), 
                      style: const TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold, fontSize: 15)
                    ),
                    
                    // Quantity Control
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (item.quantity > 1) setState(() => item.quantity--);
                          },
                          child: _qtyBtn(Icons.remove, isFilled: false),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(item.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => item.quantity++),
                          child: _qtyBtn(Icons.add, isFilled: true),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tombol Quantity Kecil
  Widget _qtyBtn(IconData icon, {required bool isFilled}) {
    return Container(
      width: 26, height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? const Color(0xFFFF69B4) : Colors.white,
        border: Border.all(color: const Color(0xFFFF69B4)),
      ),
      child: Icon(
        icon, 
        size: 14, 
        color: isFilled ? Colors.white : const Color(0xFFFF69B4)
      ),
    );
  }

  // Checkbox Custom
  Widget _customCheckbox({required bool value, required Function(bool) onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 22, height: 22,
        decoration: BoxDecoration(
          color: value ? const Color(0xFFFF69B4) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value ? const Color(0xFFFF69B4) : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: value ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
      ),
    );
  }
}