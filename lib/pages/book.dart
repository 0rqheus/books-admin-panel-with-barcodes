import 'package:ean13/providers/DBProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:image/image.dart' as img_lib;
import 'dart:ui' as ui;
// import 'package:barcode_widget/barcode_widget.dart';
// import 'package:barcode_image/barcode_image.dart';

import 'dart:io';

import '../models/BookModel.dart';
import '../utils/ean13.dart';
import 'partials/barcode.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isReadOnly = true;
  late Book book;

  void deleteBook(mongo.ObjectId bookId) async {
    await DBProvider.delete(bookId);
    Navigator.pushNamed(context, '/books');
  }

  void copyToClipboard(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
  }

  void copyEncodedToClipboard(String code) async {
    final encoded = EAN13.encode(code);
    await Clipboard.setData(ClipboardData(text: encoded));
  }

  void saveImage(String code, String encoded) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: '$code.png',
    );

    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    var painter = Barcode(
        code: book.product_code,
        encoded: EAN13.encode(book.product_code).replaceAll(' ', ''));
    var size = const Size(320, 160);
    painter.paint(canvas, size);
    ui.Image renderedImage = await recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());

    var pngBytes =
        await renderedImage.toByteData(format: ui.ImageByteFormat.png);

    if (outputFile != null) {
      File(outputFile)
          .writeAsBytesSync(pngBytes!.buffer.asUint8List(), flush: true);
    }
  }

  Widget form(Book book) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                initialValue: book.title,
                readOnly: isReadOnly,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Author',
                ),
                initialValue: book.author,
                readOnly: isReadOnly,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Short description',
                ),
                minLines: 3,
                maxLines: 5,
                initialValue: book.short_description,
                readOnly: isReadOnly,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Publisher',
                ),
                initialValue: book.publisher,
                readOnly: isReadOnly,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product Code',
                ),
                initialValue: book.product_code,
                readOnly: isReadOnly,
              ),
              LayoutBuilder(
                  // Inner yellow container
                  builder: (_, constraints) => Container(
                        width: 320,
                        height: 160,
                        color: Colors.white,
                        child: CustomPaint(
                            painter: Barcode(
                                code: book.product_code,
                                encoded: EAN13
                                    .encode(book.product_code)
                                    .replaceAll(' ', ''))),
                      )),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookId = ModalRoute.of(context)!.settings.arguments as mongo.ObjectId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Book #${bookId.toString()}'),
      ),
      body: FutureBuilder(
          future: DBProvider.getBookById(bookId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('loading...');
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                book = snapshot.data!;
                return form(snapshot.data!);
              }
            }
          }),
      floatingActionButton: SpeedDial(
        icon: Icons.more_vert,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.delete_forever),
            onTap: () {
              deleteBook(bookId);
            },
            label: 'Delete',
          ),
          SpeedDialChild(
            child: const Icon(Icons.copy_rounded),
            onTap: () {
              copyToClipboard(book.product_code);
            },
            label: 'Copy code',
          ),
          SpeedDialChild(
            child: const Icon(Icons.copy_all),
            onTap: () {
              copyToClipboard(EAN13.encode(book.product_code));
            },
            label: 'Copy encoded code',
          ),
          SpeedDialChild(
            child: const Icon(Icons.download),
            onTap: () {
              saveImage(book.product_code,
                  EAN13.encode(book.product_code).replaceAll(' ', ''));
            },
            label: 'Download picture',
          ),
        ],
      ),
    );
  }
}
