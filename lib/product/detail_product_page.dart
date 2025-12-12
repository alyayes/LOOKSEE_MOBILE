import 'package:flutter/material.dart';
import '../cart/cart_page.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  // --- STATE VARIABLES (Data yang bisa berubah) ---
  
  // 1. Indeks gambar yang sedang dipilih (default 0: gambar pertama)
  int _selectedImageIndex = 0;
  final List<String> _productImages = [
    'https://images.unsplash.com/photo-1620799140408-ed5341cd2431?q=80&w=1000', // Gambar 1 (Depan/Model)
    'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1000', // Gambar 2 (Detail)
    'https://images.unsplash.com/photo-1554568218-0f1715e72254?q=80&w=1000', // Gambar 3 (Belakang/Flatlay)
  ];

  // 2. Ukuran yang sedang dipilih (default 'M')
  String _selectedSize = 'M';
  final List<String> _sizes = ['S', 'M', 'L'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const pinkColor = Color(0xFFFF69B4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ================== BAGIAN ATAS (GAMBAR) ==================
          // 1. GAMBAR UTAMA (Berubah sesuai _selectedImageIndex)
          Positioned(
            top: 0, left: 0, right: 0,
            height: size.height * 0.6, // Tinggi gambar 60% layar
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Image.network(
                _productImages[_selectedImageIndex],
                key: ValueKey<int>(_selectedImageIndex), // Key penting untuk animasi
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          
          // 2. HEADER ICONS (Back & Love)
          Positioned(
            top: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.arrow_back, size: 28),
                Icon(Icons.favorite_border, size: 28),
              ],
            ),
          ),

          // 3. THUMBNAIL GALLERY (Floating di tengah)
          Positioned(
            // Posisikan di perbatasan antara gambar dan sheet putih
            top: (size.height * 0.6) - 40, 
            left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_productImages.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildThumbnail(index),
                );
              }),
            ),
          ),

          // ================== BAGIAN BAWAH (KONTEN SHEET) ==================
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.45, // Tinggi sheet 45% layar
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              // Padding bawah besar (100) agar konten tidak tertutup bottom bar
              padding: const EdgeInsets.fromLTRB(24, 45, 24, 100),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag Happy & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Happy", style: TextStyle(color: pinkColor, fontWeight: FontWeight.bold)),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 24),
                            SizedBox(width: 4),
                            Text("4,9", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    
                    // TITLE
                    const Text("Lily Top", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),

                    // DESCRIPTION
                    const Text("Product Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      "Achieve a chic retro look with this Mint Green knit cardigan featuring classic cream accents. Crafted from soft, breathable textured fabric for all-day comfort.",
                      style: TextStyle(color: Colors.grey[600], height: 1.5),
                    ),
                    const SizedBox(height: 25),

                    // === SIZE SELECTOR (Fitur Baru) ===
                    const Text("Size", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: _sizes.map((sizeBtn) => _buildSizeOption(sizeBtn)).toList(),
                    ),
                    const SizedBox(height: 25),

                    // LOOK STYLE
                    const Text("Look Style", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _userThumb("https://images.unsplash.com/photo-1581044777550-4cfa60707c03?q=80&w=200", "eunsoo0o"),
                          const SizedBox(width: 15),
                          _userThumb("https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200", "priwooa"),
                          const SizedBox(width: 15),
                          _userThumb("https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200", "mello"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // === REVIEW SECTION (Fitur Baru) ===
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Review", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("See all reviews", style: TextStyle(fontSize: 12, color: pinkColor)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: "4,9 ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: pinkColor)),
                          TextSpan(text: "34 reviews", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Horizontal Scrollable Reviews
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                           _buildReviewCard(
                            name: "Luxe", date: "01 Jan", rating: 4,
                            comment: "GEMES BANGETTTT KNITNYA ⭐⭐⭐⭐",
                            avatarUrl: "https://i.pravatar.cc/150?img=40",
                          ),
                          const SizedBox(width: 12),
                          _buildReviewCard(
                            name: "Miewlabide", date: "15 Feb", rating: 5,
                            comment: "So prettyy 😍😭 ⭐⭐⭐⭐⭐",
                            avatarUrl: "https://i.pravatar.cc/150?img=32",
                          ),
                          const SizedBox(width: 12),
                          _buildReviewCard(
                            name: "Nana", date: "20 Feb", rating: 5,
                            comment: "Bahannya adem banget, suka! ⭐⭐⭐⭐⭐",
                            avatarUrl: "https://i.pravatar.cc/150?img=20",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================== BOTTOM BAR (STICKY) ==================
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0,-5))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Total Price", style: TextStyle(color: pinkColor, fontSize: 12)),
                      Text("Rp295.000", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pinkColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: const Text("Add to Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---

  // 1. Widget Thumbnail Interaktif
  Widget _buildThumbnail(int index) {
    bool isSelected = _selectedImageIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedImageIndex = index; // Ubah state gambar utama
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          // Border pink jika dipilih, transparan jika tidak
          border: Border.all(
            color: isSelected ? const Color(0xFFFF69B4) : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected 
              ? [BoxShadow(color: const Color(0xFFFF69B4).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            _productImages[index],
            width: 55, height: 55,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // 2. Widget Pilihan Size Interaktif
  Widget _buildSizeOption(String sizeLabel) {
    bool isSelected = _selectedSize == sizeLabel;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = sizeLabel; // Ubah state ukuran
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        width: 50, height: 50,
        decoration: BoxDecoration(
          // Warna background pink jika dipilih, abu terang jika tidak
          color: isSelected ? const Color(0xFFFF69B4) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF69B4) : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            sizeLabel,
            style: TextStyle(
              // Warna teks putih jika dipilih, hitam jika tidak
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // 3. Widget Kartu Review
  Widget _buildReviewCard({
    required String name,
    required String date,
    required int rating,
    required String comment,
    required String avatarUrl,
  }) {
    return Container(
      width: 280, // Lebar tetap agar bisa di-scroll horizontal
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Review (Avatar, Nama, Tanggal)
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundImage: NetworkImage(avatarUrl)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(date, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Rating Bintang
          Row(
            children: List.generate(5, (index) => Icon(
              Icons.star,
              size: 16,
              color: index < rating ? Colors.amber : Colors.grey.shade300,
            )),
          ),
          const SizedBox(height: 8),
          // Isi Komentar
          Text(
            comment,
            style: const TextStyle(fontSize: 13, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // 4. Widget User Look Style
  Widget _userThumb(String img, String name) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(img, width: 80, height: 100, fit: BoxFit.cover)
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            CircleAvatar(radius: 9, backgroundImage: NetworkImage(img)),
            const SizedBox(width: 5),
            Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}