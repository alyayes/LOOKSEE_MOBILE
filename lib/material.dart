import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DetailProductPage(),
    );
  }
}

class DetailProductPage extends StatelessWidget {
  const DetailProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ukuran layar
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 1. GAMBAR BACKGROUND UTAMA
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.5, // Setengah layar
            child: Image.network(
              'https://images.unsplash.com/photo-1620799140408-ed5341cd2431?q=80&w=1000&auto=format&fit=crop', // Ganti dengan aset lokalmu nanti
              fit: BoxFit.cover,
            ),
          ),

          // 2. TOMBOL BACK & LOVE (Header)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                const Icon(Icons.favorite_border, color: Colors.black, size: 28),
              ],
            ),
          ),

          // 3. THUMBNAILS (Foto kecil di tengah)
          Positioned(
            top: size.height * 0.35, // Sesuaikan posisi vertikal
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildThumbnail('https://images.unsplash.com/photo-1620799140408-ed5341cd2431?q=80&w=200'),
                const SizedBox(width: 10),
                _buildThumbnail('https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=200', isSelected: true),
                const SizedBox(width: 10),
                _buildThumbnail('https://images.unsplash.com/photo-1554568218-0f1715e72254?q=80&w=200'),
              ],
            ),
          ),

          // 4. KONTEN DETAIL (Sheet Putih)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.55, // Mengambil 55% layar dari bawah
              width: double.infinity,
              padding: const EdgeInsets.only(top: 30, left: 24, right: 24, bottom: 100), // Bottom padding untuk space tombol
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag Pink
                    const Text(
                      "Happy",
                      style: TextStyle(
                        color: Color(0xFFFF69B4), // Warna Pink
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Judul & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Lily Top",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text(
                              "4,9",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Deskripsi
                    const Text(
                      "Product Details",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Achieve a chic retro look with this Mint Green knit cardigan featuring classic cream accents. Crafted from soft, breathable textured fabric for all-day comfort.",
                      style: TextStyle(color: Colors.grey, height: 1.5),
                    ),
                    
                    const SizedBox(height: 24),

                    // Bagian User Photos (Aaa...)
                    const Text(
                      "Look Style", // Saya ganti 'Aaa' jadi Look Style biar rapi
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildUserLook('https://images.unsplash.com/photo-1581044777550-4cfa60707c03?q=80&w=200', 'eunsoo0o'),
                          const SizedBox(width: 12),
                          _buildUserLook('https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200', 'priwooa'),
                          const SizedBox(width: 12),
                          _buildUserLook('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200', 'mello'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    // Review Section (Simple)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: const [
                             Text("Review", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                             Text("4,9 (34 reviews)", style: TextStyle(color: Color(0xFFFF69B4), fontSize: 12)),
                           ],
                         ),
                         TextButton(onPressed: (){}, child: const Text("See all reviews", style: TextStyle(color: Color(0xFFFF69B4))))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

          // 5. BOTTOM BAR (Harga & Tombol Add to Cart)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Total Price", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                        "Rp295.000",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF69B4), // Pink Color
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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

  // Widget kecil untuk Thumbnail Foto
  Widget _buildThumbnail(String imageUrl, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: const Color(0xFFFF69B4), width: 2) : null,
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Widget untuk User Look (foto user di bawah)
  Widget _buildUserLook(String imageUrl, String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: 100,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 5),
            Text(username, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}