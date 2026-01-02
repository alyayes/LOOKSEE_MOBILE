import 'package:flutter/material.dart';

// Post
import '../post/camera.dart';
import '../post/gallery.dart';

// Pages
import '../todaysOutfit/todays_outfit.dart';
import '../styleJournal/style_journal.dart';
import '../Profile/profile_screen.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  // ================= MODAL CAMERA / GALLERY =================
  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CameraLikeView(),
                        ),
                      );
                    },
                  ),
                  _buildModalOption(
                    context,
                    icon: Icons.photo_library_rounded,
                    label: "Gallery",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ImageGridScreen(),
                        ),
                      );
                    },
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

  Widget _buildModalOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
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
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI NAVBAR =================
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: 100,
      width: size.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // BACKGROUND
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 65,
              child: CustomPaint(
                painter: NavBarCurvePainter(),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNavItem(context, Icons.home_rounded, 0),
                          _buildNavItem(context, Icons.checkroom_rounded, 1),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNavItem(context, Icons.receipt_long_rounded, 3),
                          _buildNavItem(context, Icons.person_rounded, 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // PLUS BUTTON
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
                  border: Border.all(color: Colors.white, width: 4),
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

  // ================= ITEM NAV =================
  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;

          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const TodaysOutfitScreen(),
              ),
            );
            break;

          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const StyleJournalScreen(),
              ),
            );
            break;

          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected
                ? Colors.white
                : Colors.white.withOpacity(0.6),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

// ================= PAINTER =================
class NavBarCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF69B4)
      ..style = PaintingStyle.fill;

    final path = Path();
    final radius = size.height / 2;
    final curveHeight = 30;
    final curveWidth = 70;

    path.moveTo(0, size.height / 2);
    path.arcToPoint(
      Offset(radius * 1.5, 0),
      radius: Radius.circular(radius * 1.5),
    );
    path.lineTo((size.width / 2) - curveWidth, 0);

    path.cubicTo(
      (size.width / 2) - curveWidth / 2,
      0,
      (size.width / 2) - curveWidth / 2,
      -curveHeight,
      size.width / 2,
      -curveHeight,
    );

    path.cubicTo(
      (size.width / 2) + curveWidth / 2,
      -curveHeight,
      (size.width / 2) + curveWidth / 2,
      0,
      (size.width / 2) + curveWidth,
      0,
    );

    path.lineTo(size.width - (radius * 1.5), 0);
    path.arcToPoint(
      Offset(size.width, size.height / 2),
      radius: Radius.circular(radius * 1.5),
    );
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: Radius.circular(radius),
    );
    path.lineTo(radius, size.height);
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: Radius.circular(radius),
    );
    path.close();

    canvas.drawShadow(path, Colors.grey.withOpacity(0.4), 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
