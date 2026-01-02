import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class DetailProductPage extends StatefulWidget {
  final dynamic productData;

  const DetailProductPage({Key? key, required this.productData}) : super(key: key);

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  bool _isFavorite = false;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final result = await ApiService().getFavorites();
    if (result != null && result['status'] == 'success') {
      List favorites = result['data']['favorites'] ?? [];
      String currentProductId = widget.productData['id_produk'].toString();
      if (mounted) {
        setState(() {
          _isFavorite = favorites.any((fav) => fav['id_produk'].toString() == currentProductId);
        });
      }
    }
  }

  void _handleToggleFavorite() async {
    String productId = widget.productData['id_produk'].toString();
    final result = await ApiService().toggleFavorite(productId);
    if (result != null) {
      setState(() {
        _isFavorite = result['action'] == 'added';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  void _handleAddToCart() async {
    setState(() => _isAddingToCart = true);
    String productId = widget.productData['id_produk'].toString();
    bool success = await ApiService().addToCart(productId, 1);
    setState(() => _isAddingToCart = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Berhasil masuk keranjang!' : 'Gagal menambahkan ke keranjang.'),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String formatRupiah(dynamic price) {
    double value = double.tryParse(price.toString()) ?? 0;
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const pinkColor = Color(0xFFFF69B4);
    var product = widget.productData;

    String name = product['nama_produk'] ?? 'Product Name';
    String desc = product['deskripsi'] ?? 'No description available.';
    String mood = product['mood'] ?? 'Neutral';
    var price = product['harga'];
    String fileName = product['gambar_produk'] ?? '';
    String assetPath = 'assets/produk-looksee/$fileName';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Konten Utama
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Gambar Produk (Contain agar tidak kepotong)
              SliverToBoxAdapter(
                child: Container(
                  height: size.height * 0.55,
                  width: double.infinity,
                  color: Colors.white, 
                  child: Hero(
                    tag: 'product_${product['id_produk']}',
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.contain, // 🔥 Menjamin gambar tidak kepotong
                        alignment: Alignment.center,
                        errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                  ),
                ),
              ),

              // Panel Detail
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 120),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mood Badge yang rapi
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: pinkColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          mood.toUpperCase(),
                          style: const TextStyle(
                            color: pinkColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Nama Produk
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Deskripsi Produk
                      const Text(
                        "Product Details",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        desc,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.6,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Tombol Kembali & Favorit
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                _buildCircularButton(
                  icon: _isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  color: _isFavorite ? pinkColor : Colors.black87,
                  onTap: _handleToggleFavorite,
                ),
              ],
            ),
          ),

          // Bar Bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Total Price",
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        Text(
                          formatRupiah(price),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isAddingToCart ? null : _handleAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pinkColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          elevation: 0,
                        ),
                        child: _isAddingToCart
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : const Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({required IconData icon, required VoidCallback onTap, Color color = Colors.black87}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}