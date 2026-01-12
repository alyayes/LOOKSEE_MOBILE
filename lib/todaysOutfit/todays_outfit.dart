import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../navbar/navbar.dart';

class ApiService {
  static const String baseUrl = "http://10.128.83.120:8001/api";
  static const String storageUrl = "http://10.128.83.120:8001/storage/todaysoutfit";

  Future<List<dynamic>> fetchPosts(String endpoint) async {
    try {
      final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
      final url = Uri.parse('$baseUrl/$cleanEndpoint');
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        return decoded['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Gagal terhubung ke server");
    }
  }
}

class TodaysOutfitScreen extends StatefulWidget {
  const TodaysOutfitScreen({super.key});

  @override
  State<TodaysOutfitScreen> createState() => _TodaysOutfitScreenState();
}

class _TodaysOutfitScreenState extends State<TodaysOutfitScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildMoodTag(String mood) {
    Color color = const Color(0xFFF7A2B4);
    if (mood.toLowerCase().contains('sad')) color = Colors.blue;
    if (mood.toLowerCase().contains('neutral')) color = Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        mood,
        style: const TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.bold, 
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildOutfitItem(Map<String, dynamic> item) {
    final userData = item['user'] as Map<String, dynamic>?;
    final userName = userData?['name'] ?? 'Anonymous';
    final String imageFileName = item['image_post'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "${ApiService.storageUrl}/$imageFileName",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null 
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! 
                          : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item['caption'] ?? '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.pink[100],
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?', 
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                _buildMoodTag(item['mood'] ?? 'Happy'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String endpoint) {
    return FutureBuilder<List<dynamic>>(
      future: _apiService.fetchPosts(endpoint),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFF7A2B4)));
        }
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Belum ada postingan"));
        }

        final items = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildOutfitItem(items[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todays Outfit', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFF7A2B4),
            unselectedLabelColor: Colors.black54,
            indicatorColor: const Color(0xFFF7A2B4),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Explore'),
              Tab(text: 'Trends'),
              Tab(text: 'Latest'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPage('community/todays-outfit'),
                _buildPage('community/trends'),
                _buildPage('community/todays-outfit'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
    );
  }
}