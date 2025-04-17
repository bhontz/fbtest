class Book {
  final String bookId;
  final String title;
  final String author;
  final String? thumbnailUrl;

  Book({
    required this.bookId,
    required this.title,
    required this.author,
    this.thumbnailUrl,
  });
}
