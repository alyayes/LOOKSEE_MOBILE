import 'package:flutter/material.dart';

void main() {
  runApp(const TodaysOutfitApp());
}

class TodaysOutfitApp extends StatelessWidget {
  const TodaysOutfitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todays Outfit',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const TodaysOutfitScreen(),
    );
  }
}

// Enum untuk filter kategori
enum FilterCategory { all, woman, man }

// =================================================================
// MAIN SCREEN DENGAN TABBAR & TABBARVIEW
// =================================================================

class TodaysOutfitScreen extends StatefulWidget {
  const TodaysOutfitScreen({super.key});

  @override
  State<TodaysOutfitScreen> createState() => _TodaysOutfitScreenState();
}

// Tambahkan SingleTickerProviderStateMixin untuk TabController
class _TodaysOutfitScreenState extends State<TodaysOutfitScreen> with SingleTickerProviderStateMixin {
  FilterCategory _selectedFilter = FilterCategory.all;
  late TabController _tabController;

  // --- 1. Data untuk Tab EXPLORE (Data Utama) ---
  final List<Map<String, dynamic>> exploreItems = const [
    {
      'title': 'Pinky outfit for toda...', 'user': 'Lucy', 'mood': 'Happy',
      'moodColor': Color(0xFFF7A2B4), 'imageColor': Color(0xFFFDE4E6),
      'profileColor': Color(0xFFF5C7C7), 'imagePath': 'assets/to4.jpg', 
    },
    {
      'title': 'Just simple fit', 'user': 'Louis', 'mood': 'Neutral',
      'moodColor': Color(0xFFD4D4D4), 'imageColor': Color(0xFFEBEBEB),
      'profileColor': Color(0xFFB0C4DE), 'imagePath': 'assets/to3.jpeg',
    },
    {
      'title': "Today's Class was...", 'user': 'Lucy', 'mood': 'Very Happy',
      'moodColor': Color(0xFFF28F9E), 'imageColor': Color(0xFFF5F5F5),
      'profileColor': Color(0xFFF5C7C7), 'imagePath': 'assets/to1.jpg',
    },
    {
      'title': 'Gloomy day, gloo...', 'user': 'Louis', 'mood': 'Sad',
      'moodColor': Color(0xFFADD8E6), 'imageColor': Color(0xFF303030),
      'profileColor': Color(0xFFB0C4DE), 'imagePath': 'assets/to2.jpg',
    },
    {
      'title': 'Summer Vibes', 'user': 'Mia', 'mood': 'Verry Sad',
      'moodColor': Color(0xFFFFA07A), 'imageColor': Color(0xFFFFEBCD),
      'profileColor': Color(0xFFFFB6C1), 'imagePath': 'assets/to7.jpg',
    },
    {
      'title': 'Formal Look', 'user': 'Leo', 'mood': 'Neutral',
      'moodColor': Color(0xFF90EE90), 'imageColor': Color(0xFFD3D3D3),
      'profileColor': Color(0xFF87CEEB), 'imagePath': 'assets/to6.jpeg',
    },
  ];

  // --- 2. Data untuk Tab TRENDS (Layout sama, Gambar Beda) ---
  final List<Map<String, dynamic>> trendsItems = const [
    {
      'title': 'Best Streetwear 2024', 'user': 'Sam', 'mood': 'Sad',
      'moodColor': Color(0xFF4682B4), 'imageColor': Color(0xFFE0FFFF),
      'profileColor': Color(0xFFA9A9A9), 'imagePath': 'assets/to2.jpg', 
    },
    {
      'title': 'Aesthetic Vintage', 'user': 'Anna', 'mood': 'Happy',
      'moodColor': Color(0xFF8FBC8F), 'imageColor': Color(0xFFFAFAD2),
      'profileColor': Color(0xFFBDB76B), 'imagePath': 'assets/to8.jpg',
    },
    {
      'title': 'Minimalist Core', 'user': 'Alex', 'mood': 'Sad',
      'moodColor': Color(0xFF696969), 'imageColor': Color(0xFFF0F0F0),
      'profileColor': Color(0xFF6A5ACD), 'imagePath': 'assets/to1.jpg',
    },
    // Menggunakan data explore untuk sisa list
    ...const [
      {
        'title': 'Gloomy day, gloo...', 'user': 'Louis', 'mood': 'Sad',
        'moodColor': Color(0xFFADD8E6), 'imageColor': Color(0xFF303030),
        'profileColor': Color(0xFFB0C4DE), 'imagePath': 'assets/to9.jpeg',
      },
      {
        'title': 'Summer Vibes', 'user': 'Mia', 'mood': 'Verry Happy',
        'moodColor': Color(0xFFFFA07A), 'imageColor': Color(0xFFFFEBCD),
        'profileColor': Color(0xFFFFB6C1), 'imagePath': 'assets/to7.jpg',
      },
      {
        'title': 'Formal Look', 'user': 'Leo', 'mood': 'Happy',
        'moodColor': Color(0xFF90EE90), 'imageColor': Color(0xFFD3D3D3),
        'profileColor': Color(0xFF87CEEB), 'imagePath': 'assets/to10.jpeg',
      },
    ]
  ];

