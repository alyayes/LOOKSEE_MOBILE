import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'gallery.dart'; 
import '../todaysOutfit/todays_outfit.dart';
import '../Post/post.dart';

class CameraLikeView extends StatefulWidget {
  const CameraLikeView({super.key});

  @override
  State<CameraLikeView> createState() => _CameraLikeViewState();
}

class _CameraLikeViewState extends State<CameraLikeView> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostMyStyleScreen(imagePath: photo.path),
        ),
      );
    }
  }

  void _navigateToGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ImageGridScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.camera_alt, color: Colors.white10, size: 100),
              ),
            ),
          ),
          Container(
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _navigateToGallery(context),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: _takePhoto,
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.cached, color: Colors.white, size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}