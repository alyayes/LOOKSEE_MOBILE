import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../navbar/navbar.dart';
import '../services/api_service.dart';
import 'detail_product_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    try {
      final data = await ApiService().getProducts();
      if (mounted) {
        setState(() {
          _products = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      print("Error fetching products: $e");
    }
  }

  String formatRupiah(dynamic price) {
    double value = 0;
    if (price != null) {
      value = double.tryParse(price.toString()) ?? 0;
    }
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.favorite_border, color: Colors.black87), onPressed: () => Navigator.pushNamed(context, '/favorite')),
                  IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.black87), onPressed: () {}),
                ],
              ),
            ),
            // Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: const Text('Your Mood Is Happy!', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink)),
            ),
            // Grid
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.pink))
                  : _products.isEmpty
                      ? const Center(child: Text("Belum ada produk."))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.70,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) => _buildProductItem(_products[index]),
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
    );
  }

  Widget _buildProductItem(dynamic product) {
    String name = product['nama_produk'] ?? 'No Name';
    var priceRaw = product['harga'];
    
    // 🔥 AMBIL NAMA FILE DARI DB
    String fileName = product['gambar_produk'] ?? '';
    // 🔥 PATH LOKAL
    String assetPath = 'assets/produk-looksee/$fileName';

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProductPage(productData: product)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    assetPath, // 👈 Panggil Assets Lokal
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(formatRupiah(priceRaw), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.pink)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}