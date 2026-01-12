import 'package:flutter/material.dart';
import '../navbar/navbar.dart'; 
import '../orders/my_orders_page.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? userData;
  List<dynamic> userPosts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final response = await _apiService.getProfileData();
    if (response != null && response['success'] == true) {
      setState(() {
        userData = response['data']['user'];
        userPosts = response['data']['posts'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFA6297))),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDEEF0),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text('9:41', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black54),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrdersPage())),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black54),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // HEADER PROFIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: const Color(0xFFFA6297),
                    backgroundImage: userData?['profile_picture'] != null
                        ? NetworkImage("${ApiService.profileImgUrl}/${userData!['profile_picture']}")
                        : const AssetImage('assets/profile.jpg') as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userData?['name'] ?? 'Lucy', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                        Text("@${userData?['username'] ?? 'lucymawdie'}", style: const TextStyle(color: Colors.grey)),
                        Text(userData?['bio'] ?? 'You have no bio yet.', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFA6297), shape: StadiumBorder()),
                    child: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            
            const TabBar(
              indicatorColor: Color(0xFFFA6297),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'My Style'),
                Tab(text: 'My Gallery'),
                Tab(text: 'About Me'),
              ],
            ),
            
            Expanded(
              child: TabBarView(
                children: [
                  // Tab My Style
                  ListView.builder(
                    itemCount: userPosts.length,
                    itemBuilder: (context, index) {
                      final post = userPosts[index];
                      return PostCard(
                        name: userData?['name'] ?? 'User',
                        username: userData?['username'] ?? 'user',
                        date: post['created_at'].toString().substring(0, 10),
                        text: post['caption'] ?? '',
                        imagePath: "${ApiService.postImgUrl}/${post['image_post']}",
                      );
                    },
                  ),
                  // Tab Gallery
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1, mainAxisSpacing: 1),
                    itemCount: userPosts.length,
                    itemBuilder: (context, index) => Image.network(
                      "${ApiService.postImgUrl}/${userPosts[index]['image_post']}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Tab About Me
                  _buildAboutMe(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildAboutMe() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Phone: ${userData?['phone'] ?? '-'}"),
          const SizedBox(height: 8),
          Text("Birthday: ${userData?['birthday'] ?? '-'}"),
          const SizedBox(height: 8),
          Text("Country: ${userData?['country'] ?? '-'}"),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String name, username, date, text, imagePath;

  const PostCard({
    super.key, required this.name, required this.username, 
    required this.date, required this.text, required this.imagePath
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 18, backgroundColor: Colors.grey),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Text('@${user.username}',
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(user.bio ?? 'No bio'),
            ],
          ),
          const SizedBox(height: 8),
          Text(text),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200, color: Colors.grey[200], child: const Icon(Icons.broken_image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}