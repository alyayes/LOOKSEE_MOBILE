import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login.dart'; // Pastikan ada class LoginScreen
import 'register_page.dart'; // Pastikan ada class RegisterPage

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // State untuk urutan muncul
  bool _startBgAnimation = false;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    
    // 1. Mulai animasi background (setelah 0.5 detik)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _startBgAnimation = true);
    });

    // 2. Munculkan Logo, Teks & Tombol (setelah 4.5 detik)
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // === 1. BACKGROUND GRADIENT ANIMATION ===
          AnimatedContainer(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: _startBgAnimation
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFC0CB), Color(0xFFFFF0F5), Colors.white],
                    )
                  : const LinearGradient(colors: [Colors.white, Colors.white]),
            ),
          ),

          // === 2. ISI HALAMAN ===
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- BAGIAN ANIMASI LOTTIE (MUNCUL DULUAN) ---
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    // Geser ke atas sedikit saat konten bawah muncul
                    height: _showContent ? size.height * 0.02 : size.height * 0.1, 
                  ),

                  // ANIMASI ORANG PAKAI OUTFIT (LOTTIE)
                  SizedBox(
                    height: size.height * 0.35, 
                    child: Lottie.network(
                      // URL Animasi Wanita Fashion
                      'https://lottie.host/56378356-0674-4e82-9130-582119061269/t6W6Z8j22z.json',
                      fit: BoxFit.contain,
                      // BUILDER JIKA ANIMASI GAGAL LOAD (Misal gak ada internet)
                      errorBuilder: (context, error, stackTrace) {
                         // Jika error, tampilkan icon hanger (tidak ada logo di sini)
                         return const Icon(Icons.checkroom, size: 100, color: Color(0xFFFF69B4));
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // --- BAGIAN LOGO, TEKS & TOMBOL (FADE IN SETELAH 4.5 DETIK) ---
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 1000), 
                    opacity: _showContent ? 1.0 : 0.0, // Ini kuncinya: opacity 0 sebelum waktunya
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          // === LOGO UTAMA (MUNCUL BARENG TOMBOL) ===
                          Container(
                            width: 130, height: 130,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.pink.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))
                              ],
                            ),
                            // Memanggil file assets/logoo.png
                            child: Image.asset('assets/logoo.png', fit: BoxFit.contain),
                          ),
                          // =================================

                          const SizedBox(height: 25),

                          // Judul & Tagline
                          const Text(
                            "LOOKSEE",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 2, color: Color(0xFFFF69B4)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Find your best outfit style here!\nOwn the mood.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
                          ),

                          const SizedBox(height: 40), 

                          // TOMBOL REGISTER (PINK)
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _showContent ? () { 
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                              } : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF69B4),
                                foregroundColor: Colors.white,
                                elevation: 8,
                                shadowColor: const Color(0xFFFF69B4).withOpacity(0.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Text("REGISTER", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // TOMBOL LOGIN (PUTIH)
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _showContent ? () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                              } : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFFF69B4),
                                elevation: 0,
                                side: const BorderSide(color: Color(0xFFFF69B4), width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Text("LOGIN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}