  // --- 3. Data untuk Tab LATEST (Layout sama, Gambar Beda) ---
  final List<Map<String, dynamic>> latestItems = const [
    {
      'title': 'New In: Velvet Dress', 'user': 'Eva', 'mood': 'Verry Sad',
      'moodColor': Color(0xFF800080), 'imageColor': Color(0xFFE6E6FA),
      'profileColor': Color(0xFFC71585), 'imagePath': 'assets/to11.jpeg', 
    },
    {
      'title': 'Cargo Pants Fit', 'user': 'Tom', 'mood': 'Neutral',
      'moodColor': Color(0xFF6B8E23), 'imageColor': Color(0xFFF5F5DC),
      'profileColor': Color(0xFF8B4513), 'imagePath': 'assets/to4.jpg',
    },
    {
      'title': 'Casual Sunday', 'user': 'Jane', 'mood': 'Happy',
      'moodColor': Color(0xFF00CED1), 'imageColor': Color(0xFFF0FFFF),
      'profileColor': Color(0xFF4682B4), 'imagePath': 'assets/to8.jpg',
    },
    // Menggunakan data explore untuk sisa list
    ...const [
      {
        'title': 'Pinky outfit for toda...', 'user': 'Lucy', 'mood': 'Happy',
        'moodColor': Color(0xFFF7A2B4), 'imageColor': Color(0xFFFDE4E6),
        'profileColor': Color(0xFFF5C7C7), 'imagePath': 'assets/to4.jpg', 
      },
      {
        'title': 'Just simple fit', 'user': 'Louis', 'mood': 'Neutral',
        'moodColor': Color(0xFFD4D4D4), 'imageColor': Color(0xFFEBEBEB),
        'profileColor': Color(0xFFB0C4DE), 'imagePath': 'assets/to3.jpeg',
      },
      {
        'title': "Today's Class was...", 'user': 'Lucy', 'mood': 'Very Happy',
        'moodColor': Color(0xFFF28F9E), 'imageColor': Color(0xFFF5F5F5),
        'profileColor': Color(0xFFF5C7C7), 'imagePath': 'assets/to1.jpg',
      },
    ]
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Helper Functions ---

  Widget _buildMoodTag(String mood, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        mood,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOutfitItem(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gambar Outfit (Menggunakan Image.asset)
        AspectRatio(
          aspectRatio: 3 / 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item['imagePath'] != null
                ? Image.asset(
                    item['imagePath'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.red[100],
                        child: const Center(
                          child: Icon(Icons.error_outline, color: Colors.red, size: 40),
                        ),
                      );
                    },
                  )
                : Container(
                    color: item['imageColor'],
                    child: const Center(child: Icon(Icons.photo, size: 40, color: Colors.grey)),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        // Title
        Text(
          item['title'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        // User Info dan Mood Tag
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 8,
                  backgroundColor: item['profileColor'],
                  child: Text(
                    (item['user'] as String).substring(0, 1),
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  item['user'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            _buildMoodTag(item['mood'] as String, item['moodColor'] as Color),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryPill(String text, FilterCategory category, {IconData? icon, bool isStatic = false}) {
    bool isSelected = !isStatic && _selectedFilter == category;
    Color textColor = isSelected ? Colors.white : Colors.black;
    Color backgroundColor = isSelected ? const Color(0xFFF7A2B4) : Colors.white;
    Color borderColor = isSelected ? const Color(0xFFF7A2B4) : Colors.grey.shade300;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: isStatic
            ? () {
                print('Tombol Filter ditekan!');
              }
            : () {
                setState(() {
                  _selectedFilter = category;
                });
                print('Filter dipilih: $text');
              },
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: Size.zero,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 16),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isSelected) {
    final Color selectedColor = const Color(0xFFF7A2B4);
    final Color defaultColor = Colors.grey;

    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? selectedColor : defaultColor,
            size: 24,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? selectedColor : defaultColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- Custom App Bar (Hanya Judul dan Pencarian) ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Todays Outfit'),
            actions: [
              Container(
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.search, color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // --- Area Konten Utama ---
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Baris Navigasi Horizontal/Tab ---
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: const Color(0xFFF7A2B4),
                  labelColor: const Color(0xFFF7A2B4),
                  unselectedLabelColor: Colors.black,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabAlignment: TabAlignment.start,
                  tabs: const [
                    Tab(text: 'Explore'),
                    Tab(text: 'Trends'),
                    Tab(text: 'Latest'),
                  ],
                ),
                const Divider(height: 1, color: Colors.grey),
              ],
            ),
          ),

          // --- Baris Filter/Kategori (Horizontal Scroll) ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildCategoryPill('All', FilterCategory.all),
                  _buildCategoryPill('Woman', FilterCategory.woman),
                  _buildCategoryPill('Man', FilterCategory.man),
                  _buildCategoryPill('Filter', FilterCategory.all, icon: Icons.filter_list, isStatic: true),
                ],
              ),
            ),
          ),

          // --- TabBarView (Konten Halaman yang Berpindah) ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // EXPLORE: Meneruskan exploreItems
                ExplorePage(
                  outfitItems: exploreItems, 
                  buildOutfitItem: _buildOutfitItem,
                ),
                // TRENDS: Meneruskan trendsItems
                ExplorePage(
                  outfitItems: trendsItems, 
                  buildOutfitItem: _buildOutfitItem,
                ),
                // LATEST: Meneruskan latestItems
                ExplorePage(
                  outfitItems: latestItems, 
                  buildOutfitItem: _buildOutfitItem,
                ),
              ],
            ),
          ),
        ],
      ),

      // --- Custom Bottom Navigation Bar ---
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.home, 'Home', false),
              _buildBottomNavItem(const MyCustomIconData(0xe900), 'Todays Outfit', true),
              const SizedBox(width: 40),
              _buildBottomNavItem(Icons.file_copy, 'Style Journal', false),
              _buildBottomNavItem(Icons.person, 'Profile', false),
            ],
          ),
        ),
      ),
      // --- Tombol Aksi Terapung (FAB) Sentral ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: FloatingActionButton(
          onPressed: () {
            print('Post My Style ditekan!');
          },
          backgroundColor: const Color(0xFFF7A2B4),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

