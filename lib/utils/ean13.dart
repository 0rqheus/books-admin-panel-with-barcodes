import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img_lib;

const leftGroupVariants = [
  'LLLLLL',
  'LLGLGG',
  'LLGGLG',
  'LLGGGL',
  'LGLLGG',
  'LGGLLG',
  'LGGGLL',
  'LGLGLG',
  'LGLGGL',
  'LGGLGL'
];
const lEncoding = [
  '0001101',
  '0001101',
  '0010011',
  '0111101',
  '0100011',
  '0110001',
  '0101111',
  '0111011',
  '0110111',
  '0001011'
];
const gEncoding = [
  '0100111',
  '0110011',
  '0011011',
  '0100001',
  '0011101',
  '0111001',
  '0000101',
  '0010001',
  '0001001',
  '0010111'
];
const rEncoding = [
  '1110010',
  '1100110',
  '1101100',
  '1000010',
  '1011100',
  '1001110',
  '1010000',
  '1000100',
  '1001000',
  '1110100'
];

const groupsDict = {'L': lEncoding, 'G': gEncoding, 'R': rEncoding};

class EAN13 {
  static String encode(String code) {
    if (code.length != 13) {
      throw const FormatException("code should be 13 digits long");
    }

    if (int.tryParse(code) == null) {
      throw const FormatException("code should consist of digits only");
    }

    if (int.parse(code[12]) != calculateChecksumDigit(code)) {
      throw 'wrong checksum digit';
    }

    final List<String> encodedData = [];

    encodedData.add('101');
    final group = leftGroupVariants[int.parse(code[0])];
    // print('left group: ' + group);
    for (var i = 0; i < 6; i++) {
      var type = group[i]; // G or L
      var encoding = groupsDict[type]!; // [0111001, 0101010, ...]
      encodedData.add(encoding[int.parse(code[i + 1])]);
    }
    encodedData.add('01010');
    for (var i = 6; i < 12; i++) {
      var encoding = groupsDict['R']!; // [0111001, 0101010, ...]
      encodedData.add(encoding[int.parse(code[i + 1])]);
    }
    encodedData.add('101');
    // print('encoded data: ' + encodedData.join(' '));
    return encodedData.join(' ');
  }

  static String decode(String code) {
    final parts = code.split(' ');
    final List<String> decodedData = [];

    if (parts.length != 15) {
      throw const FormatException("code should consist of 15 parts");
    }
    parts.removeAt(7);                // remove middle delimiter
    parts.removeAt(0);                // remove start delimiter
    parts.removeAt(parts.length - 1); // remove end delimiter

    var leftGroup = '';
    for (var i = 0; i < 6; i++) {
      var counter = 0;
      parts[i].split('').forEach((el) => counter += int.parse(el));

      if (counter % 2 != 0) {
        leftGroup += 'L';
      } else {
        leftGroup += 'G';
      }
    }

    var firstDigit = leftGroupVariants.indexOf(leftGroup);
    decodedData.add(firstDigit.toString());

    final group = "${leftGroup}RRRRRR";
    for (var i = 0; i < group.length; i++) {
      var type = group[i]; // G or L or R
      var encoding = groupsDict[type]!; // [0111001, 0101010, ...]
      decodedData.add(encoding.indexOf(parts[i]).toString());
    }

    final result = decodedData.join('');

    return result;
  }

  static int calculateChecksumDigit(String code) {
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      if (i % 2 == 0) {
        sum += int.parse(code[i]);
      } else {
        sum += int.parse(code[i]) * 3;
      }
    }

    var divisor = 10;
    var checksumDigit = ((sum / divisor).ceil() * divisor) - sum;
    return checksumDigit;
  }

  static img_lib.Image createImage(String code, String encoded) {
    final image = img_lib.Image(320, 160);
    img_lib.fill(image, img_lib.getColor(255, 255, 255));
    const standartHeight = 130;
    const delimiterHeight = 150;
    const xOffset = 20;
    const scale = 3;

    var height = standartHeight;
    for (var i = 0; i < encoded.length; i++) {
      if (encoded[i] != '0') {
        height = ((i >= 0 && i <= 2) ||
                (i >= 45 && i <= 49) ||
                (i >= encoded.length - 4 && i <= encoded.length - 1))
            ? delimiterHeight
            : standartHeight;
        img_lib.drawLine(image, xOffset + i * scale, 0, xOffset + i * scale,
            height, img_lib.getColor(0, 0, 0),
            thickness: scale);
      }
    }

    final looseCode = code.split('').join(' ');
    final separatedCode =
        '${looseCode[0]}   ${looseCode.substring(2, 14)}   ${looseCode.substring(14)}';

    img_lib.drawString(
      image,
      img_lib.arial_24,
      0,
      135,
      separatedCode,
      color: img_lib.getColor(0, 0, 0),
    );

    return image;
  }
}
