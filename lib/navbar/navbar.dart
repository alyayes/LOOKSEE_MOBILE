import 'package:flutter/material.dart';

// Import halaman Camera & Gallery
import '../post/camera.dart'; 
import '../post/gallery.dart';

// === IMPORT KEDUA HALAMAN INI AGAR TIDAK ERROR ===
import '../todaysOutfit/todays_outfit.dart';   // Untuk TodaysOutfitScreen
import '../styleJournal/style_journal.dart';   // Untuk StyleJournalScreen

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  // --- FUNGSI MODAL ---
  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                "Upload Photo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildModalOption(
                    context, 
                    icon: Icons.camera_alt_rounded, 
                    label: "Camera", 
                    onTap: () {
                      Navigator.pop(context); 
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraLikeView()));
                    }
                  ),
                  _buildModalOption(
                    context, 
                    icon: Icons.photo_library_rounded, 
                    label: "Gallery", 
                    onTap: () {
                      Navigator.pop(context); 
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ImageGridScreen()));
                    }
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFFF69B4).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: const Color(0xFFFF69B4)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
        ],
      ),
    );
  }

  // --- TAMPILAN UTAMA NAVBAR ---
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double barHeight = 65; 
    final double horizontalMargin = 20; 

    return Container(
      color: Colors.transparent, 
      height: 100, 
      width: size.width,
      
      child: Stack(
        clipBehavior: Clip.none, 
        alignment: Alignment.bottomCenter,
        children: [
          
          // 1. BACKGROUND PINK
          Positioned(
            bottom: 20, 
            left: horizontalMargin,
            right: horizontalMargin,
            child: SizedBox(
              height: barHeight,
              child: CustomPaint(
                painter: NavBarCurvePainter(),
                child: Container(
                  height: barHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      // GROUP KIRI
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Index 0: Home
                            _buildNavItem(context, Icons.home_rounded, 0),
                            // Index 1: Hanger -> Todays Outfit
                            _buildNavItem(context, Icons.checkroom_rounded, 1),
                          ],
                        ),
                      ),

                      // SPACE TENGAH
                      const SizedBox(width: 60), 

                      // GROUP KANAN
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Index 3: Receipt -> Style Journal
                            _buildNavItem(context, Icons.receipt_long_rounded, 3),
                            // Index 4: Profile
                            _buildNavItem(context, Icons.person_rounded, 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. TOMBOL PLUS
          Positioned(
            bottom: 50,
            child: GestureDetector(
              onTap: () => _showImagePickerModal(context),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF69B4),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF69B4).withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        // === LOGIKA NAVIGASI ===
        if (index == 0 && currentIndex != 0) {
          // KE HOME
          Navigator.pushReplacementNamed(context, '/home');
        } 
        else if (index == 1) {
          // KE TODAYS OUTFIT (HANGER)
          // Memanggil TodaysOutfitScreen (sesuai file yang kamu kirim)
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const TodaysOutfitScreen())
          );
        }
        else if (index == 3) {
          // KE STYLE JOURNAL (ICON KERTAS/RECEIPT)
          // Memanggil StyleJournalScreen
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const StyleJournalScreen())
          );
        }
        else if (index == 4) {
          // KE PROFILE
          // Navigator.pushNamed(context, '/profile');
        }
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              size: 28,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 5,
                height: 5,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              )
          ],
        ),
      ),
    );
  }
}

// --- PAINTER LENGKUNG ---
class NavBarCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFFF69B4)
      ..style = PaintingStyle.fill;

    Path path = Path();
    
    double curveHeight = 30; 
    double curveWidth = 70;  
    double radius = size.height / 2; 

    path.moveTo(0, size.height / 2);
    path.arcToPoint(Offset(radius * 1.5, 0), radius: Radius.circular(radius * 1.5), clockwise: true);
    path.lineTo((size.width / 2) - curveWidth, 0);

    path.cubicTo(
      (size.width / 2) - (curveWidth / 2), 0, 
      (size.width / 2) - (curveWidth / 2), -curveHeight, 
      size.width / 2, -curveHeight, 
    );
    path.cubicTo(
      (size.width / 2) + (curveWidth / 2), -curveHeight, 
      (size.width / 2) + (curveWidth / 2), 0, 
      (size.width / 2) + curveWidth, 0, 
    );

    path.lineTo(size.width - (radius * 1.5), 0);
    path.arcToPoint(Offset(size.width, size.height / 2), radius: Radius.circular(radius * 1.5), clockwise: true);
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius), clockwise: true);

    path.lineTo(radius, size.height);
    path.arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius), clockwise: true);
    path.close();

    canvas.drawShadow(path, Colors.grey.withOpacity(0.4), 6.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}