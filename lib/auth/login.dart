import 'package:flutter/material.dart';
import 'register_page.dart'; 
import '../services/api_service.dart'; // Import ApiService

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false; // Variable untuk loading

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // --- LOGIKA LOGIN (BARU) ---
  void _handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // 1. Validasi Input
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi Username dan Password!")),
      );
      return;
    }

    // 2. Mulai Loading
    setState(() => _isLoading = true);

    // 3. Panggil API Login
    bool isSuccess = await ApiService().login(username, password);

    // 4. Stop Loading
    setState(() => _isLoading = false);

    // 5. Cek Hasil
    if (isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Berhasil!"),
            backgroundColor: Colors.green,
          ),
        );
        // Masuk ke Home
        Navigator.pushReplacementNamed(context, '/home'); 
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Gagal! Cek username atau password."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFC0CB), Color(0xFFFFF0F5), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                // LOGO
                Container(
                  width: 140, height: 140,
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
                  ),
                  child: Center(
                    child: Image.asset('assets/logoo.png', fit: BoxFit.contain),
                  ),
                ),
                
                const SizedBox(height: 30),
                const Text(
                  "Outfit of the Day, Own the Mood!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 40),

                // FORM INPUT
                // Diubah jadi Username & Icon Person
                _buildInput(Icons.person, "Username", controller: _usernameController),
                const SizedBox(height: 20),
                _buildInput(Icons.lock_outline, "Password", isPassword: true, controller: _passwordController),
                
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text("Forgot Password?", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
                  ),
                ),

                const SizedBox(height: 40),

                // TOMBOL LOGIN
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    // Jika loading, tombol dimatikan
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF69B4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    // Jika loading, tampilkan putaran. Jika tidak, tampilkan teks LOGIN
                    child: _isLoading
                      ? const SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Text("LOGIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Link Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(fontSize: 14, color: Colors.black54)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                      },
                      child: const Text("Register", style: TextStyle(fontSize: 14, color: Color(0xFFFF69B4), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(IconData icon, String hint, {bool isPassword = false, TextEditingController? controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black87),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 14), 
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        ),
      ),
    );
  }
}