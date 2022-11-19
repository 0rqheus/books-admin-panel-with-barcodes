import 'package:flutter/material.dart';

class Barcode extends CustomPainter {
  final String code;
  final String encoded;

  const Barcode({required this.code, required this.encoded}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    const standartHeight = 130.0;
    const delimiterHeight = 150.0;
    const xOffset = 20;
    const scale = 3.0;

    // barcode
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale + 0.5
      ..color = Colors.black;

    var height = standartHeight;
    for (var i = 0; i < encoded.length; i++) {
      if (encoded[i] != '0') {
        height = ((i >= 0 && i <= 2) ||
                (i >= 45 && i <= 49) ||
                (i >= encoded.length - 4 && i <= encoded.length - 1))
            ? delimiterHeight
            : standartHeight;
        canvas.drawLine(Offset(xOffset + i * scale, 0),
            Offset(xOffset + i * scale, height), paint);
      }
    }

    // number code
    final looseCode = code.split('').join(' ');
    final separatedCode =
        '${looseCode[0]}     ${looseCode.substring(2, 14)}     ${looseCode.substring(14)}';
    final textPainter = TextPainter(
      text: TextSpan(
        text: separatedCode,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, const Offset(0, standartHeight));
  }

  @override
  bool shouldRepaint(Barcode oldDelegate) => false;
}
