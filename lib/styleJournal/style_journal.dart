import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../navbar/navbar.dart';
import 'detail_style_journal.dart';

class StyleJournalScreen extends StatefulWidget {
  const StyleJournalScreen({super.key});

  @override
  State<StyleJournalScreen> createState() => _StyleJournalScreenState();
}

class _StyleJournalScreenState extends State<StyleJournalScreen> {
  final StyleJournalService _service = StyleJournalService();

  late Future<List<StyleJournal>> _journalsFuture;

  @override
  void initState() {
    super.initState();
    fetchStyleJournals();
  }

  Future<void> fetchStyleJournals() async {
    final url = Uri.parse('http://10.128.83.120:8001/api/stylejournals');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        setState(() {
          journalData = decoded['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Style Journal",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Fashion Insights",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Explore tips, tricks, and trends!",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 25),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: CircularProgressIndicator(color: Color(0xFFFF69B4)),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: journalData.length,
                  itemBuilder: (context, index) {
                    final item = journalData[index];
                    return HoverFashionCard(
                      imagePath: item['image'] != null
                          ? 'http://10.128.83.120:8001/storage/${item['image']}'
                          : '',
                      title: item['title'] ?? 'No Title',
                      content: item['content'] ?? '',
                      date: item['formatted_date'] ?? '',
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

class HoverFashionCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String content;
  final String date;

  const HoverFashionCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.content,
    required this.date,
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailStyleJournal(
                imagePath: widget.imagePath,
                title: widget.title,
                content: widget.content,
                date: widget.date,
              ),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
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
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
                AnimatedOpacity(
                  opacity: _isHovering ? 0.7 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(color: Colors.black),
                ),
                AnimatedOpacity(
                  opacity: _isHovering ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                ),
                const SizedBox(height: 30),

                // ================= LIST =================
                ...data.map((item) {
                  final imageUrl = item.image != null
                      ? 'http://10.0.2.2:8000/storage/${item.image}'
                      : '';

                  return HoverFashionCard(
                    id: item.id,
                    imagePath: imageUrl,
                    title: item.title,
                  );
                }).toList(),

                const SizedBox(height: 120),
              ],
            );
          },
        ),
      ),
    );
  }
}