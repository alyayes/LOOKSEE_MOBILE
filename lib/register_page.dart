import 'package:flutter/material.dart';
import 'login.dart'; // Pastikan file login.dart ada dan class-nya LoginScreen

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;

  // Controller untuk membaca input text
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi Menampilkan Modal Sukses
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User harus klik tombol/icon untuk tutup
      barrierColor: Colors.black.withOpacity(0.6), // Background menggelap
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // KONTEN MODAL
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    // === BAGIAN INI DIGANTI JADI GIF ===
                    // Menampilkan animasi GIF sukses
                    SizedBox(
                      height: 100, // Ukuran tinggi GIF
                      width: 100,  // Ukuran lebar GIF
                      child: Image.asset(
                        'assets/sukses regis.gif', 
                        fit: BoxFit.contain,
                      ),
                    ),
                    // ===================================

                    const SizedBox(height: 20),
                    
                    // Judul
                    const Text(
                      "Pendaftaran Berhasil!",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    
                    // Deskripsi
                    const Text(
                      "Akun Anda telah berhasil dibuat.\nSilahkan masuk untuk melanjutkan.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 25),
                    
                    // TOMBOL MASUK
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Tutup dialog
                          // Pindah ke LoginScreen
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => const LoginScreen())
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF69B4),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text("MASUK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),

              // TOMBOL CLOSE (X) DI POJOK KANAN ATAS
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Hanya tutup modal
                  },
                  child: const Icon(Icons.close, color: Colors.grey, size: 24),
                ),
              ),
            ],
          ),
        );
      },
    );
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
            colors: [
              Color(0xFFFFC0CB), // Pink muda
              Color(0xFFFFF0F5), // Lavender blush
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                // === LOGO ===
                Container(
                  width: 140,
                  height: 140,
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                    ]
                  ),
                  child: Center(
                    // Memanggil gambar dari assets/logoo.png
                    child: Image.asset(
                      'assets/logoo.png', 
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                const Text(
                  "Outfit of the Day, Own the Mood!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 40),

                // FORM INPUT
                _buildInput(Icons.person, "Username", controller: _usernameController),
                const SizedBox(height: 15),
                _buildInput(Icons.email_outlined, "Email Address", controller: _emailController),
                const SizedBox(height: 15),
                _buildInput(Icons.lock_outline, "Password", isPassword: true, controller: _passwordController),
                
                const SizedBox(height: 40),

                // TOMBOL REGISTER
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validasi input kosong
                      if (_usernameController.text.isEmpty || 
                          _emailController.text.isEmpty || 
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Harap isi semua kolom!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        // Tampilkan Modal Sukses (dengan GIF)
                        _showSuccessDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF69B4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "REGISTER",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),

                // TEXT LOGIN LINK (WARNA PINK)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have account? ", style: TextStyle(fontSize: 14, color: Colors.black54)),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke LoginScreen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 14, 
                          color: Color(0xFFFF69B4), // Pink Color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  // Widget Input Builder
  Widget _buildInput(IconData icon, String hint, {bool isPassword = false, TextEditingController? controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
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
          // Toggle Mata Password
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility, 
                  color: Colors.grey
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        ),
      ),
    );
  }
}