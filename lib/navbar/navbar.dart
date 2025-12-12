import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todays Outfit coming soon!'),
            duration: Duration(milliseconds: 800),
          ),
        );
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post My Style coming soon!'),
            duration: Duration(milliseconds: 800),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/favorite');
        break;
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile coming soon!'),
            duration: Duration(milliseconds: 800),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 15),
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFF69B4), // Pink tetap
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background navbar items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(context, 0, Icons.home_outlined),
              _buildNavItem(context, 1, Icons.group_outlined),
              const SizedBox(width: 60), // Space for center button
              _buildNavItem(context, 3, Icons.receipt_long_outlined),
              _buildNavItem(context, 4, Icons.person_outline),
            ],
          ),
          
          // Center floating button - LEBIH MENONJOL KE ATAS
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 54,
            top: -12,
            child: _buildCenterButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon) {
    final isSelected = currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(context, index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Icon(
              icon,
              size: 26,
              color: isSelected 
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _onItemTapped(context, 2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFFF69B4), // Pink tetap
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}