class StyleJournal {
  final int id;
  final String title;
  final String content;
  final String formattedDate;
  final String? image;

  StyleJournal({
    required this.id,
    required this.title,
    required this.content,
    required this.formattedDate,
    this.image,
  });

  factory StyleJournal.fromJson(Map<String, dynamic> json) {
    return StyleJournal(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      formattedDate: json['formatted_date'],
      image: json['image'], 
    );
  }
}
