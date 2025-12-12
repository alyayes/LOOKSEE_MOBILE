import 'package:flutter/material.dart';

class DetailStyleJournal extends StatefulWidget {
  // Kita bisa menerima data dari halaman sebelumnya jika mau (misal gambar/judul)
  // Untuk sekarang kita samakan dengan desain foto referensi
  final String imagePath;
  final String title;

  const DetailStyleJournal({
    super.key, 
    required this.imagePath,
    required this.title,
  });

  @override
  State<DetailStyleJournal> createState() => _DetailStyleJournalState();
}

class _DetailStyleJournalState extends State<DetailStyleJournal> {
  // State untuk slider feedback
  double _feedbackValue = 0.8; // Posisi slider (agak ke kanan/happy)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Style Journal",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- JUDUL ARTIKEL ---
            Text(
              "10 Tips for Effortless\nEveryday Fashion", // Bisa diganti widget.title jika mau dinamis
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),

            // --- BYLINE & TANGGAL ---
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Byline NAYE\n",
                    style: TextStyle(
                      color: Color(0xFFFF69B4), // Pink
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: "Publication: May 31, 2025",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- GAMBAR UTAMA ---
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                widget.imagePath, // Menggunakan gambar dari halaman sebelumnya
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- KOTAK INTRO PINK ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC0CB).withOpacity(0.4), // Pink muda banget
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Ingin tampil stylish tanpa ribet? Siap tampil memukau dengan usaha minimal? Yuk, kita mulai!😍",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF8B4A62), // Pink tua/coklat
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- KONTEN LIST (1-10) ---
            _buildTipItem("1. 👕 Invest in Quality Basics", 
              "Investasi pada basic item seperti kaos putih, celana jeans gelap yang pas di badan, atau kemeja polos berkualitas."),
            _buildTipItem("2. 👟 Opt for Neutral Shoes", 
              "Sepatu berwarna netral seperti putih, beige, atau hitam adalah penyelamat."),
            _buildTipItem("3. 🧥 Add Simple Outerwear", 
              "Cardigan, blazer, atau jaket denim bisa langsung menaikkan \"level\" penampilanmu."),
            _buildTipItem("4. 🎨 Play with Accessories", 
              "Aksesori adalah kunci! Topi fedora, tas selempang unik, syal bermotif, atau kacamata membuat outfit sederhana terlihat lebih menarik."),
            _buildTipItem("5. 👖 Choose Comfortable and Well-Fitting Clothes", 
              "Pastikan pakaianmu tidak terlalu ketat atau terlalu longgar. Kenyamanan adalah prioritas utama untuk effortless fashion."),
            _buildTipItem("6. ✨ Pay Attention to Small Details", 
              "Pakaian yang rapi, bersih, dan tidak kusut adalah poin penting."),
            _buildTipItem("7. 🔄 Smart Mix and Match", 
              "Coba padukan atasan yang biasa kamu pakai dengan bawahan yang berbeda dari biasanya."),
            _buildTipItem("8. 🧼 Maintain Your Clothes", 
              "Pakaian yang terawat dan bersih akan selalu terlihat lebih baik."),
            _buildTipItem("9. 📸 Document and Evaluate", 
              "Ambil foto OOTD (Outfit of the Day) sesekali. Ini membantu kamu menemukan signature style-mu."),
            _buildTipItem("10. 🔒 The Key: Confidence", 
              "Apapun yang kamu pakai, percaya diri adalah aksesori terbaik."),

            const SizedBox(height: 30),

            // --- FEEDBACK SECTION (SLIDER) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFFF69B4).withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "How did this article make\nyou feel?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFF69B4),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Slider Custom Pink
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFFF9EAA),
                      inactiveTrackColor: Colors.grey[200],
                      trackHeight: 8.0,
                      thumbColor: const Color(0xFFFF69B4),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                      overlayColor: const Color(0xFFFF69B4).withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _feedbackValue,
                      onChanged: (val) {
                        setState(() => _feedbackValue = val);
                      },
                    ),
                  ),
                  
                  // Emojis Row
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("🙁", style: TextStyle(fontSize: 24)),
                      Text("😐", style: TextStyle(fontSize: 24)),
                      Text("😁", style: TextStyle(fontSize: 24)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk item tips
  Widget _buildTipItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}