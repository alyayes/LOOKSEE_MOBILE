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
    if (args is String && _currentMood != args) {
      _currentMood = args;
      _fetchProducts(); 
    }
  }

  void _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      // Kirim parameter category sesuai pilihan (Man/Woman/null)
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
      print("Error: $e");
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
                  // PAKAI TEKS YANG SESUAI DATABASE (Man & Woman)
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
          _fetchProducts(); // Langsung panggil API
          Navigator.pop(context); // Tutup Modal
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
              "Your Mood Is ${_currentMood ?? 'Neutral'}!",
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
                      ? const Center(child: Text("No products found for this mood & category."))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.7,
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
    // Logic pencegahan error 404 gambar
    String fileName = product['gambar_produk'] ?? '';
    String assetPath = fileName.contains('assets/') ? fileName : 'assets/produk-looksee/$fileName';

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProductPage(productData: product))),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  assetPath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['nama_produk'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                  Text(formatRupiah(product['harga']), style: const TextStyle(color: Colors.pink, fontSize: 12)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}