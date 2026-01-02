import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../navbar/navbar.dart';


// ================= API SERVICE =================
class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api";

  Future<List<dynamic>> fetchPosts(String endpoint) async {
    final cleanEndpoint =
        endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

    final url = Uri.parse('$baseUrl/$cleanEndpoint');
    final response =
        await http.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      return decoded['data'] ?? [];
    } else {
      throw Exception("Gagal memuat data");
    }
  }
}

// ================= MAIN =================
void main() {
  runApp(const TodaysOutfitApp());
}

class TodaysOutfitApp extends StatelessWidget {
  const TodaysOutfitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todays Outfit',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TodaysOutfitScreen(),
    );
  }
}

// ================= SCREEN =================
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

  // ================= MOOD TAG =================
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

  // ================= CARD ITEM =================
  Widget _buildOutfitItem(Map<String, dynamic> item) {
    final imageUrl =
        "http://10.0.2.2:8000/storage/posts/${item['image_post']}";

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // IMAGE
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // TITLE
            Text(
              item['caption'] ?? 'No Title',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            // USER + MOOD
            Row(
              children: [
                CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.pink[100],
                  child: Text(
                    item['user'] != null
                        ? item['user']['name'][0]
                        : '?',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    item['user'] != null
                        ? item['user']['name']
                        : 'Anonymous',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
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

  // ================= PAGE =================
  Widget _buildPage(String endpoint) {
    return FutureBuilder<List<dynamic>>(
      future: _apiService.fetchPosts(endpoint),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Gagal memuat data"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Data kosong"));
        }

        final items = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        OutfitDetailPage(item: items[index]),
                  ),
                );
              },
              child: _buildOutfitItem(items[index]),
            );
          },
        );
      },
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todays Outfit'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFF7A2B4),
            unselectedLabelColor: Colors.black,
            indicatorColor: const Color(0xFFF7A2B4),
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

// ================= DETAIL PAGE =================
class OutfitDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const OutfitDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        "http://10.0.2.2:8000/storage/posts/${item['image_post']}";

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Outfit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(imageUrl),
            ),
            const SizedBox(height: 20),
            Text(
              item['caption'] ?? '-',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Diposting oleh: ${item['user'] != null ? item['user']['name'] : 'Anonymous'}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text('Mood: ${item['mood'] ?? '-'}'),
          ],
        ),
      ),
    );
  }
}
