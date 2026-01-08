import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IP 10.0.2.2 adalah alamat khusus Android Emulator untuk mengakses localhost laptop
  // Pastikan Laravel dijalankan dengan: php artisan serve (default port 8000)
  static const String baseUrl = "http://10.0.2.2:8000/api";

  // Variabel statis untuk menyimpan token selama aplikasi berjalan
  static String? _token;

  // Helper Header
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // ===============================================================
  // 1. AUTHENTICATION
  // ===============================================================

  Future<String> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _getHeaders(),
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': password,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return "OK";
      } else {
        return response.body;
      }
    } catch (e) {
      return "Error Koneksi: $e";
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _token = data['token']; // Simpan token hasil login
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        _token = null;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ===============================================================
  // 2. PROFILE MANAGEMENT (Sinkron dengan ProfileController.php Anda)
  // ===============================================================

  // Fungsi ini akan mengambil data User, Alamat, dan Postingan sekaligus
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'), 
        headers: _getHeaders()
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print("Error getProfile: $e");
      return null;
    }
  }

  // Update Profile User
  Future<bool> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/profile/update'),
        headers: _getHeaders(),
        body: jsonEncode(updateData),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ===============================================================
  // 3. POSTS (STYLE)
  // ===============================================================

  // Membuat Postingan Baru (Todays Outfit)
  // Catatan: Jika mengirim file asli, gunakan http.MultipartRequest
  Future<bool> createPost(String caption, String mood, String? hashtags, String imagePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/profile/post'));
      request.headers.addAll(_getHeaders());
      request.fields['caption'] = caption;
      request.fields['mood'] = mood;
      if (hashtags != null) request.fields['hashtags'] = hashtags;
      
      // Menambahkan file gambar
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      var response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      print("Error createPost: $e");
      return false;
    }
  }

  Future<bool> deletePost(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/profile/post/$id'), 
        headers: _getHeaders()
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ===============================================================
  // 4. PRODUCTS & SHOPPING
  // ===============================================================

  Future<List<dynamic>> getProducts({String? mood, String? category}) async {
    try {
      String url = '$baseUrl/produk?';
      if (mood != null) url += 'mood=$mood&';
      if (category != null) url += 'category=$category';

      final response = await http.get(Uri.parse(url), headers: _getHeaders());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data is List ? data : data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ===============================================================
  // 5. CART
  // ===============================================================

  Future<List<dynamic>> getCartItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cart'), headers: _getHeaders());
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['data']['items'] ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> addToCart(String productId, int qty) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: _getHeaders(),
        body: jsonEncode({'product_id': productId, 'quantity': qty}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ===============================================================
  // 6. FAVORITES
  // ===============================================================

  Future<Map<String, dynamic>?> getFavorites() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/favorites'), headers: _getHeaders());
      if (response.statusCode == 200) return json.decode(response.body);
      return null;
    } catch (e) {
      return null;
    }
  }
}