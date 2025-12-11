import 'package:flutter/material.dart';
import '../navbar/navbar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data untuk tab PRODUCT (item pakaian individual)
  final List<Map<String, dynamic>> _productItems = [
    {'name': 'Sweatshirt', 'image': 'assets/prod1.jpg'},
    {'name': 'Lisa Blouse', 'image': 'assets/prod2.jpg'},
    {'name': 'Blue Shirt', 'image': 'assets/prod3.jpg'},
    {'name': 'Ribbonie', 'image': 'assets/prod4.jpg'},
    {'name': 'Puff Chin', 'image': 'assets/prod5.jpg'},
    {'name': 'Amora Shirt', 'image': 'assets/prod6.jpg'},
    {'name': 'Luxe Cardi', 'image': 'assets/prod7.jpg'},
    {'name': 'Mina Blouse', 'image': 'assets/prod8.jpg'},
    {'name': 'Blazer Zoe', 'image': 'assets/prod9.jpg'},
    {'name': 'Grey Blazer', 'image': 'assets/prod10.jpg'},
    {'name': 'Luna Top', 'image': 'assets/prod11.jpg'},
    {'name': 'Pinky Skirt', 'image': 'assets/prod12.jpg'},
  ];

  // Data untuk tab STYLE (outfit lengkap dengan mood)
  final List<Map<String, dynamic>> _styleItems = [
    {
      'title': 'Pinky outfit for toda...',
      'user': 'Lucy',
      'mood': 'Happy',
      'image': 'assets/style1.jpg',
    },
    {
      'title': 'Just simple fit',
      'user': 'Louis',
      'mood': 'Neutral',
      'image': 'assets/style2.jpg',
    },
    {
      'title': 'Today\'s Class was...',
      'user': 'Lucy',
      'mood': 'Very Happy',
      'image': 'assets/style3.jpg',
    },
    {
      'title': 'Gloomy day, gloo...',
      'user': 'Louis',
      'mood': 'Sad',
      'image': 'assets/style4.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favorite',
          style: TextStyle(
            color: Color(0xFFFF69B4),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFF69B4),
          labelColor: const Color(0xFFFF69B4),
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: 'Product'),
            Tab(text: 'Style'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab Product - 3 kolom
          _buildProductGrid(),
          
          // Tab Style - 2 kolom  
          _buildStyleGrid(),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85, // Fixed aspect ratio
      ),
      itemCount: _productItems.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_productItems[index]);
      },
    );
  }

  Widget _buildStyleGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75, // Portrait aspect ratio
      ),
      itemCount: _styleItems.length,
      itemBuilder: (context, index) {
        return _buildStyleCard(_styleItems[index]);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10),
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
          // Gambar produk
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.checkroom,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Nama produk
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Center(
                child: Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar outfit - portrait
          Container(
            height: 160, // Fixed height untuk portrait
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              color: Colors.grey,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Info section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // User dan mood
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        item['user'][0],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Username
                    Expanded(
                      child: Text(
                        item['user'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    
                    // Mood badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getMoodColor(item['mood']),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item['mood'],
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Happy':
        return const Color(0xFFFFB6C1); // Pink muda
      case 'Very Happy':
        return const Color.fromARGB(255, 255, 108, 201); // Pink tua
      case 'Neutral':
        return const Color(0xFFD2B48C); // Coklat muda
      case 'Sad':
        return const Color(0xFF87CEEB); // Biru muda
      case 'Very Sad':
        return const Color(0xFF1E90FF); // Biru tua
      default:
        return Colors.grey;
    }
  }
}