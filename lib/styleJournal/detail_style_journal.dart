import 'package:flutter/material.dart';
import '../services/style_journal_service.dart';
import '../models/style_journal_model.dart';

class DetailStyleJournal extends StatelessWidget {
  final int journalId;

  const DetailStyleJournal({
    super.key,
    required this.journalId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Style Journal'),
        centerTitle: true,
      ),
      body: FutureBuilder<StyleJournal>(
        future: StyleJournalService().fetchJournalById(journalId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat detail'));
          }

          final item = snapshot.data!;
          final imageUrl = item.image != null
              ? 'http://10.0.2.2:8000/storage/${item.image}'
              : '';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.image)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.formattedDate,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        item.content,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
