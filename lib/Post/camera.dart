import 'package:flutter/material.dart';

// Ganti dengan path ke file gambar yang sebenarnya di folder assets Anda
// Pastikan Anda telah mendeklarasikan folder assets di pubspec.yaml
const String _imageAssetPath = 'assets/camera.png';

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
      home: CameraLikeView(), // Memanggil Widget UI yang sudah dibuat
    );
  }
}

class CameraLikeView extends StatelessWidget {
  const CameraLikeView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // Warna latar belakang yang gelap/kayu
    const Color backgroundColor = Colors.white; 

    return Scaffold(
      backgroundColor: backgroundColor,
      
      // 1. App Bar
      // Menggunakan PreferredSize untuk custom App Bar yang lebih fleksibel
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              // Ikon senter/flash
              icon: const Icon(Icons.flash_on, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      
      // 2. Body
      body: Stack(
        children: [
          // Area Konten Utama (Gambar dan latar belakang)
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
                          _imageAssetPath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          // Mengatur tinggi agar gambar menempati sebagian besar area layar
                          height: screenHeight * 0.75, 
                          errorBuilder: (context, error, stackTrace) {
                            // Tampilan jika gambar asset belum ada
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
                // Ruang untuk tombol kontrol bawah
                const SizedBox(height: 120), 
              ],
            ),
          ),

          // 3. Elemen Kontrol Bawah (Overlay)
          Positioned(
            bottom: 30, // Jarak dari bawah
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Ikon Kiri (Galeri/Pratinjau)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0), 
                      // Ganti dengan Image.asset untuk thumbnail asli
                      color: Colors.grey[700],
                    ),
                    child: const Center(
                      child: Icon(Icons.photo_library, color: Colors.white),
                      // Anda bisa ganti dengan gambar kecil
                    ),
                  ),
                  
                  // Tombol Tengah (Jepret/Rekam)
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.pink, width: 4.0), // Garis Pink
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent, // Tengah transparan
                        ),
                      ),
                    ),
                  ),
                  
                  // Ikon Kanan (Putar Kamera)
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