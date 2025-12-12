import 'package:flutter/material.dart';

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
        primarySwatch: Colors.pink,
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
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.black54),
                      onPressed: () {
                      },
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
                  const Center(child: Text('Konten Galeri')),
                  const Center(child: Text('Konten Tentang Saya')),
                ],
              ),
            ),
          ],
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          backgroundColor: brightPink,
          shape: const CircleBorder(),
          elevation: 4.0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),

        bottomNavigationBar: BottomAppBar(
          color: darkerPink, 
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: SizedBox(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BottomNavItem(icon: Icons.home, label: 'Home', isActive: false),
                BottomNavItem(icon: Icons.calendar_today, label: 'Todays Outfit', isActive: false),
                const SizedBox(width: 40), 
                BottomNavItem(icon: Icons.article, label: 'Style Journal', isActive: false),
                BottomNavItem(icon: Icons.person, label: 'Profile', isActive: true),
              ],
            ),
          ),
        ),
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

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white70,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}