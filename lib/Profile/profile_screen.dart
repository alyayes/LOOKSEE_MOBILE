import 'package:flutter/material.dart';
import '../navbar/navbar.dart'; 
import '../cart/cart_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Lucy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
            .copyWith(background: const Color(0xFFFDEEF0)),
        scaffoldBackgroundColor: const Color(0xFFFDEEF0), 
      ),
      home: const ProfileScreen(),
    );
  }
}

const Color pastelPink = Color(0xFFFDEEF0); 
const Color brightPink = Color(0xFFFA6297); 
const Color darkerPink = Color(0xFFFC77A0); 
const Color greyText = Colors.grey;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), 
          child: AppBar(
            backgroundColor: pastelPink,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '9:41',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black, 
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black54),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CartPage()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.black54),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Settings Tapped!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: brightPink, 
                        ),
                      ),
                      const CircleAvatar(
                        radius: 38,
                        backgroundImage: AssetImage('assets/profile.jpg'), 
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Lucy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              'she/her',
                              style: TextStyle(
                                fontSize: 14,
                                color: greyText,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          '@lucymawdie',
                          style: TextStyle(
                            fontSize: 14,
                            color: greyText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'You have no bio yet.',
                          style: TextStyle(
                            fontSize: 14,
                            color: greyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit Profile Tapped!')),
                       );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brightPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TabBar(
                indicatorColor: brightPink, 
                indicatorSize: TabBarIndicatorSize.label, 
                labelColor: Colors.black, 
                unselectedLabelColor: greyText, 
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                tabs: const [
                  Tab(text: 'My Style'),
                  Tab(text: 'My Gallery'),
                  Tab(text: 'About Me'),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.only(top: 8.0),
                    children: const [
                      PostCard(
                        date: '9 May 2025',
                        text: 'Pinky outfit for today! ^^',
                        imagePath: 'assets/to4.jpg',
                        isTopPost: true,
                        loves: 0, comments: 0, shares: 0,
                      ),
                      PostCard(
                        date: '1 May 2025',
                        text: "Today's Class was fun i glad to wear this pinky outfit",
                        imagePath: 'assets/to5.jpg',
                        isTopPost: false, 
                        loves: 194, comments: 37, shares: 6,
                      ),
                    ],
                  ),
                  const GalleryGrid(),
                  const AboutMeTab(),
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

class PostCard extends StatelessWidget {
  final String date;
  final String text;
  final String imagePath;
  final bool isTopPost;
  final int loves;
  final int comments;
  final int shares;

  const PostCard({
    required this.date,
    required this.text,
    required this.imagePath,
    required this.isTopPost,
    required this.loves,
    required this.comments,
    required this.shares,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Lucy',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '@lucymawdie',
                          style: TextStyle(fontSize: 12, color: greyText),
                        ),
                      ],
                    ),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12, color: greyText),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 8),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AspectRatio(
              aspectRatio: 1.0, 
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.pink[50],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Text('Placeholder Gambar\n($date)', textAlign: TextAlign.center, style: TextStyle(color: greyText)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: _buildInteractionRow(loves, comments, shares, color: Colors.grey[700]!),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionRow(int loves, int comments, int shares, {Color color = greyText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildInteractionItem(Icons.favorite_border, loves, color),
        const SizedBox(width: 20),
        _buildInteractionItem(Icons.chat_bubble_outline, comments, color),
        const SizedBox(width: 20),
        _buildInteractionItem(Icons.share, shares, color),
      ],
    );
  }

  Widget _buildInteractionItem(IconData icon, int count, Color color) {
    return Row(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: TextStyle(fontSize: 14, color: color),
        ),
      ],
    );
  }
}

class GalleryGrid extends StatelessWidget {
  const GalleryGrid({super.key});

  final List<String> _galleryImages = const [
    'assets/to23.jpg',
    'assets/to24.jpg',
    'assets/to25.jpg',
    'assets/to26.jpg',
    'assets/to27.jpg',
    'assets/to28.jpg',
    'assets/to30.jpg',
    'assets/to31.jpg',
    'assets/to32.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
          childAspectRatio: 1.0,
        ),
        itemCount: _galleryImages.length,
        itemBuilder: (context, index) {
          final imagePath = _galleryImages[index];
          return Container(
            color: Colors.white,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.pink[100],
                  child: Center(
                    child: Text(
                      'Image ${index + 1}\n(Not Found)',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AboutMeTab extends StatelessWidget {
  const AboutMeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bio Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              'Hi! I\'m Lucy, a fashion enthusiast with a passion for pastel colors and cozy outfits. I love coffee, traveling, and sharing my daily style tips! Life is better in pink! 💖✨',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Details & Interests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          
          _buildDetailCard(
            icon: Icons.cake_outlined,
            title: 'Birthday',
            value: 'October 27th',
            context: context,
          ),
          _buildDetailCard(
            icon: Icons.location_on_outlined,
            title: 'Location',
            value: 'Seoul, South Korea',
            context: context,
          ),
          _buildDetailCard(
            icon: Icons.work_outline,
            title: 'Occupation',
            value: 'Student & Digital Creator',
            context: context,
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Favorite Things',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _buildInterestChip('Pastel Fashion'),
              _buildInterestChip('Latte Art'),
              _buildInterestChip('Reading Fantasy'),
              _buildInterestChip('Cat Lover 😻'),
              _buildInterestChip('DIY Crafting'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: brightPink, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: greyText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      backgroundColor: darkerPink,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}