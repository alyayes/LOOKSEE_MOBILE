import 'package:flutter/material.dart';
import 'gallery.dart'; 
import '../todaysOutfit/todays_outfit.dart';

const String _cameraAssetPath = 'assets/camera.png';
const String _thumbnailAssetPath = 'assets/to4.jpg';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Camera View Clone',
      debugShowCheckedModeBanner: false,
      home: CameraLikeView(),
    );
  }
}

class CameraLikeView extends StatelessWidget {
  const CameraLikeView({super.key});

  void _navigateToGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ImageGridScreen(),
      ),
    );
  }
  
  void _navigateBackToTodaysOutfit(BuildContext context) {
    Navigator.of(context).pushReplacement( 
      MaterialPageRoute(
        builder: (context) => const TodaysOutfitScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    
    const Color backgroundColor = Colors.white; 

    return Scaffold(
      backgroundColor: backgroundColor,
      
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              _navigateBackToTodaysOutfit(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.flash_on, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: backgroundColor, 
                    alignment: Alignment.center,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 1.0, 
                        widthFactor: 1.0,
                        child: Image.asset(
                          _cameraAssetPath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: screenHeight * 0.75, 
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.black,
                              height: screenHeight * 0.75, 
                              child: const Center(
                                child: Text(
                                  "Ganti dengan Gambar dari Assets Anda di path/to/your/image.png", 
                                  style: TextStyle(color: Colors.white70)
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 120), 
              ],
            ),
          ),

          Positioned(
            bottom: 30, 
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _navigateToGallery(context),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2.0),
                        shape: BoxShape.circle,
                        color: Colors.grey[700],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          _thumbnailAssetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.photo_library, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.pink, width: 4.0), 
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent, 
                        ),
                      ),
                    ),
                  ),
                  
                  IconButton(
                    icon: const Icon(Icons.cached, color: Colors.black, size: 30),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}