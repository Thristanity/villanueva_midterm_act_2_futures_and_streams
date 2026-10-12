class Book {
  final int id;
  final String title;
  final String author;
  final String? coverUrl;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final authorsList = json['authors'] as List<dynamic>?;
    final authorName = (authorsList != null && authorsList.isNotEmpty)
        ? (authorsList[0]['name'] as String? ?? 'Unknown Author')
        : 'Unknown Author';

    final formats = json['formats'] as Map<String, dynamic>?;
    final cover = formats?['image/jpeg'] as String?;

    return Book(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled',
      author: authorName,
      coverUrl: cover,
    );
  }
}