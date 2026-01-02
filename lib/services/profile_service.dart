import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';

class ProfileService {
  final String baseUrl = 'http://localhost:8000';

  Future<ProfileResponse> fetchProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ProfileResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memuat profile');
    }
  }
}
