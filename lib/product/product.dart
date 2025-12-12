import 'package:flutter/material.dart';
import '../navbar/navbar.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List<Map<String, dynamic>> products = [
    {'name': 'Sweatshirt', 'color': Color(0xFFFFB3BA), 'image': 'assets/sweatshirt.jpg'},
    {'name': 'Lily Top', 'color': Color(0xFFBAE1D3), 'image': 'assets/lily top.png'},
    {'name': 'Blue Shirt', 'color': Color(0xFFBAD9E1), 'image': 'assets/blue shirt.jpg'},
    {'name': 'Deluxe Shirt', 'color': Color(0xFFE8E8E8), 'image': 'assets/dobujack shirt.jpg'},
    {'name': 'Sunny Top', 'color': Color(0xFFFFF4BA), 'image': 'assets/sunny top.jpg'},
    {'name': 'Rok Tutu', 'color': Color(0xFFF5F5F5), 'image': 'assets/tutu.jpg'},
    {'name': 'Luxe Cardi', 'color': Color(0xFFBAD9E1), 'image': 'assets/luxe cardi.jpg'},
    {'name': 'Mina Blouse', 'color': Color(0xFFBAE1BA), 'image': 'assets/mina blouse.jpg'},
    {'name': 'Ribonia', 'color': Color(0xFFFFF4BA), 'image': 'assets/ribonia.png'},
    {'name': 'Peony Blouse', 'color': Color(0xFFE8D4E8), 'image': 'assets/peony.png'},
    {'name': 'Cherry Cardi', 'color': Color(0xFFE8E8E8), 'image': 'assets/cherry.jpg'},
    {'name': 'Luna Top', 'color': Color(0xFFBAE1D3), 'image': 'assets/luna top.jpg'},
    {'name': 'Pinky Skirt', 'color': Color(0xFF6B8E9E), 'image': 'assets/pinky skirt.jpg'},
    {'name': 'Winter Top', 'color': Color(0xFF8E9EB3), 'image': 'assets/winter top.jpg'},
    {'name': 'Tiny Blazer', 'color': Color(0xFF2C3E50), 'image': 'assets/tiny blazer.jpg'},
    {'name': 'Arket Shirt', 'color': Color(0xFFFFCCE5), 'image': 'assets/arket shirt.jpg'},
    {'name': 'Alana Top', 'color': Color(0xFF6B7E8E), 'image': 'assets/alana top.jpg'},
    {'name': 'Blue Jeans', 'color': Color(0xFF6B7E8E), 'image': 'assets/blue jeans.jpg'},
    {'name': 'Bluesy Top', 'color': Color(0xFF6B7E8E), 'image': 'assets/blusey top.jpg'},
    {'name': 'Fullo Jacket', 'color': Color(0xFF6B7E8E), 'image': 'assets/fullo jacket.jpg'},
    {'name': 'Blouse Kotak', 'color': Color(0xFF6B7E8E), 'image': 'assets/blouse kotak.jpg'},
    {'name': 'Kulot Jeans', 'color': Color(0xFF6B7E8E), 'image': 'assets/kulot jeans.jpg'},

  ];

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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.black87),
                    onPressed: () {
                      Navigator.pushNamed(context, '/favorite');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: const Text(
                'Your Mood Is Happy!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Product Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return _buildProductItem(products[index]);
                      },
                    ),
                    
                    // Filter Button
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.pink[200]!, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tune, color: Colors.pink[400], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Filter',
                            style: TextStyle(
                              color: Colors.pink[400],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // More Products
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return _buildProductItem(products[index + 12]);
                      },
                    ),
                    
                    // Padding bawah agar tidak tertutup Navbar
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Menggunakan CustomNavBar yang sama seperti di HomeScreen
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        // Navigate ke halaman detail product
        Navigator.pushNamed(context, '/detail');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Product Image
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: product['color'],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    product['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.checkroom,
                          size: 35,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Product Name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                product['name'],
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}