import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../checkout/checkout_page.dart';
import '../services/api_service.dart';

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
          return CartItemModel(
            productId: item['product_id'].toString(),
            title: item['nama_produk'] ?? 'Product',
            price: double.tryParse(item['harga'].toString()) ?? 0,
            image: (item['gambar_produk'] as String).split('/').last,
            quantity: int.tryParse(item['quantity'].toString()) ?? 1,
            maxStock: int.tryParse(item['stock_sisa'].toString()) ?? 0,
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _updateQty(int index, int change) async {
    var item = _cartItems[index];
    int targetQty = item.quantity + change;
    if (targetQty < 1 || targetQty > item.maxStock) return;

    setState(() => item.quantity = targetQty);
    bool ok = await ApiService().updateCartQty(item.productId, targetQty);
    if (!ok) {
      setState(() => item.quantity -= change);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal update server")));
    }
  }

  void _removeItem(int index) async {
    bool ok = await ApiService().deleteCartItem(_cartItems[index].productId);
    if (ok) _fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFF69B4);
    double total = _cartItems.where((i) => i.isSelected).fold(0, (sum, i) => sum + (i.price * i.quantity));

    return Scaffold(
      appBar: AppBar(title: const Text("Cart", style: TextStyle(color: pink, fontWeight: FontWeight.bold)), centerTitle: true),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: pink))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, i) {
                      final item = _cartItems[i];
                      return ListTile(
                        leading: Checkbox(value: item.isSelected, onChanged: (v) => setState(() => item.isSelected = v!)),
                        title: Text(item.title),
                        subtitle: Text("Rp ${item.price} x ${item.quantity}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.remove), onPressed: () => _updateQty(i, -1)),
                            IconButton(icon: const Icon(Icons.add), onPressed: () => _updateQty(i, 1)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => _removeItem(i)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: Rp $total", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: total > 0 ? () {
                          List<String> ids = _cartItems.where((i) => i.isSelected).map((i) => i.productId).toList();
                          Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPage(selectedProductIds: ids)));
                        } : null,
                        style: ElevatedButton.styleFrom(backgroundColor: pink),
                        child: const Text("Checkout", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}