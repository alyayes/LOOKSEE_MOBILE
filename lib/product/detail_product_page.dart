import 'package:flutter/material.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({Key? key}) : super(key: key);

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  int _selectedImageIndex = 0;
  String _selectedSize = 'M';
  bool _isFavorite = false;
  
  final List<String> _productImages = [
    'assets/lily depan.png',
    'assets/model.png',
    'assets/lily belakang.png',
  ];
  
  final List<String> _sizes = ['S', 'M', 'L'];
  
  final List<Map<String, String>> _lookStyleUsers = [
    {'image': 'assets/eunsoo.png', 'name': 'eunsoo0o'},
    {'image': 'assets/priwooa.png', 'name': 'priwooa'},
    {'image': 'assets/melowdy.png', 'name': 'mello'},
  ];
  
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Luxe',
      'date': '01 Jan',
      'rating': 4,
      'comment': 'GEMES BANGETTTT KNITNYA ⭐⭐⭐⭐',
    },
    {
      'name': 'Miewlabide',
      'date': '15 Feb',
      'rating': 5,
      'comment': 'So prettyy 😍😭 ⭐⭐⭐⭐⭐',
    },
    {
      'name': 'Nana',
      'date': '20 Feb',
      'rating': 5,
      'comment': 'Bahannya adem banget, suka! ⭐⭐⭐⭐⭐',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const pinkColor = Color(0xFFFF69B4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Scrollable Content
          CustomScrollView(
            slivers: [
              // Image Section
              SliverToBoxAdapter(
                child: Container(
                  height: size.height * 0.6,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset(
                      _productImages[_selectedImageIndex],
                      key: ValueKey<int>(_selectedImageIndex),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              // Content Section
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "Lily Top",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text(
                                "4.9",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Happy Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: pinkColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          "Happy",
                          style: TextStyle(
                            color: pinkColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Product Details
                      const Text(
                        "Product Details",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Achieve a chic retro look with this Mint Green knit cardigan featuring classic cream accents. Crafted from soft, breathable textured fabric for all-day comfort.",
                        style: TextStyle(
                          color: Colors.grey[600],
                          height: 1.5,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Size Selector
                      const Text(
                        "Size",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: _sizes.map((size) => _buildSizeOption(size)).toList(),
                      ),
                      const SizedBox(height: 18),

                      // Look Style
                      const Text(
                        "Look Style",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _lookStyleUsers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _buildUserThumb(
                                _lookStyleUsers[index]['image']!,
                                _lookStyleUsers[index]['name']!,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Review Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: "4.9 ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: pinkColor,
                                  ),
                                ),
                                TextSpan(
                                  text: "34 reviews",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "See all",
                            style: TextStyle(
                              fontSize: 12,
                              color: pinkColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _reviews.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _buildReviewCard(_reviews[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Header Icons (Back & Love)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, size: 22, color: Colors.black87),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 22,
                      color: _isFavorite ? pinkColor : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Thumbnail Gallery
          Positioned(
            top: (size.height * 0.6) - 35,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_productImages.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _buildThumbnail(index),
                );
              }),
            ),
          ),

          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Total Price",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Rp295.000",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(int index) {
    bool isSelected = _selectedImageIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedImageIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFFF69B4) : Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.15 : 0.1),
              blurRadius: isSelected ? 8 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            _productImages[index],
            width: 45,
            height: 45,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 45,
                height: 45,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, size: 20, color: Colors.grey),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSizeOption(String sizeLabel) {
    bool isSelected = _selectedSize == sizeLabel;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = sizeLabel;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF69B4) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF69B4)
                : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            sizeLabel,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserThumb(String img, String name) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 68,
            height: 82,
            color: Colors.grey.shade200,
            child: Image.asset(
              img,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person, size: 35, color: Colors.grey);
              },
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 7,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              name,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  review['name'][0],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      review['date'],
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 13,
                color: index < review['rating']
                    ? Colors.amber
                    : Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            review['comment'],
            style: const TextStyle(fontSize: 11, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}