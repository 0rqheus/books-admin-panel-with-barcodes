import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  void _navigateToBooks() {
    Navigator.pushNamed(context, '/books');
  }

  void _navigateToDecode() {
    Navigator.pushNamed(context, '/decode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Menu"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                Expanded(
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(300, 50)),
                      onPressed: _navigateToBooks,
                      child: const Text("Books")),
                ),
              ]),
              const SizedBox(
                height: 12,
              ),
              Row(children: [
                Expanded(
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(300, 50)),
                      onPressed: _navigateToDecode,
                      child: const Text("Decode")),
                ),
              ]),
            ],
          ),
        ));
  }
}
