import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../navbar/navbar.dart';
import '../services/api_service.dart';
import 'detail_product_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  String _selectedCategory = 'Semua'; 
  String? _currentMood; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    
    // 🔥 Mengatur default mood ke 'Neutral' jika tidak ada argumen dari slider
    String moodToSet = (args is String) ? args : 'Neutral';

    if (_currentMood != moodToSet) {
      _currentMood = moodToSet;
      _fetchProducts(); 
    }
  }

  void _fetchProducts() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      String? categoryParam = (_selectedCategory == 'Semua') ? null : _selectedCategory;
      
      final data = await ApiService().getProducts(
        mood: _currentMood, 
        category: categoryParam
      );

      if (mounted) {
        setState(() {
          _products = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint("Error Fetching Products: $e");
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Filter Category", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(),
                  _buildFilterOption("Semua", setModalState),
                  _buildFilterOption("Woman", setModalState), 
                  _buildFilterOption("Man", setModalState),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOption(String title, StateSetter setModalState) {
    bool isSelected = _selectedCategory == title;
    return RadioListTile<String>(
      title: Text(title, style: TextStyle(color: isSelected ? Colors.pink : Colors.black)),
      value: title,
      groupValue: _selectedCategory,
      activeColor: Colors.pink,
      onChanged: (value) {
        if (value != null) {
          setModalState(() => _selectedCategory = value);
          setState(() => _selectedCategory = value);
          _fetchProducts();
          Navigator.pop(context);
        }
      },
    );
  }

  String formatRupiah(dynamic price) {
    double value = double.tryParse(price.toString()) ?? 0;
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context) {
    const pinkColor = Color(0xFFFF69B4);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.tune, color: pinkColor), onPressed: _showFilterModal),
                  IconButton(icon: const Icon(Icons.favorite_border), onPressed: () => Navigator.pushNamed(context, '/favorite')),
                ],
              ),
            ),
            
            Text(
              "Your Mood Is ${_currentMood}!",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: pinkColor),
            ),

            if (_selectedCategory != 'Semua')
              Chip(
                label: Text("Category: $_selectedCategory"),
                onDeleted: () {
                  setState(() => _selectedCategory = 'Semua');
                  _fetchProducts();
                },
              ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: pinkColor))
                  : _products.isEmpty
                      ? const Center(child: Text("No products found for this mood."))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          // 🔥 Grid layout rapi dengan 3 kolom
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,        
                            crossAxisSpacing: 8,      
                            mainAxisSpacing: 8,       
                            childAspectRatio: 0.7,    
                          ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) => _buildProductItem(_products[index]),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
    );
  }

  Widget _buildProductItem(dynamic product) {
    String fileName = product['gambar_produk'] ?? '';
    String assetPath = fileName.contains('assets/') ? fileName : 'assets/produk-looksee/$fileName';

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProductPage(productData: product))),
      child: Container(
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
                child: Image.asset(
                  assetPath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 20, color: Colors.grey)),
                ),
              ),
            ),
            // 🔥 Kontainer teks dengan pengaturan rata kiri
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0F5), 
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(11)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Membuat teks rata kiri
                children: [
                  Text(
                    product['nama_produk'] ?? '', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
                    textAlign: TextAlign.left,
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatRupiah(product['harga']), 
                    style: const TextStyle(color: Colors.pink, fontSize: 8, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}