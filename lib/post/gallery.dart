import 'package:flutter/material.dart';
import 'post.dart';
import '../services/api_service.dart';

class ImageGridScreen extends StatefulWidget {
  const ImageGridScreen({super.key});

  @override
  State<ImageGridScreen> createState() => _ImageGridScreenState();
}

class _ImageGridScreenState extends State<ImageGridScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> galleryItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGallery();
  }

  Future<void> _fetchGallery() async {
    final response = await _apiService.getProfileData();
    if (response != null && response['success'] == true) {
      setState(() {
        galleryItems = response['data']['posts'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Gallery',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : galleryItems.isEmpty
              ? const Center(child: Text("No images found"))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: galleryItems.length,
                    itemBuilder: (context, index) {
                      final item = galleryItems[index];
                      final String imageUrl = "${ApiService.postImgUrl}/${item['image_post']}";
                      
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostMyStyleScreen(imagePath: imageUrl),
                            ),
                          );
                        },
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}