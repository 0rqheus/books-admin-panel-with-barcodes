import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/BookModel.dart';

class DBProvider {
  static late Db _db;
  static late DbCollection _books;

  static Future init() async {
    try {
      _db = await Db.create(
          dotenv.env['MONGODB_URI']!);
      await _db.open();
      _books = _db.collection('books');
    } catch (e) {
      print(e);
    }
  }

  static Future insert(Book book) async {
    await _books.insertOne(book.toMap());
  }

  static Future<List<Book>> getAllBooks() async {
    final List<Map<String, dynamic>> results = await _books.find().toList();
    List<Book> books = results.map((res) => Book.fromMap(res)).toList();
    return books;
  }

  static Future<Book?> getBookById(ObjectId id) async {
    var targetBook = await _books.findOne(where.id(id));
    if (targetBook != null) {
      return Book.fromMap(targetBook);
    }
    return null;
  }

  static Future delete(ObjectId id) async {
    await _books.remove(where.id(id));
  }

  static Future update(Book book) async {
    var targetBook = (await _books.findOne(where.id(book.id!)))!;
    targetBook["title"] = book.title;
    targetBook["author"] = book.author;
    targetBook["short_description"] = book.short_description;
    targetBook["publisher"] = book.publisher;
    targetBook["product_code"] = book.product_code;
    await _books.replaceOne(where.id(book.id!), targetBook);
  }

  static Future close() async {
    _db.close();
  }
}
