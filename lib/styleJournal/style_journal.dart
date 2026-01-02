import 'package:flutter/material.dart';
import '../services/api_service.dart'; // SESUAI LOKASI ApiService kamu

// =======================================================
// MODEL STYLE JOURNAL
// =======================================================
class StyleJournal {
  final int id;
  final String title;
  final String content;
  final String? image;
  final String? formattedDate;

  StyleJournal({
    required this.id,
    required this.title,
    required this.content,
    this.image,
    this.formattedDate,
  });

  factory StyleJournal.fromJson(Map<String, dynamic> json) {
    return StyleJournal(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      formattedDate: json['formatted_date'],
    );
  }
}

// =======================================================
// SCREEN STYLE JOURNAL
// =======================================================
class StyleJournalScreen extends StatefulWidget {
  const StyleJournalScreen({super.key});

  @override
  State<StyleJournalScreen> createState() => _StyleJournalScreenState();
}

class _StyleJournalScreenState extends State<StyleJournalScreen> {
  final ApiService apiService = ApiService();
  late Future<List<StyleJournal>> journalsFuture;

  @override
  void initState() {
    super.initState();
    journalsFuture = _loadJournals();
  }

  Future<List<StyleJournal>> _loadJournals() async {
    final data = await apiService.getStyleJournals();
    return data.map<StyleJournal>((e) => StyleJournal.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Style Journal'),
        backgroundColor: const Color(0xFFF792B1),
      ),
      body: FutureBuilder<List<StyleJournal>>(
        future: journalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final journals = snapshot.data!;

          if (journals.isEmpty) {
            return const Center(child: Text('Belum ada Style Journal'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: journals.length,
            itemBuilder: (context, index) {
              return StyleJournalCard(journal: journals[index]);
            },
          );
        },
      ),
    );
  }
}

// =======================================================
// CARD STYLE JOURNAL
// =======================================================
class StyleJournalCard extends StatelessWidget {
  final StyleJournal journal;

  const StyleJournalCard({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (journal.image != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                journal.image!,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const SizedBox(height: 220),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  journal.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (journal.formattedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      journal.formattedDate!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  journal.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
