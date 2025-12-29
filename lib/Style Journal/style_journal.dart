import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Style Journal',
      theme: ThemeData(
        // Tema dasar untuk menghilangkan bayangan AppBar/Nav
        useMaterial3: true,
        primarySwatch: Colors.pink,
        // Warna latar belakang utama
        scaffoldBackgroundColor: Colors.white, 
      ),
      home: const StyleJournalScreen(),
    );
  }
}

// ----------------------------------------------------
// BAGIAN 1: Halaman Utama Style Journal
// ----------------------------------------------------

// Konstanta Warna Kustom
const Color kPinkPrimary = Color(0xFFF792B1);
const Color kPinkLight = Color(0xFFFCEBF1);
const Color kGreyText = Color(0xFF5A5A5A);
const Color kLightBorder = Color(0xFFE0E0E0);

class StyleJournalScreen extends StatelessWidget {
  const StyleJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Media Query untuk mendapatkan tinggi statusBar (untuk penyesuaian gradien)
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      // Bilah Navigasi Bawah
      bottomNavigationBar: _buildBottomNavBar(),
      
      // Konten Utama
      body: CustomScrollView(
        slivers: <Widget>[
          // Sliver AppBar (Area Pink dan Judul)
          _buildSliverAppBar(statusBarHeight),

          // Sliver List (Konten Gulir)
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Fashion Insights',
                    style: TextStyle(
                      fontFamily: 'SF Pro', // Mengasumsikan font ini atau serupa
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: kGreyText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Explore tips, tricks, and trends!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Daftar Kartu Konten
                const FashionInsightCard(
                  imagePath: 'assets/image1.png', // Ganti dengan jalur aset Anda
                ),
                const FashionInsightCard(
                  imagePath: 'assets/image2.png', // Ganti dengan jalur aset Anda
                ),
                const FashionInsightCard(
                  imagePath: 'assets/image3.png', // Ganti dengan jalur aset Anda
                ),
                const SizedBox(height: 50), // Ruang di akhir
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Bilah Navigasi Bawah
  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: kPinkPrimary, // Warna latar belakang
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      height: 75, // Tinggi yang lebih besar untuk ikon dan label
      child: Stack(
        alignment: Alignment.center,
        children: [
          BottomNavigationBar(
            backgroundColor: Colors.transparent, // Transparan agar terlihat warna Container
            elevation: 0, // Hilangkan bayangan bawaan
            type: BottomNavigationBarType.fixed, // Tetap saat item lebih dari 3
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            selectedLabelStyle: const TextStyle(fontSize: 10),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            currentIndex: 4, // 'Style Journal' adalah item ke-5 (indeks 4)
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined, size: 24),
                label: "Today's Outfit",
              ),
              BottomNavigationBarItem(
                // Placeholder untuk tombol tengah (+)
                icon: SizedBox(width: 40, height: 40), 
                label: 'Post My Style',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description_outlined, size: 24),
                label: 'Style Journal',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 24),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              // Tambahkan logika navigasi di sini
            },
          ),
          // Tombol Lingkaran Besar di Tengah
          Positioned(
            bottom: 10, // Sesuaikan posisi vertikal
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(4),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPinkPrimary,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Sliver AppBar
  SliverAppBar _buildSliverAppBar(double statusBarHeight) {
    return SliverAppBar(
      expandedHeight: 200.0, // Tinggi yang cukup untuk gradien dan konten
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent, // Transparan untuk gradien
      elevation: 0,
      
      // Tindakan di sebelah kanan (Ikon Hati dan Lonceng)
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Icon(Icons.favorite_border, color: Colors.black, size: 28),
        ),
        Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Icon(Icons.notifications_none, color: Colors.black, size: 28),
        ),
      ],
      
      // Bagian Judul dan Search Bar
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        centerTitle: true,
        title: Container(
          // Container dengan gradien pink
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kPinkLight, kPinkPrimary.withOpacity(0.6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: statusBarHeight + 10, // Offset dari status bar
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Judul "Style Journal"
                const Text(
                  'Style Journal',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                // Search Bar
                _buildSearchBar(),
                const SizedBox(height: 10), // Jarak ke konten di bawah
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Search Bar
  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none, // Hilangkan border bawaan
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// BAGIAN 2: Widget Kartu Konten
// ----------------------------------------------------

class FashionInsightCard extends StatelessWidget {
  final String imagePath;

  const FashionInsightCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      // Contoh card yang mencakup seluruh lebar dengan shadow yang halus
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        // Klip agar gambar mengikuti batas border radius
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            imagePath, // Menggunakan Image.asset sesuai permintaan Anda
            fit: BoxFit.cover,
            // Berikan tinggi yang sesuai dengan rasio gambar di UI
            height: 300, 
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

/*
CATATAN PENTING:
Untuk menggunakan Image.asset, pastikan Anda:
1. Membuat folder 'assets' di root project Flutter Anda.
2. Menyimpan gambar-gambar (misalnya image1.png, image2.png) di dalam folder tersebut.
3. Mendeklarasikan folder assets di file pubspec.yaml:

flutter:
  uses-material-design: true
  assets:
    - assets/

Kemudian jalankan 'flutter pub get' di terminal.
*/