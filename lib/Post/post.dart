import 'package:flutter/material.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../todaysOutfit/todays_outfit.dart' hide ApiService;
import 'gallery.dart';

class PostMyStyleScreen extends StatefulWidget {
  final String? imagePath; 
  const PostMyStyleScreen({super.key, this.imagePath});

  @override
  State<PostMyStyleScreen> createState() => _PostMyStyleScreenState();
}

class _PostMyStyleScreenState extends State<PostMyStyleScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _hashtagController = TextEditingController();
  
  String? _selectedMood = 'Happy'; 
  bool _isUploading = false;

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

  void _handlePost() async {
    if (widget.imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first")),
      );
      return;
    }

    setState(() => _isUploading = true);

    bool success = await _apiService.createPost(
      _captionController.text,
      widget.imagePath!,
      _selectedMood!,
      _hashtagController.text,
    );

    setState(() => _isUploading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TodaysOutfitScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to post style")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Post My Style',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isUploading 
        ? const Center(child: CircularProgressIndicator(color: Colors.pink))
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: widget.imagePath != null
                        ? Image.file(
                            File(widget.imagePath!),
                            height: 250,
                            width: 200,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 250,
                            width: 200,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image, size: 50),
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                    hintText: 'Add a caption...',
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _hashtagController,
                  decoration: const InputDecoration(
                    hintText: 'Add hashtags...',
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 24.0),
                const Row(
                  children: [
                    Icon(Icons.sentiment_satisfied_alt, color: Colors.black54),
                    SizedBox(width: 8.0),
                    Text('Add Mood', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12.0),
                MoodChipsRow(
                  moods: moods,
                  selectedMood: _selectedMood,
                  onMoodSelected: _selectMood,
                ),
                const SizedBox(height: 40.0),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handlePost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text(
                      'Post',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
      children: moods.map((moodLabel) {
        final bool isSelected = moodLabel == selectedMood;
        return ChoiceChip(
          label: Text(moodLabel),
          selected: isSelected,
          onSelected: (_) => onMoodSelected(moodLabel),
          selectedColor: Colors.pink.shade400,
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        );
      }).toList(),
    );
  }
}