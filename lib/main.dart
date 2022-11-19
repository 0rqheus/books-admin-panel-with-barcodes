import 'package:ean13/pages/decode.dart';
import 'package:ean13/pages/menu.dart';
import 'package:ean13/providers/DBProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/addBook.dart';
import 'pages/book.dart';
import 'pages/booksList.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await await DBProvider.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EAN-13',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuPage(),
        '/decode': (context) => const DecodePage(),
        '/books': (context) => const BooksListPage(),
        '/add_book': (context) => const AddBookPage(),
        '/book': (context) => const BookPage(),
      },
    );
  }
}
