import 'package:flutter/material.dart';
import '../navbar/navbar.dart';
import '../services/style_journal_service.dart';
import '../models/style_journal_model.dart';
import 'hover_fashion_card.dart';

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
    _journalsFuture = _service.fetchJournals(); // ✅ PANGGIL SEKALI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),

      body: SafeArea(
        child: FutureBuilder<List<StyleJournal>>(
          future: _journalsFuture, // ✅ PAKAI FUTURE YANG DISIMPAN
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final data = snapshot.data;

            if (data == null || data.isEmpty) {
              return const Center(
                child: Text('Style Journal masih kosong'),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Style Journal',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
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
