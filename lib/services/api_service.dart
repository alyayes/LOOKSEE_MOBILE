import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  // GANTI IP INI dengan IP Laptop Anda (hasil ipconfig)
  static const String baseUrl = "http://localhost:8000";

  Future<List<PostModel>> fetchTrends() async {
    final response = await http.get(Uri.parse('$baseUrl/community/trends'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data dari server');
    }
  }
}