import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Grid UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0, 
          backgroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ImageGridScreen(),
    );
  }
}

class ImageGridScreen extends StatelessWidget {
  const ImageGridScreen({super.key});

  // Daftar (List) path gambar Anda
  // Saya menggunakan daftar yang Anda berikan, meskipun ada kemungkinan file 'to36.jpg' dsb. belum ada.
  final List<String> imagePaths = const [
    'assets/to1.jpg',
    'assets/to32.jpg',    
    'assets/to3.jpeg',    
    'assets/to4.jpg',
    'assets/to33.jpg',
    'assets/to12.jpg',
    'assets/to29.jpg',
    'assets/to30.jpg',
    'assets/to36.jpg',    
    'assets/to39.jpg',   
    'assets/to37.jpg',
    'assets/to27.jpg',
    'assets/to38.jpg',
    'assets/to34.jpg',
    'assets/to35.jpg',
    'assets/to28.jpg',
    'assets/to40.jpg',
    'assets/to18.jpeg',
    'assets/to33.jpg',
    'assets/to20.jpeg',
    'assets/to44.jpg',
    'assets/to22.jpeg',
    'assets/to41.jpg',
    'assets/to24.jpg',
    'assets/to25.jpg',
    'assets/to26.jpg',
    'assets/to43.jpg',
    'assets/to28.jpg',
    'assets/to29.jpg',
    'assets/to30.jpg',
  ];

  // Jumlah total item grid yang akan ditampilkan
  final int totalItems = 30; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        title: const Text(''),
        toolbarHeight: 50,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0), 
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // *** PERUBAHAN UTAMA DI SINI ***
              crossAxisCount: 3, // Diubah dari 5 menjadi 3 kolom per baris
              
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
              // Rasio aspek disesuaikan agar gambar portrait tetap terlihat proporsional
              // Saya meningkatkan nilai childAspectRatio dari 0.56 menjadi 0.75 karena lebarnya bertambah
              childAspectRatio: 0.75, 
            ),
            itemCount: totalItems,
            itemBuilder: (context, index) {
              // Mengambil path gambar dengan operator Modulo
              final String currentImagePath = imagePaths[index % imagePaths.length];
              
              return _buildGridItem(currentImagePath);
            },
          ),
        ),
      ),
    );
  }

  // Widget khusus untuk membuat setiap item di GridView
  Widget _buildGridItem(String path) {
    return InkWell(
      onTap: () {
        debugPrint('Gambar diklik: $path');
      },
      child: Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Jika gambar masih tidak muncul, ikon error akan ditampilkan
          return const Center(child: Icon(Icons.error, color: Colors.red, size: 40));
        },
      ),
    );
  }
}