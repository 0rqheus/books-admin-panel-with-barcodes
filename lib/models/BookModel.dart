// ignore_for_file: non_constant_identifier_names
import 'package:mongo_dart/mongo_dart.dart';

class Book {
  ObjectId? id;
  final String title;
  final String author;
  final String short_description;
  final String publisher;
  final String product_code;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.short_description,
    required this.publisher,
    required this.product_code,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['_id'],
      title: map['title'],
      author: map['author'],
      short_description: map['short_description'],
      publisher: map['publisher'],
      product_code: map['product_code'],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'author': author,
        'short_description': short_description,
        'publisher': publisher,
        'product_code': product_code,
      };

  @override
  String toString() {
    return 'Book{id: $id, title: $title,author: $author, short_description: $short_description, publisher: $publisher, product_code: $product_code}';
  }
}
