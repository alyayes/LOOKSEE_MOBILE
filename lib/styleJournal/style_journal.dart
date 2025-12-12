import 'package:flutter/material.dart';
// Import Navbar
import '../navbar/navbar.dart';
// IMPORT HALAMAN DETAIL YANG BARU DIBUAT
import 'detail_style_journal.dart'; 

class StyleJournalScreen extends StatefulWidget {
  const StyleJournalScreen({super.key});

  @override
  State<StyleJournalScreen> createState() => _StyleJournalScreenState();
}

class _StyleJournalScreenState extends State<StyleJournalScreen> {
  // Data Gambar & Judul
  final List<Map<String, String>> journalData = [
    {
      'image': 'assets/styleJournal/image1.png', 
      'title': 'Streetwear Vibes'
    },
    {
      'image': 'assets/styleJournal/image2.png', 
      'title': 'Casual Sunday'
    },
    {
      'image': 'assets/styleJournal/image3.png', 
      'title': 'Formal Looks'
    },
    {
      'image': 'assets/styleJournal/image4.png', 
      'title': 'Summer OOTD'
    },
     {
      'image': 'assets/styleJournal/image5.png', 
      'title': 'Winter Collection'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // NAVBAR MENGAMBANG
      extendBody: true, 
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),
      
      body: SafeArea(
        bottom: false, 
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Style Journal",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border, size: 28),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none, size: 28),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
              
              const SizedBox(height: 20),
              
              // --- SEARCH BAR ---
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFFFF69B4)),
                    hintText: "Search...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              
              // --- SUBTITLE ---
              const Text(
                "Fashion Insights",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Explore tips, tricks, and trends!",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 25),

              // --- LIST KARTU ---
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: journalData.length,
                itemBuilder: (context, index) {
                  return HoverFashionCard(
                    imagePath: journalData[index]['image']!,
                    title: journalData[index]['title']!,
                  );
                },
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// HOVER CARD YANG NAVIGASI KE DETAIL
// =========================================================
class HoverFashionCard extends StatefulWidget {
  final String imagePath;
  final String title;

  const HoverFashionCard({
    super.key, 
    required this.imagePath, 
    required this.title
  });

  @override
  State<HoverFashionCard> createState() => _HoverFashionCardState();
}

class _HoverFashionCardState extends State<HoverFashionCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovering = true),
        onTapUp: (_) => setState(() => _isHovering = false),
        onTapCancel: () => setState(() => _isHovering = false),
        
        // --- NAVIGASI SAAT KLIK CARD DI SINI ---
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailStyleJournal(
                imagePath: widget.imagePath,
                title: widget.title,
              ),
            ),
          );
        },
        
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 25),
          height: 200, 
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Gambar
                Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                      ),
                    );
                  },
                ),

                // Overlay Gelap
                AnimatedOpacity(
                  opacity: _isHovering ? 0.7 : 0.0, 
                  duration: const Duration(milliseconds: 300),
                  child: Container(color: Colors.black),
                ),

                // Judul
                AnimatedOpacity(
                  opacity: _isHovering ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}