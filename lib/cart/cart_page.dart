import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../checkout/checkout_page.dart';
import '../services/api_service.dart';

// Model data untuk sinkronisasi UI dan Database
class CartItemModel {
  String productId;
  String title;
  double price;
  String image;
  int quantity;
  int maxStock;
  bool isSelected;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
    required this.maxStock,
    this.isSelected = true,
  });
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItemModel> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  void _fetchCart() async {
    setState(() => _isLoading = true);
    try {
      final items = await ApiService().getCartItems();
      
      setState(() {
        _cartItems = items.map((item) {
          String fullUrl = item['gambar_produk'] ?? '';
          String fileName = fullUrl.split('/').last; 

          return CartItemModel(
            productId: item['product_id'].toString(), 
            title: item['nama_produk'] ?? 'Product',
            price: double.tryParse(item['harga'].toString()) ?? 0,
            image: fileName, 
            quantity: int.tryParse(item['quantity'].toString()) ?? 1,
            maxStock: int.tryParse(item['stock_sisa'].toString()) ?? 0, // Mengambil data stok
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Cart Parse Error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _toggleSelectAll(bool? val) {
    setState(() {
      for (var item in _cartItems) {
        item.isSelected = val ?? false;
      }
    });
  }

  void _updateQty(int index, int change) async {
    var item = _cartItems[index];
    int targetQty = item.quantity + change;

    if (targetQty < 1) return;
    if (targetQty > item.maxStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Stok terbatas! Sisa stok: ${item.maxStock}"))
      );
      return;
    }

    setState(() => item.quantity = targetQty);

    bool ok = await ApiService().updateCartQty(item.productId, targetQty);
    if (!ok) {
      setState(() => item.quantity -= change); 
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal update server")));
    }
  }

  void _removeItem(int index) async {
    var item = _cartItems[index];
    setState(() => _isLoading = true);
    bool ok = await ApiService().deleteCartItem(item.productId);
    if (ok) {
      _fetchCart(); 
    } else {
      setState(() => _isLoading = false);
    }
  }

  double get _totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      if (item.isSelected) {
        total += (item.price * item.quantity);
      }
    }
    return total;
  }

  bool get _isAllSelected => _cartItems.isNotEmpty && _cartItems.every((item) => item.isSelected);

  String _formatRp(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFF69B4);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("Cart", style: TextStyle(color: pink, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: pink))
          : _cartItems.isEmpty
              ? const Center(child: Text("Keranjang kosong bang, belanja yuk!"))
              : Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          _checkboxCustom(_isAllSelected, (val) => _toggleSelectAll(val)),
                          const SizedBox(width: 12),
                          const Text("Select All", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _cartItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 15),
                        itemBuilder: (ctx, i) => _buildItemCard(_cartItems[i], i),
                      ),
                    ),
                    _buildBottomBar(pink),
                  ],
                ),
    );
  }

  Widget _buildItemCard(CartItemModel item, int index) {
    const pink = Color(0xFFFF69B4);
    String localPath = 'assets/produk-looksee/${item.image}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          _checkboxCustom(item.isSelected, (val) => setState(() => item.isSelected = val!)),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              localPath,
              width: 85, height: 85, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 85, height: 85, 
                color: Colors.grey[200], 
                child: const Icon(Icons.broken_image, color: Colors.grey)
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          const SizedBox(height: 4),
                          Text(_formatRp(item.price), style: const TextStyle(color: pink, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _removeItem(index), 
                      icon: Icon(Icons.delete_outline, color: pink, size: 22)
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TULISAN STOK (Di bawah icon delete, di atas/samping tombol qty)
                    Text(
                      "Stock: ${item.maxStock}", 
                      style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.w500)
                    ),
                    const SizedBox(width: 15),
                    Row(
                      children: [
                        _qtyBtn(Icons.remove, () => _updateQty(index, -1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12), 
                          child: Text(item.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                        ),
                        _qtyBtn(Icons.add, () => _updateQty(index, 1), isAdd: true),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomBar(Color pink) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Total Price", style: TextStyle(color: pink, fontSize: 12, fontWeight: FontWeight.bold)),
              Text(_formatRp(_totalPrice), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: _totalPrice > 0 
                ? () {
                    // KODE BARU (Benar):
                    List<Map<String, dynamic>> selected = _cartItems
                        .where((i) => i.isSelected)
                        .map((item) => {
                              'product_id': item.productId, // Pastikan key ini sama dengan yang diminta CheckoutPage
                            })
                        .toList();
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPage(selectedItems: selected)));
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: pink, 
              foregroundColor: Colors.white, 
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
            ),
            child: const Text("Checkout", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback tap, {bool isAdd = false}) {
    return InkWell(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle, 
          color: isAdd ? const Color(0xFFFF69B4) : Colors.white, 
          border: Border.all(color: const Color(0xFFFF69B4))
        ),
        child: Icon(icon, size: 14, color: isAdd ? Colors.white : const Color(0xFFFF69B4)),
      ),
    );
  }

  Widget _checkboxCustom(bool isSelected, Function(bool?) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Container(
        width: 22, height: 22,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF69B4) : Colors.transparent, 
          borderRadius: BorderRadius.circular(6), 
          border: Border.all(color: isSelected ? const Color(0xFFFF69B4) : Colors.grey.shade400, width: 1.5)
        ),
        child: isSelected ? Icon(Icons.check, size: 16, color: Colors.white) : null,
      ),
    );
  }
}