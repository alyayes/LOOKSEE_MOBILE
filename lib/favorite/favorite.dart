import 'package:flutter/material.dart';
import '../navbar/navbar.dart';
import '../services/api_service.dart';
import '../product/detail_product_page.dart'; 

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  List<dynamic> _favoriteProducts = [];
  List<dynamic> _likedPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFavoriteData(); 
  }

  Future<void> _loadFavoriteData() async {
    setState(() => _isLoading = true);
    final result = await ApiService().getFavorites();
    
    if (result != null && result['status'] == 'success') {
      setState(() {
        _favoriteProducts = result['data']['favorites'] ?? [];
        _likedPosts = result['data']['liked_posts'] ?? [];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _toggleFavorite(String productId) async {
    final result = await ApiService().toggleFavorite(productId);
    if (result != null) {
      _loadFavoriteData(); 
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pinkColor = Color(0xFFFF69B4);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          'Favorite',
          style: TextStyle(color: pinkColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: pinkColor))
          : Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: pinkColor,
                  unselectedLabelColor: Colors.black54,
                  indicatorColor: pinkColor,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Product'),
                    Tab(text: 'Style'),
                  ],
                ),
                const Divider(height: 1, color: Colors.grey),
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

  Widget _buildProductTab() {
    if (_favoriteProducts.isEmpty) {
      return _buildEmptyState("No favorite products yet.");
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _favoriteProducts.length,
      itemBuilder: (context, index) {
        final item = _favoriteProducts[index]['product'];
        if (item == null) return const SizedBox();
        return _buildProductCard(item);
      },
    );
  }

  Widget _buildStyleTab() {
    if (_likedPosts.isEmpty) {
      return _buildEmptyState("No liked styles yet.");
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _likedPosts.length,
      itemBuilder: (context, index) {
        return _buildStyleCard(_likedPosts[index]);
      },
    );
  }

  Widget _buildProductCard(dynamic product) {
    String rawImage = (product['gambar_produk'] ?? '').toString();
    String fileName = rawImage.split('/').last;
    
    // 🔥 Ditambahkan GestureDetector agar bisa diklik ke detail
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProductPage(productData: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      'assets/produk-looksee/$fileName',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          const Center(child: Icon(Icons.image, color: Colors.grey)),
                    ),
                  ),
                  Positioned(
                    top: 5, right: 5,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(product['id_produk'].toString()),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.favorite, size: 14, color: Color(0xFFFF69B4)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(color: Colors.pink[50], borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12))),
              child: Text(
                product['nama_produk'] ?? '-',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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

  Widget _buildStyleCard(dynamic post) {
    final user = post['user'] ?? {};
    String imageFileName = post['image_post'] ?? ''; 
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/$imageFileName', 
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, e, s) => Container(
                color: Colors.grey[200], 
                child: const Center(child: Icon(Icons.broken_image, color: Colors.grey))
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          post['caption'] ?? 'No Caption',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            CircleAvatar(
              radius: 9, 
              backgroundColor: Colors.pink[100], 
              child: Text(
                (user['username'] ?? 'U')[0].toUpperCase(), 
                style: const TextStyle(fontSize: 9, color: Colors.white)
              )
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                user['username'] ?? 'User', 
                style: const TextStyle(fontSize: 11, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              )
            ),
            const Icon(Icons.favorite, size: 10, color: Colors.pink),
            const SizedBox(width: 2),
            Text("${post['total_likes'] ?? 0}", style: const TextStyle(fontSize: 9)),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 50, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(message, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}