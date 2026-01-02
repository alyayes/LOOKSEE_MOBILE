import 'package:flutter/material.dart';
import 'detail_style_journal.dart';

class HoverFashionCard extends StatefulWidget {
  final int id;
  final String imagePath;
  final String title;

  const HoverFashionCard({
    super.key,
    required this.id,
    required this.imagePath,
    required this.title,
  });

  @override
  State<HoverFashionCard> createState() => _HoverFashionCardState();
}

class _HoverFashionCardState extends State<HoverFashionCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ⬇️ NAVIGASI + ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailStyleJournal(journalId: widget.id),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 25),
          height: 200,
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
                Image.network(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.image)),
                ),
                AnimatedOpacity(
                  opacity: _hover ? 0.6 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(color: Colors.black),
                ),
                AnimatedOpacity(
                  opacity: _hover ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Center(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
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
