import 'package:flutter/material.dart';

import '../models/BookModel.dart';
import '../providers/DBProvider.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};

  void _addBook() {
    DBProvider.insert(Book.fromMap(formData)).then((result) {
      Navigator.pushNamed(context, '/books');
    });
  }

  Widget requiredTextField(
      {required String label,
      required Function(String) onChangeCb,
      String? Function(String)? validateCb,
      int minLines = 1,
      int maxLines = 1}) {
    return TextFormField(
      autofocus: true,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        filled: true,
        labelText: label,
      ),
      minLines: minLines,
      maxLines: maxLines,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }

        if (validateCb != null) {
          var res = validateCb(value);
          if (res != null) {
            return res;
          }
        }

        return null;
      },
      onChanged: onChangeCb,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add book'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...[
                requiredTextField(
                    label: 'Title',
                    onChangeCb: (value) => {formData['title'] = value}),
                requiredTextField(
                    label: 'Author',
                    onChangeCb: (value) => {formData['author'] = value}),
                requiredTextField(
                    label: 'Short description',
                    onChangeCb: (value) =>
                        {formData['short_description'] = value},
                    minLines: 3,
                    maxLines: 5),
                requiredTextField(
                    label: 'Publisher',
                    onChangeCb: (value) => {formData['publisher'] = value}),
                requiredTextField(
                    label: 'Product Code',
                    onChangeCb: (value) => {formData['product_code'] = value},
                    validateCb: (value) =>
                        ((value.length != 13 || int.tryParse(value) == null)
                            ? 'Product Code must consist of 13 digits'
                            : null)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 50)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addBook();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ].expand(
                (widget) => [
                  widget,
                  const SizedBox(
                    height: 12,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
