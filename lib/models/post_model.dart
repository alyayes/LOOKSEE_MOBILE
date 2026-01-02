class PostModel {
  final int id;
  final String title;
  final String user;
  final String mood;
  final String imagePath;

  PostModel({required this.id, required this.title, required this.user, required this.mood, required this.imagePath});

  // Fungsi untuk mengubah JSON dari Laravel menjadi Object Dart
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id_post'],
      title: json['caption'] ?? '',
      user: json['user']['name'] ?? 'Unknown', // Sesuai relasi user di Laravel
      mood: json['mood'] ?? 'Neutral',
      imagePath: json['image_post'] ?? '',
    );
  }
}