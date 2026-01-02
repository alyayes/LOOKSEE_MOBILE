import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/style_journal_model.dart';

class StyleJournalService {
  static const String baseUrl = 'http://localhost:8000';

  Future<List<StyleJournal>> fetchJournals() async {
    final response = await http.get(Uri.parse('$baseUrl/stylejournals'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List data = decoded['data'];

      return data.map((e) => StyleJournal.fromJson(e)).toList();
    } else {
      throw Exception('Gagal load style journal');
    }
  }

  Future<StyleJournal> fetchJournalById(int id) async {
  final response =
      await http.get(Uri.parse('$baseUrl/stylejournals/$id'));

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    return StyleJournal.fromJson(decoded);
  } else {
    throw Exception('Gagal load detail');
  }
}

}
