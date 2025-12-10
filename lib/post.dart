import 'package:flutter/material.dart';

// --- MAIN DAN SETUP APP ---
void main() {
  // Pastikan Anda memanggil WidgetsFlutterBinding.ensureInitialized();
  // jika Anda melakukan inisialisasi lebih lanjut di main(), tetapi untuk UI ini tidak wajib.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post My Style UI Final',
      theme: ThemeData(
        // Menggunakan Material 3 untuk gaya modern
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const PostMyStyleScreen(),
    );
  }
}

// --- HALAMAN UTAMA: PostMyStyleScreen ---
class PostMyStyleScreen extends StatelessWidget {
  const PostMyStyleScreen({super.key});

  // Ganti dengan nama file gambar Anda yang sebenarnya
  final String assetImagePath = 'assets/to2.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post My Style',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Aksi kembali
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Area Gambar Postingan
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  assetImagePath,
                  height: 200,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Tampilkan kotak abu-abu jika gambar gagal dimuat (misalnya, nama file salah)
                    return Container(
                      height: 200,
                      width: 150,
                      color: Colors.grey.shade300,
                      child: const Center(child: Text('Error: Asset not found')),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // 2. Input Caption
            const TextField(
              decoration: InputDecoration(
                hintText: 'Add a caption...',
                hintStyle: TextStyle(color: Colors.grey),
                // Menghilangkan garis input standar dan hanya menyisakan garis bawah tipis
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 24.0),

            // 3. Bagian Add Mood
            Row(
              children: <Widget>[
                const Icon(Icons.sentiment_satisfied_alt, color: Colors.black54),
                const SizedBox(width: 8.0),
                const Text(
                  'Add Mood',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            const MoodChipsRow(),

            const SizedBox(height: 32.0),

            // 4. Bagian Add Items (Header dan Tombol +)
            const AddItemsHeader(),
            const SizedBox(height: 12.0),

            // 5. Daftar Item Input (2 item)
            const ProductItemInput(),
            const ProductItemInput(),

            const SizedBox(height: 40.0),

            // 6. Tombol Post (Gaya sesuai gambar dengan bayangan)
            Center(
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade300.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Bayangan ke bawah
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi Post
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0, // Elevation dipindahkan ke Container BoxShadow
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

// --- KOMPONEN TAMBAHAN ---

// Widget untuk Deretan Mood Chips
class MoodChipsRow extends StatelessWidget {
  const MoodChipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi mood (Very Happy dan Very Sad terlihat terpilih)
    final List<Map<String, dynamic>> moods = [
      {'label': 'Very Happy', 'isSelected': true},
      {'label': 'Happy', 'isSelected': false},
      {'label': 'Neutral', 'isSelected': false},
      {'label': 'Sad', 'isSelected': false},
      {'label': 'Very Sad', 'isSelected': true},
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: moods.map((mood) {
        final bool isSelected = mood['isSelected'] as bool;
        return Chip(
          label: Text(
            mood['label'] as String,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          backgroundColor: isSelected ? Colors.grey.shade700 : Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      }).toList(),
    );
  }
}

// Widget untuk Header "Add Items" dan Tombol Plus
class AddItemsHeader extends StatelessWidget {
  const AddItemsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(Icons.shopping_bag_outlined, color: Colors.black54),
            const SizedBox(width: 8.0),
            const Text(
              'Add Items',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        // Tombol "Add" (+)
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.pink.shade100, // Warna latar belakang pink muda
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.pink),
            iconSize: 20,
            onPressed: () {
              // Aksi menambahkan item
            },
          ),
        ),
      ],
    );
  }
}

// Widget untuk Input Item Produk (Nama dan Link)
class ProductItemInput extends StatelessWidget {
  const ProductItemInput({super.key});

  @override
  Widget build(BuildContext context) {
    // Gaya border input field
    const OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: Colors.grey),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: const <Widget>[
                // Input Product Name
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Product name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    isDense: true,
                  ),
                ),
                SizedBox(height: 8.0),
                // Input Product Link
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Put the product link here',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          // Tombol Hapus (-)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.pink.shade50, // Warna latar belakang pink sangat muda
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.remove, color: Colors.red),
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  // Aksi menghapus item
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}