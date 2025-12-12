import 'package:flutter/material.dart';
import '../auth/login.dart'; 
import '../auth/register_page.dart'; 

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // State untuk animasi
  bool _startBgAnimation = false;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    
    // 1. Mulai animasi background (setelah 0.5 detik)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _startBgAnimation = true);
    });

    // 2. Munculkan Logo & Tombol (setelah 1.5 detik - lebih cepat karena tidak ada Lottie)
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  @override
  Widget build(BuildContext context) {
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

          // === 2. KONTEN (Logo & Tombol) ===
          SafeArea(
            child: Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1200), // Muncul pelan-pelan
                opacity: _showContent ? 1.0 : 0.0, 
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      
                      // LOGO UTAMA
                      Container(
                        width: 160, height: 160,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.pink.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))
                          ],
                        ),
                        child: Image.asset('assets/logoo.png', fit: BoxFit.contain),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // TEXT
                      const Text(
                        "LOOKSEE",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2, color: Color(0xFFFF69B4)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Find your best outfit style here!\nOwn the mood.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
                      ),

                      const Spacer(),

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

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}