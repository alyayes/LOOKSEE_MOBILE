import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IP Laptop Kamu (Sesuai kesepakatan)
  static const String baseUrl = "http://172.28.115.142:8001/api";

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

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _getHeaders(),
        body: jsonEncode({ // Pakai jsonEncode biar aman
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // SIMPAN TOKEN (Penting! Supaya fitur lain bisa jalan)
        _token = data['token']; // Sesuaikan dengan response JSON Laravel kamu
        print("Login Sukses. Token: $_token");
        return true;
      } else {
        print("Login Gagal: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error Login: $e");
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
    final response = await http.get(Uri.parse('$baseUrl/profile'), headers: _getHeaders());
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }

  Future<bool> updateProfile(String name, String phone, String address) async {
    final response = await http.post( // Pakai POST biasanya untuk update data diri di Laravel
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

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/produk'), headers: _getHeaders());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['data'] ?? data; 
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getProductDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/produk/$id'), headers: _getHeaders());
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
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
  // 5. CART (KERANJANG)
  // ===============================================================

  Future<List<dynamic>> getCartItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cart'), headers: _getHeaders());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['data'] ?? data;
      }
      return [];
    } catch (e) {
      print("Error Cart: $e");
      return [];
    }
  }

  Future<bool> addToCart(String productId, int qty, String size) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/add'),
      headers: _getHeaders(),
      body: jsonEncode({
        'product_id': productId,
        'quantity': qty,
        'size': size,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateCartQty(String cartId, int qty) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/update'),
      headers: _getHeaders(),
      body: jsonEncode({
        'cart_id': cartId,
        'quantity': qty,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteCartItem(String cartId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/delete'),
      headers: _getHeaders(),
      body: jsonEncode({'cart_id': cartId}),
    );
    return response.statusCode == 200;
  }

  // ===============================================================
  // 6. CHECKOUT & ORDERS
  // ===============================================================

  Future<dynamic> getCheckoutSummary() async {
    final response = await http.get(Uri.parse('$baseUrl/checkout/summary'), headers: _getHeaders());
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }

  Future<bool> processCheckout(String address, String paymentMethod) async {
    final response = await http.post(
      Uri.parse('$baseUrl/checkout/process'),
      headers: _getHeaders(),
      body: jsonEncode({
        'address': address,
        'payment_method': paymentMethod,
      }),
    );
    return response.statusCode == 200;
  }

  Future<List<dynamic>> getOrders() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders'), headers: _getHeaders());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['data'] ?? data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getOrderDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/orders/$id'), headers: _getHeaders());
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }

  // ===============================================================
  // 7. PAYMENT
  // ===============================================================
  
  Future<dynamic> getPaymentDetails() async {
    final response = await http.get(Uri.parse('$baseUrl/payment/details'), headers: _getHeaders());
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }
}