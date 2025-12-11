import 'package:flutter/material.dart';
import '../navbar/navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // === DATA DUMMY (MOOD & GAMBAR) ===
  double _moodValue = 0.75;
  final List<String> _moodImages = [
    'assets/gif/sangatSedih.gif',
    'assets/gif/sedih.gif',
    'assets/gif/biasa.gif',
    'assets/gif/senang.gif',
    'assets/gif/sangatSenang.gif'
  ];
  final List<String> _moodLabels = ['Very Sad', 'Sad', 'Neutral', 'Happy', 'Very Happy!'];

  int get _currentMoodIndex {
    int index = (_moodValue * (_moodImages.length - 1)).round();
    return index.clamp(0, _moodImages.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildHomeContent(),
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
    );
  }

  // =========================================================
  // ISI KONTEN HOME
  // =========================================================
  Widget _buildHomeContent() {
    return Stack(
      children: [
        // Background Gradient
        Container(
          height: 250,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFC0CB), Color(0xFFFFF0F5), Colors.white],
            ),
          ),
        ),

        // Konten Scrollable
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Hi, Lucy",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.black54),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_none, color: Colors.black54),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 15),
                
                // Search Bar
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Color(0xFFFF69B4)),
                      hintText: "Search...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                
                // Banner
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage('assets/banner.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 60,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                
                // Latest Product
                _buildSectionTitle("Latest Product"),
                const SizedBox(height: 10),
                _buildHorizontalProductList(),
                
                const SizedBox(height: 20),
                
                // Mood Section
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFFF69B4).withOpacity(0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Choose your mood!",
                        style: TextStyle(
                          color: Color(0xFFFF69B4),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset(
                          _moodImages[_currentMoodIndex],
                          fit: BoxFit.contain,
                          key: ValueKey<int>(_currentMoodIndex),
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.emoji_emotions,
                              size: 60,
                              color: Color(0xFFFF69B4),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: const Color(0xFFFF69B4).withOpacity(0.3),
                                    thumbColor: const Color(0xFFFF69B4),
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                                    trackHeight: 6,
                                    overlayColor: const Color(0xFFFF69B4).withOpacity(0.1),
                                  ),
                                  child: Slider(
                                    value: _moodValue,
                                    onChanged: (val) {
                                      setState(() => _moodValue = val);
                                    },
                                  ),
                                ),
                                Text(
                                  _moodLabels[_currentMoodIndex],
                                  style: const TextStyle(
                                    color: Color(0xFFFF69B4),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/product');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF69B4).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Color(0xFFFF69B4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                _buildSectionTitle("Woman"),
                const SizedBox(height: 10),
                _buildHorizontalProductList(),
                
                const SizedBox(height: 25),
                _buildSectionTitle("Man"),
                const SizedBox(height: 10),
                _buildHorizontalProductList(),
                
                // Padding bawah agar tidak tertutup Navbar
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildHorizontalProductList() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.pink.withOpacity(0.2)),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/shirt1.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.checkroom,
                    color: Colors.grey,
                    size: 40,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}