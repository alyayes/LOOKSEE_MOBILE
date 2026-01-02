import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/style_journal_model.dart';

class StyleJournalService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<StyleJournal>> fetchJournals() async {
    final response = await http.get(
      Uri.parse('$baseUrl/stylejournals'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      List data = decoded['data'];

      return data
          .map((item) => StyleJournal.fromJson(item))
          .toList();
    } else {
      throw Exception('Gagal load style journal');
    }
  }
}
