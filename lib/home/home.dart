import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../navbar/navbar.dart';
import '../services/api_service.dart';
import '../product/detail_product_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Data Real dari API
  List<dynamic> _latestProducts = [];
  List<dynamic> _womanProducts = [];
  List<dynamic> _manProducts = [];
  String _userName = "User"; 
  bool _isLoading = true;

  // --- BAGIAN MOOD: Perbaikan Posisi Tengah Tanpa Titik ---
  double _moodValue = 0.5; // 🔥 Default tepat di tengah (0.5)
  bool _isFavorite = false; 
  
  final List<String> _moodImages = [
    'assets/gif/sangatSedih.gif',
    'assets/gif/sedih.gif',
    'assets/gif/biasa.gif',
    'assets/gif/senang.gif',
    'assets/gif/sangatSenang.gif'
  ];
  
  final List<String> _moodLabels = ['Very Sad', 'Sad', 'Neutral', 'Happy', 'Very Happy'];

  int get _currentMoodIndex {
    int index = (_moodValue * (_moodImages.length - 1)).round();
    return index.clamp(0, _moodImages.length - 1);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      final profileData = await ApiService().getProfile();
      final allProducts = await ApiService().getProducts();
      
      if (mounted) {
        setState(() {
          if (profileData != null && profileData['user'] != null) {
            _userName = profileData['user']['name'] ?? "User";
          }

          final reversedProducts = List.from(allProducts.reversed);

          _latestProducts = reversedProducts.take(5).toList();
          _womanProducts = reversedProducts.where((p) => p['kategori'] == 'Woman').take(5).toList();
          _manProducts = reversedProducts.where((p) => p['kategori'] == 'Man').take(5).toList();

          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      if (mounted) setState(() => _isLoading = false);
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
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF69B4)))
          : _buildHomeContent(),
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
    );
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFC0CB), Color(0xFFFFF0F5), Colors.white],
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hi, $_userName!", 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? const Color(0xFFFF69B4) : Colors.black38),
                          onPressed: () { setState(() => _isFavorite = !_isFavorite); Navigator.pushNamed(context, '/favorite'); },
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black54),
                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_none, color: Colors.black54),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Color(0xFFFF69B4)),
                      hintText: "Search products...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset('assets/banner.png', fit: BoxFit.cover, 
                      errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.image, color: Colors.grey))),
                  ),
                ),
                const SizedBox(height: 25),
                _buildSectionTitle("Latest Product"),
                const SizedBox(height: 10),
                _buildHorizontalProductList(_latestProducts), 
                const SizedBox(height: 20),
                _buildMoodSection(),
                const SizedBox(height: 25),
                _buildSectionTitle("Woman"),
                const SizedBox(height: 10),
                _buildHorizontalProductList(_womanProducts), 
                const SizedBox(height: 25),
                _buildSectionTitle("Man"),
                const SizedBox(height: 10),
                _buildHorizontalProductList(_manProducts), 
                const SizedBox(height: 20), // 🔥 JARAK DIPERBAIKI: Tidak lagi 120 agar tidak ada gap besar
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFF69B4).withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          const Text(
            "Let's Find an Outfit That Suits With Your Mood!", 
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold, fontSize: 16)
          ),
          const SizedBox(height: 15),
          SizedBox(height: 80, width: 80, child: Image.asset(_moodImages[_currentMoodIndex], fit: BoxFit.contain, key: ValueKey<int>(_currentMoodIndex))),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFFFF69B4).withOpacity(0.3),
                        thumbColor: const Color(0xFFFF69B4),
                        overlayColor: const Color(0xFFFF69B4).withOpacity(0.1),
                        tickMarkShape: SliderTickMarkShape.noTickMark, 
                      ),
                      child: Slider(
                        value: _moodValue, 
                        min: 0,
                        max: 1.0,
                        divisions: null,
                        onChanged: (val) => setState(() => _moodValue = val),
                      ),
                    ),
                    Text(_moodLabels[_currentMoodIndex], style: const TextStyle(color: Color(0xFFFF69B4), fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/product', arguments: _moodLabels[_currentMoodIndex]),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFFF69B4).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFFF69B4)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54));
  }

  Widget _buildHorizontalProductList(List<dynamic> products) {
    if (products.isEmpty) {
      return const SizedBox(height: 50, child: Center(child: Text("No items found.", style: TextStyle(color: Colors.grey))));
    }

    return SizedBox(
      height: 140, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          String name = product['nama_produk'] ?? 'No Name';
          String price = formatRupiah(product['harga']);
          String fileName = product['gambar_produk'] ?? '';
          String assetPath = 'assets/produk-looksee/$fileName';

          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProductPage(productData: product)));
            },
            child: Container(
              width: 100, 
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink.withOpacity(0.1)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey[50],
                        child: Image.asset(
                          assetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, color: Colors.grey); 
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        Text(price, style: const TextStyle(fontSize: 9, color: Color(0xFFFF69B4))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}