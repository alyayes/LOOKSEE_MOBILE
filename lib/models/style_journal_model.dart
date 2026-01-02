class StyleJournal {
  final int id;
  final String title;
  final String descr;
  final String content;
  final String formattedDate;
  final String? imageUrl;

  StyleJournal({
    required this.id,
    required this.title,
    required this.descr,
    required this.content,
    required this.formattedDate,
    required this.imageUrl,
  });

  factory StyleJournal.fromJson(Map<String, dynamic> json) {
    return StyleJournal(
      id: json['id'],
      title: json['title'],
      descr: json['descr'],
      content: json['content'],
      formattedDate: json['formatted_date'],
      imageUrl: json['image_url'],
    );
  }
}
