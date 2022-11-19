import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../models/BookModel.dart';
import '../providers/DBProvider.dart';

class BooksListPage extends StatefulWidget {
  const BooksListPage({super.key});
  @override
  State<BooksListPage> createState() => _BooksListPageState();
}

class _BooksListPageState extends State<BooksListPage> {
  void _navigateToCreatePage() {
    Navigator.pushNamed(context, '/add_book');
  }

  void _navigateToBookPage(mongo.ObjectId id) {
    Navigator.pushNamed(context, '/book', arguments: id);
  }

  Widget createList(List<Book> books) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () => _navigateToBookPage(books[index].id!),
        child: Container(
          height: 50,
          color: Colors.blue,
          child: Center(
              child: Text(
            books[index].title,
            style: const TextStyle(color: Colors.white),
          )),
        ),
      ),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      body: FutureBuilder(
          future: DBProvider.getAllBooks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('loading...');
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return createList(snapshot.data!);
              }
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        tooltip: 'Add book',
        child: const Icon(Icons.add),
      ),
    );
  }
}
