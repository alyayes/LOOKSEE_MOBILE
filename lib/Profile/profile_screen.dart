import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../navbar/navbar.dart';
import '../cart/cart_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final data = await apiService.getProfileData();
    setState(() {
      profileData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = profileData?['data']['user'];
    final posts = profileData?['data']['posts'] as List? ?? [];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDEEF0),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black54),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
            ),
            IconButton(icon: const Icon(Icons.settings, color: Colors.black54), onPressed: () {}),
          ],
        ),
        body: Column(
          children: [
            // Header Profile
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: user?['profile_picture'] != null
                        ? NetworkImage("${ApiService.baseUrl.replaceFirst('/api', '')}/assets/images/profile/${user['profile_picture']}")
                        : const AssetImage('assets/profile.jpg') as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?['name'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('@${user?['username'] ?? 'username'}', style: const TextStyle(color: Colors.grey)),
                        Text(user?['bio'] ?? 'No bio yet.', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {}, 
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFA6297)),
                    child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
            const TabBar(
              indicatorColor: Color(0xFFFA6297),
              labelColor: Colors.black,
              tabs: [Tab(text: 'My Style'), Tab(text: 'Gallery'), Tab(text: 'About')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab My Style (Postingan dari Laravel)
                  ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostCard(
                        date: post['created_at'].toString().split('T')[0],
                        text: post['caption'] ?? '',
                        imagePath: "${ApiService.baseUrl.replaceFirst('/api', '')}/assets/images/todays%20outfit/${post['image_post']}",
                        isNetwork: true,
                      );
                    },
                  ),
                  const Center(child: Text("Gallery View")),
                  const Center(child: Text("About Me Info")),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 1),
      ),
    );
  }
}

// Update PostCard untuk mendukung Image Network
class PostCard extends StatelessWidget {
  final String date;
  final String text;
  final String imagePath;
  final bool isNetwork;

  const PostCard({required this.date, required this.text, required this.imagePath, this.isNetwork = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(title: const Text("Lucy"), subtitle: Text(date)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(text)),
          const SizedBox(height: 8),
          isNetwork 
            ? Image.network(imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 100))
            : Image.asset(imagePath, fit: BoxFit.cover),
        ],
      ),
    );
  }
}