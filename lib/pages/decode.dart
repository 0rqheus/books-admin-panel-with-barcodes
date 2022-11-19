import 'package:ean13/utils/ean13.dart';
import 'package:flutter/material.dart';

class DecodePage extends StatefulWidget {
  const DecodePage({super.key});

  @override
  State<DecodePage> createState() => _DecodePageState();
}

class _DecodePageState extends State<DecodePage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  String _inputValue = '';

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void updateCode(String value) {
    _inputValue = value;

    var result = '';
    try {
      result = EAN13.decode(value);
    } catch (e) {
      result = e.toString();
    }

    setState(() {
      _outputController.text = result;
    });
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
            children: [
              TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'encoded',
                  ),
                  onChanged: updateCode),
              const SizedBox(height: 12),
              TextField(
                controller: _outputController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'decoded',
                ),
                readOnly: true,
              )
            ],
          ),
        ));
  }
}
