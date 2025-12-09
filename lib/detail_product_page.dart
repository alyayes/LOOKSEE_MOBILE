import 'package:flutter/material.dart';
import 'cart_page.dart';

class DetailProductPage extends StatelessWidget {
  const DetailProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Positioned(
            top: 0, left: 0, right: 0,
            height: size.height * 0.5,
            child: Image.network(
              'https://images.unsplash.com/photo-1620799140408-ed5341cd2431?q=80&w=1000',
              fit: BoxFit.cover,
            ),
          ),

          // 2. HEADER ICONS
          Positioned(
            top: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleIcon(Icons.arrow_back, onTap: () {}), // Tombol Back dummy
                _buildCircleIcon(Icons.favorite_border),
              ],
            ),
          ),

          // 3. CONTENT SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.55,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 100),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Happy", style: TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Lily Top", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: const [
                              Icon(Icons.star, color: Colors.orange, size: 18),
                              SizedBox(width: 4),
                              Text("4.9", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("Product Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      "Achieve a chic retro look with this Mint Green knit cardigan featuring classic cream accents. Crafted from soft, breathable textured fabric.",
                      style: TextStyle(color: Colors.grey[600], height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    const Text("Look Style", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
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
                  ],
                ),
              ),
            ),
          ),

          // 4. THUMBNAILS (Floating di tengah perbatasan gambar & sheet)
          Positioned(
            top: (size.height * 0.45) - 30, 
            left: 0, right: 0,
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

          // 5. BOTTOM BAR
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Total Price", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text("Rp295.000", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF69B4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: const Color(0xFFFF69B4).withOpacity(0.5),
                    ),
                    child: const Text("Add to Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper biar kodingan utama bersih
  Widget _buildCircleIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }

  Widget _buildThumbnail(String url, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: const Color(0xFFFF69B4), width: 2) : null,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: isSelected ? [BoxShadow(color: Colors.pink.withOpacity(0.2), blurRadius: 8)] : [],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(url, width: 50, height: 50, fit: BoxFit.cover)),
    );
  }

  Widget _buildUserLook(String url, String name) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(url, width: 90, height: 110, fit: BoxFit.cover)),
        ),
        Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}