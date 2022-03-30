class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class NullBook extends Book {
  NullBook() : super('', '');
}
