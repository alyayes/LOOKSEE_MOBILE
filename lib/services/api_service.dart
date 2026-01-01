import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IP Laptop Kamu (Sesuai kesepakatan)
  static const String baseUrl = "http://10.128.85.111:8001/api";

  // Variabel untuk menyimpan Token Login sementara
  static String? _token;

  // Helper untuk Header (Supaya otomatis ada Token-nya kalau sudah login)
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // ===============================================================
  // 1. AUTHENTICATION (Register, Login, Logout, User)
  // ===============================================================

  // Ubah return type jadi Future<String> (Bukan bool lagi)
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

      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return "OK"; // Kode rahasia kalau sukses
      } else {
        // Kembalikan pesan error dari Laravel
        return response.body;
      }
    } catch (e) {
      // Kembalikan pesan error koneksi
      return "Error Koneksi: $e";
    }
  }

  // Di dalam class ApiService di api_service.dart

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // 🔥 PASTIKAN INI TERISI:
        _token = data['token'];
        print("Token tersimpan: $_token");
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
        headers: _getHeaders(), // Butuh token
      );
      if (response.statusCode == 200) {
        _token = null; // Hapus token
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getUser() async {
    final response = await http.get(Uri.parse('$baseUrl/user'), headers: _getHeaders());
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }

  // ===============================================================
  // 2. PROFILE MANAGEMENT
  // ===============================================================

  Future<dynamic> getProfile() async {
    // 🔥 UBAH: Ganti /profile menjadi /user agar sesuai dengan AuthController@user di Laravel
    final response = await http.get(Uri.parse('$baseUrl/user'), headers: _getHeaders());
    
    // Tambahkan print ini untuk memastikan data yang datang adalah "garden"
    print("DEBUG RESPONSE PROFILE: ${response.body}"); 

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  Future<bool> updateProfile(String name, String phone, String address) async {
    final response = await http.post(
      // Pakai POST biasanya untuk update data diri di Laravel
      Uri.parse('$baseUrl/profile/update'),
      headers: _getHeaders(),
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'address': address,
      }),
    );
    return response.statusCode == 200;
  }

  // ===============================================================
  // 3. PRODUCTS (apiResource 'produk')
  // ===============================================================

  Future<List<dynamic>> getProducts({String? mood, String? category}) async {
  try {
    // Menambahkan query parameter untuk filter
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
    print("Error Get Products: $e");
    return [];
  }
}

  // ===============================================================
  // 4. COMMUNITY & POSTS
  // ===============================================================

  Future<List<dynamic>> getTrends() async {
    final response = await http.get(Uri.parse('$baseUrl/community/trends'), headers: _getHeaders());
    if (response.statusCode == 200) return json.decode(response.body)['data'] ?? [];
    return [];
  }

  Future<List<dynamic>> getTodaysOutfit() async {
    final response = await http.get(Uri.parse('$baseUrl/community/todays-outfit'), headers: _getHeaders());
    if (response.statusCode == 200) return json.decode(response.body)['data'] ?? [];
    return [];
  }

  // --- CRUD POSTINGAN PROFILE ---
  Future<bool> createPost(String caption, String imageUrl) async {
    final response = await http.post(
      Uri.parse('$baseUrl/profile/post'),
      headers: _getHeaders(),
      body: jsonEncode({
        'caption': caption,
        'image': imageUrl, // Ini kalau kirim link, kalau kirim file beda lagi (Multipart)
      }),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<bool> deletePost(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/profile/post/$id'), headers: _getHeaders());
    return response.statusCode == 200;
  }

  // ===============================================================
  // 5. CART (KERANJANG) - Sinkron dengan ApiCartController.php
  // ===============================================================

  // 2. ADD CART
  Future<bool> addToCart(String productId, int qty) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: _getHeaders(),
        body: jsonEncode({
          'product_id': productId,
          'quantity': qty,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Ambil isi keranjang
  Future<List<dynamic>> getCartItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cart'), headers: _getHeaders());

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        // Sesuaikan dengan ApiCartController: { "status": "success", "data": { "items": [...] } }
        if (jsonResponse['data'] != null && jsonResponse['data']['items'] != null) {
          return jsonResponse['data']['items'];
        }
      }
      return [];
    } catch (e) {
      print("Error Get Cart: $e");
      return [];
    }
  }

  // Update Quantity (Tambah/Kurang)
  Future<bool> updateCartQty(String productId, int newQty) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart/update'),
        headers: _getHeaders(),
        body: jsonEncode({
          'product_id': productId, // Sesuai $request->input('product_id') di Controller
          'quantity': newQty,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Hapus Item
  Future<bool> deleteCartItem(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart/delete'),
        headers: _getHeaders(),
        body: jsonEncode({
          'product_id': productId,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ===============================================================
  // 6. CHECKOUT & ADDRESS
  // ===============================================================

  // 1. TAMBAHKAN FUNGSI INI DI DALAM CLASS ApiService
  Future<Map<String, dynamic>?> getCheckoutSummary(String productIds) async {
    try {
      // Endpoint ini sesuai dengan getCheckoutData di ApiCheckoutController.php
      final response = await http.get(
        Uri.parse('$baseUrl/checkout/summary?selected_products=$productIds'),
        headers: _getHeaders(),
      );

      print("Response Summary: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print("Error getCheckoutSummary: $e");
      return null;
    }
  }

  // Ambil Daftar Alamat User
  Future<List<dynamic>> getUserAddresses() async {
    final response = await http.get(Uri.parse('$baseUrl/profile'), headers: _getHeaders());
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data']['addresses'] ?? []; // Sesuaikan struktur response Profile kamu
    }
    return [];
  }

  // Proses Simpan Order ke Database (PASTIKAN NAMA PARAMETER SAMA)
  Future<Map<String, dynamic>?> processCheckout({
    required String selectedProducts,
    required String address_id, // Gunakan underscore
    required String payment_method, // Gunakan underscore
    String? bank_id, // Gunakan underscore
    String? ewallet_id, // Gunakan underscore
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkout/process'),
        headers: _getHeaders(),
        body: jsonEncode({
          'selected_products': selectedProducts,
          'address_id': address_id,
          'payment_method': payment_method,
          'bank_id': bank_id,
          'ewallet_id': ewallet_id,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // --- MANAJEMEN ALAMAT ---
  Future<bool> addAddress(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/checkout/add-address'),
      headers: _getHeaders(),
      body: jsonEncode(data),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deleteAddress(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/checkout/delete-address/$id'),
      headers: _getHeaders(),
    );
    return response.statusCode == 200;
  }

  // ===============================================================
  // 7. PAYMENT
  // ===============================================================

  Future<dynamic> getPaymentDetails() async {
    final response = await http.get(Uri.parse('$baseUrl/payment/details'), headers: _getHeaders());
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }

  // ===============================================================
  // 8. FAVORITES & LIKES
  // ===============================================================

  // Ambil daftar produk favorit dan postingan yang di-like
  Future<Map<String, dynamic>?> getFavorites() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favorites'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print("Error getFavorites: $e");
      return null;
    }
  }

  // Toggle Favorite Produk (Tambah jika belum ada, Hapus jika sudah ada)
  Future<Map<String, dynamic>?> toggleFavorite(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/favorites/add'),
        headers: _getHeaders(),
        body: jsonEncode({
          'id_produk': productId,
        }),
      );

      // Status 200 (removed) atau 201 (added)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print("Error toggleFavorite: $e");
      return null;
    }
  }

  // Hapus dari favorit secara spesifik (Memanggil function destroy di API)
  Future<bool> deleteFavorite(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/delete'),
        headers: _getHeaders(),
        body: jsonEncode({
          'id_produk': productId,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error deleteFavorite: $e");
      return false;
    }
  }
} 