// =================================================================
// HALAMAN KONTEN TAB
// =================================================================

class ExplorePage extends StatelessWidget {
  final List<Map<String, dynamic>> outfitItems;
  final Widget Function(Map<String, dynamic>) buildOutfitItem; 

  const ExplorePage({
    super.key, 
    required this.outfitItems, 
    required this.buildOutfitItem
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.65,
        ),
        itemCount: outfitItems.length,
        itemBuilder: (context, index) {
          final item = outfitItems[index];
          
          // GestureDetector membuat item dapat diklik
          return GestureDetector( 
            onTap: () {
              // Navigasi ke halaman detail saat diklik
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OutfitDetailPage(item: item),
                ),
              );
            },
            child: buildOutfitItem(item), // Memanggil fungsi item builder dari parent
          );
        },
      ),
    );
  }
}

// =================================================================
// HALAMAN DETAIL (TARGET KLIK POSTINGAN)
// =================================================================

class OutfitDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const OutfitDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Outfit'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Anda telah melihat postingan:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                item['title'] as String,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: const Color(0xFFF7A2B4),
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Menampilkan gambar (jika ada)
              if (item['imagePath'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item['imagePath'] as String,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        color: Colors.red[100],
                        child: const Center(child: Text('Gagal memuat gambar detail.')),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Text('Diposting oleh: ${item['user']} (Mood: ${item['mood']})'),
              const SizedBox(height: 40),
              const Text('Ini adalah halaman detail outfit yang dapat Anda kembangkan lebih lanjut.'),
            ],
          ),
        ),
      ),
    );
  }
}

// Kelas data ikon kustom untuk mensimulasikan ikon orang/grup
class MyCustomIconData extends IconData {
  const MyCustomIconData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'MaterialIcons',
        );
}