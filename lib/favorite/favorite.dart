import 'package:flutter/material.dart';
import '../navbar/navbar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data untuk Style Tab (mirip Today's Outfit)
  final List<Map<String, dynamic>> _styleItems = [
    {
      'title': 'Pinky Outfit for today',
      'user': 'Lucy',
      'mood': 'Happy',
      'moodColor': const Color(0xFFFF69B4),
      'image': 'assets/to1.jpg',
      'profileColor': const Color(0xFFF5C7C7),
    },
    {
      'title': 'Simple Fit',
      'user': 'Louis',
      'mood': 'Neutral',
      'moodColor': const Color(0xFFD4D4D4),
      'image': 'assets/to6.jpeg',
      'profileColor': const Color(0xFFB0C4DE),
    },
    {
      'title': "Today's Class was so nice",
      'user': 'Lucy',
      'mood': 'Very Happy',
      'moodColor': const Color(0xFFFF1493),
      'image': 'assets/to7.jpg',
      'profileColor': const Color(0xFFF5C7C7),
    },
    {
      'title': 'Gloomy daf, gloomy outfit',
      'user': 'Louis',
      'mood': 'Sad',
      'moodColor': const Color(0xFFADD8E6),
      'image': 'assets/to11.jpeg',
      'profileColor': const Color(0xFFB0C4DE),
    },
    {
      'title': 'Red White Fit in today',
      'user': 'Celine',
      'mood': 'Happy',
      'moodColor': const Color(0xFFFF69B4),
      'image': 'assets/to13.jpg',
      'profileColor': const Color(0xFFFFB6C1),
    },
    {
      'title': 'Yeah',
      'user': 'Velia',
      'mood': 'Neutral',
      'moodColor': const Color.fromARGB(255, 241, 204, 133),
      'image': 'assets/to14.jpg',
      'profileColor': const Color(0xFF87CEEB),
    },
    {
      'title': 'Warm like the suit...',
      'user': 'Livy',
      'mood': 'Very Happy',
      'moodColor': const Color(0xFFFF1493),
      'image': 'assets/to15.jpg',
      'profileColor': const Color(0xFFFFC0CB),
    },
    {
      'title': 'Blazer',
      'user': 'Whooly',
      'mood': 'Happy',
      'moodColor': const Color(0xFFFF69B4),
      'image': 'assets/to16.jpg',
      'profileColor': const Color(0xFF4682B4),
    },
  ];

  // Data untuk Product Tab
  final List<Map<String, dynamic>> _productItems = [
    {'name': 'Sweatshirt', 'image': 'assets/sweatshirt.jpg', 'color': const Color(0xFFFFB3BA)},
    {'name': 'Lisa Blouse', 'image': 'assets/lisa blouse.jpg', 'color': const Color(0xFFBAE1D3)},
    {'name': 'Blue Shirt', 'image': 'assets/blue shirt.jpg', 'color': const Color(0xFFBAD9E1)},
    {'name': 'Ribbonie', 'image': 'assets/ribonnie.jpg', 'color': const Color(0xFFE8E8E8)},
    {'name': 'Kemeja Puff Chin', 'image': 'assets/1.jpeg', 'color': const Color(0xFFFFF4BA)},
    {'name': 'Peony Blouse', 'image': 'assets/peony.png', 'color': const Color(0xFFF5F5F5)},
    {'name': 'Luxe Cardi', 'image': 'assets/luxe cardi.jpg', 'color': const Color(0xFFD4B5D4)},
    {'name': 'Mina Blouse', 'image': 'assets/mina blouse.jpg', 'color': const Color(0xFFBAD9E1)},
    {'name': 'Kemeja Kotak', 'image': 'assets/kemeja teknik.jpg', 'color': const Color(0xFFBAE1BA)},
    {'name': 'Madless Shirt', 'image': 'assets/madless.jpg', 'color': const Color(0xFFE8E8E8)},
    {'name': 'Dobujack Shirt', 'image': 'assets/dobujack shirt.jpg', 'color': const Color(0xFFE8D4E8)},
    {'name': 'Pinky Skirt', 'image': 'assets/pinky skirt.jpg', 'color': const Color(0xFFFFCCE5)},
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
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
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
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFFFF69B4),
              unselectedLabelColor: Colors.black54,
              indicatorColor: const Color(0xFFFF69B4),
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: 'Product'),
                Tab(text: 'Style'),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1, color: Colors.grey),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductTab(),
                _buildStyleTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),
    );
  }

  // Style Tab (Grid 2 kolom - mirip Today's Outfit)
  Widget _buildStyleTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _styleItems.length,
      itemBuilder: (context, index) {
        return _buildStyleCard(_styleItems[index]);
      },
    );
  }

  // Product Tab (Grid 3 kolom)
  Widget _buildProductTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _productItems.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_productItems[index]);
      },
    );
  }

  // Style Card Widget (mirip Today's Outfit)
  Widget _buildStyleCard(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.checkroom,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Title
        Text(
          item['title'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // User Info & Mood Tag
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User Avatar & Name
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: item['profileColor'],
                    child: Text(
                      item['user'][0],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item['user'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Mood Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item['moodColor'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item['mood'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Product Card Widget (Grid 3 kolom)
  Widget _buildProductCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Product Image - LEBIH BESAR
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: item['color'],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item['image'],
                      width: double.infinity,
                      height: double.infinity,
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
                  // Favorite Icon
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 12,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Product Info - LEBIH KECIL
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}