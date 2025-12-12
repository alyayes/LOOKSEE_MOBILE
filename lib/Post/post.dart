import 'package:flutter/material.dart';
import 'gallery.dart';
import '../todaysOutfit/todays_outfit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post My Style UI Final',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const PostMyStyleScreen(),
    );
  }
}

class PostMyStyleScreen extends StatefulWidget {
  const PostMyStyleScreen({super.key});

  @override
  State<PostMyStyleScreen> createState() => _PostMyStyleScreenState();
}

class _PostMyStyleScreenState extends State<PostMyStyleScreen> {
  final String assetImagePath = 'assets/to4.jpg';
  
  String? _selectedMood = 'Very Happy'; 

  final List<String> moods = const [
    'Very Happy',
    'Happy',
    'Neutral',
    'Sad',
    'Very Sad',
  ];

  void _selectMood(String mood) {
    setState(() {
      _selectedMood = mood;
    });
  }

  void _handlePost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TodaysOutfitScreen(),
      ),
    );
    
    debugPrint('Mood yang diposting: $_selectedMood');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post My Style',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ImageGridScreen(), 
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  assetImagePath,
                  height: 200,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: 150,
                      color: Colors.grey.shade300,
                      child: const Center(child: Text('Error: Asset not found')),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            const TextField(
              decoration: InputDecoration(
                hintText: 'Add a caption...',
                hintStyle: TextStyle(color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 24.0),

            const Row(
              children: <Widget>[
                Icon(Icons.sentiment_satisfied_alt, color: Colors.black54),
                SizedBox(width: 8.0),
                Text(
                  'Add Mood',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            
            MoodChipsRow(
              moods: moods,
              selectedMood: _selectedMood,
              onMoodSelected: _selectMood,
            ),

            const SizedBox(height: 32.0),

            const AddItemsHeader(),
            const SizedBox(height: 12.0),

            const ProductItemInput(),
            const ProductItemInput(),

            const SizedBox(height: 40.0),

            Center(
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade300.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _handlePost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class MoodChipsRow extends StatelessWidget {
  final List<String> moods;
  final String? selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodChipsRow({
    super.key,
    required this.moods,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: moods.map((moodLabel) {
        final bool isSelected = moodLabel == selectedMood;
        return InkWell(
          onTap: () => onMoodSelected(moodLabel),
          child: Chip(
            label: Text(
              moodLabel,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
            backgroundColor: isSelected ? Colors.pink.shade400 : Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      }).toList(),
    );
  }
}


class AddItemsHeader extends StatelessWidget {
  const AddItemsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Row(
          children: <Widget>[
            Icon(Icons.shopping_bag_outlined, color: Colors.black54),
            SizedBox(width: 8.0),
            Text(
              'Add Items',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.pink.shade100,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.pink),
            iconSize: 20,
            onPressed: () {
            },
          ),
        ),
      ],
    );
  }
}

class ProductItemInput extends StatelessWidget {
  const ProductItemInput({super.key});

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: Colors.grey),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Expanded(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Product name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    isDense: true,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Put the product link here',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.remove, color: Colors.red),
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}