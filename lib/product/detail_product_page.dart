import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class DetailProductPage extends StatefulWidget {
  // Menerima data produk dari halaman sebelumnya
  final dynamic productData; 

  const DetailProductPage({Key? key, required this.productData}) : super(key: key);

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  bool _isFavorite = false;
  bool _isAddingToCart = false; // Status loading tombol cart
  
  List<dynamic> _lookStylePosts = [];
  bool _isLoadingLookStyle = true;

  @override
  void initState() {
    super.initState();
    _fetchLookStyles();
  }

  // Ambil data Post (Trends) untuk bagian "Look Style"
  void _fetchLookStyles() async {
    try {
      final posts = await ApiService().getTrends(); 
      if (mounted) {
        setState(() {
          _lookStylePosts = posts;
          _isLoadingLookStyle = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingLookStyle = false);
      print("Error Look Style: $e");
    }
  }

  // --- LOGIC ADD TO CART ---
  void _handleAddToCart() async {
    setState(() => _isAddingToCart = true);

    // Ambil ID Produk dari data yang dikirim (pastikan convert ke String)
    String productId = widget.productData['id_produk'].toString();
    
    // Panggil API (Default qty = 1)
    bool success = await ApiService().addToCart(productId, 1);

    setState(() => _isAddingToCart = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil masuk keranjang!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal. Cek stok atau pastikan sudah Login.'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
    final size = MediaQuery.of(context).size;
    const pinkColor = Color(0xFFFF69B4);

    // --- AMBIL DATA REAL DARI WIDGET ---
    var product = widget.productData;
    String name = product['nama_produk'] ?? 'Product Name';
    String desc = product['deskripsi'] ?? 'No description available.';
    String mood = product['mood'] ?? 'Neutral';
    var price = product['harga'];
    
    // --- LOGIC GAMBAR (ASSET LOKAL) ---
    // Pastikan nama file di DB (misal: "baju.jpg") ada di folder assets/produk-looksee/
    String fileName = product['gambar_produk'] ?? '';
    String assetPath = 'assets/produk-looksee/$fileName';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. SCROLLABLE CONTENT
          CustomScrollView(
            slivers: [
              // Gambar Utama
              SliverToBoxAdapter(
                child: Container(
                  height: size.height * 0.55, 
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Image.asset(
                    assetPath, // Load dari Assets Lokal
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Image.asset('assets/sweatshirt.jpg', fit: BoxFit.cover), // Fallback image
                  ),
                ),
              ),
              
              // Konten Detail (Melengkung)
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                  padding: const EdgeInsets.fromLTRB(25, 30, 25, 120), // Padding bawah besar biar ga ketutup tombol
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mood Label
                      Text(
                        mood,
                        style: const TextStyle(
                          color: pinkColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Nama Produk & Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 24),
                              SizedBox(width: 5),
                              Text(
                                "4,9",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Deskripsi Title
                      const Text(
                        "Product Details",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      
                      // Isi Deskripsi
                      Text(
                        desc,
                        style: TextStyle(
                          color: Colors.grey[600],
                          height: 1.6,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Look Style Section
                      const Text(
                        "Look Style",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      
                      // List Horizontal Postingan
                      SizedBox(
                        height: 110,
                        child: _isLoadingLookStyle 
                          ? const Center(child: CircularProgressIndicator(color: pinkColor))
                          : _lookStylePosts.isEmpty 
                              ? const Text("No styles yet.") 
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _lookStylePosts.length,
                                  itemBuilder: (context, index) {
                                    final post = _lookStylePosts[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: _buildLookStyleItem(post),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // 2. HEADER ICONS (Back & Fav)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, size: 28, color: Colors.black87),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 28,
                    color: _isFavorite ? pinkColor : Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // 3. BOTTOM BAR (Harga & Tombol Add Cart)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  )
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                children: [
                  // Harga di Kiri
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Total Price",
                        style: TextStyle(
                          color: pinkColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                  
                  const SizedBox(width: 20),

                  // Tombol Add Cart di Kanan
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isAddingToCart ? null : _handleAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pinkColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          shadowColor: pinkColor.withOpacity(0.4),
                        ),
                        child: _isAddingToCart
                            ? const SizedBox(
                                height: 25, 
                                width: 25, 
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              )
                            : const Text(
                                "Add to Cart", 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                                )
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

  // Widget Item Look Style
  Widget _buildLookStyleItem(dynamic post) {
    String caption = post['caption'] ?? '';
    // Asumsi gambar post ada di assets (root atau folder post)
    String rawImage = post['image_post'] ?? '';
    String assetPath = 'assets/$rawImage'; 

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 70,
            height: 70,
            color: Colors.grey.shade200,
            child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.image, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 70,
          child: Text(
            caption,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}