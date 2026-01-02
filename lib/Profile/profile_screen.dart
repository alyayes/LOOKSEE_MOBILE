import 'package:flutter/material.dart';

// ====== GANTI SESUAI STRUKTUR PROJECT KAMU ======
import '../navbar/navbar.dart';
import '../services/profile_service.dart';
import '../models/profile_model.dart';
// ================================================

class ProfileScreen extends StatelessWidget {
  final String token;
  const ProfileScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileResponse>(
      future: ProfileService().fetchProfile(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Gagal memuat data profile')),
          );
        }

        final profile = snapshot.data!;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            bottomNavigationBar: const CustomNavBar(currentIndex: 1),
            body: Column(
              children: [
                ProfileHeader(user: profile.user),
                const TabBar(
                  tabs: [
                    Tab(text: 'My Style'),
                    Tab(text: 'My Gallery'),
                    Tab(text: 'About Me'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      MyStyleTab(posts: profile.posts),
                      GalleryTab(posts: profile.posts),
                      AboutMeTab(user: profile.user),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* =========================
   HEADER PROFILE
========================= */
class ProfileHeader extends StatelessWidget {
  final UserProfile user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.profilePicture != null
        ? 'http://10.0.2.2:8000/assets/images/profile/${user.profilePicture}'
        : null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage:
                imageUrl != null ? NetworkImage(imageUrl) : null,
            child: imageUrl == null
                ? const Icon(Icons.person, size: 36)
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('@${user.username}',
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(user.bio ?? 'No bio'),
            ],
          )
        ],
      ),
    );
  }
}

/* =========================
   TAB MY STYLE
========================= */
class MyStyleTab extends StatelessWidget {
  final List<PostModel> posts;
  const MyStyleTab({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(child: Text('Belum ada postingan'));
    }

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return ListTile(
          leading: Image.network(
            'http://10.0.2.2:8000/assets/images/todays outfit/${post.image}',
            width: 60,
            fit: BoxFit.cover,
          ),
          title: Text(post.caption),
          subtitle: Text(post.createdAt),
        );
      },
    );
  }
}

/* =========================
   TAB GALLERY
========================= */
class GalleryTab extends StatelessWidget {
  final List<PostModel> posts;
  const GalleryTab({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(child: Text('Gallery kosong'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Image.network(
          'http://10.0.2.2:8000/assets/images/todays outfit/${posts[index].image}',
          fit: BoxFit.cover,
        );
      },
    );
  }
}

/* =========================
   TAB ABOUT ME
========================= */
class AboutMeTab extends StatelessWidget {
  final UserProfile user;
  const AboutMeTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        user.bio ?? 'Belum ada informasi',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
