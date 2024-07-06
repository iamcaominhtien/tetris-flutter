import 'package:flutter/material.dart';

import '../components/my_pixel.dart';

class Constant {
  static int numberOfGridRowOfGridTable = 25; //15 20
  static int numberOfGridColOfGridTable = 15; //10
  static int numberOfGridColOfShowNextBlock = 4;
  static int numberOfGridRowOfShowNextBlock = 3;

  static List<List<int>> pieces = [
    // [4, 5,Constant.numberOfGridCol+5, Constant.numberOfGridCol+6],
    // [4, 5, 4+Constant.numberOfGridCol, 5+Constant.numberOfGridCol],
    // [4, 4+Constant.numberOfGridCol, 4+2*Constant.numberOfGridCol, 5+2*Constant.numberOfGridCol],
    // [4, 4+Constant.numberOfGridCol, 4+2*Constant.numberOfGridCol, 4+3*Constant.numberOfGridCol],
    // [5, 5+Constant.numberOfGridCol, 4+2*Constant.numberOfGridCol, 5+2*Constant.numberOfGridCol],
    // [4,4+Constant.numberOfGridColOfGridTable,5+Constant.numberOfGridColOfGridTable,5+2*Constant.numberOfGridColOfGridTable]
    // [5, 4+Constant.numberOfGridColOfGridTable, 5+Constant.numberOfGridColOfGridTable, 4+2*Constant.numberOfGridColOfGridTable],
    // [4, 5, 6, 5+Constant.numberOfGridColOfGridTable],

    [
      4 - Constant.numberOfGridColOfGridTable,
      5 - Constant.numberOfGridColOfGridTable,
      5,
      6
    ], //4, 5, 15, 16
    [
      4 - Constant.numberOfGridColOfGridTable,
      5 - Constant.numberOfGridColOfGridTable,
      4,
      5
    ], //4 5 14 15
    [
      4 - 2 * Constant.numberOfGridColOfGridTable,
      4 - Constant.numberOfGridColOfGridTable,
      4,
      5
    ], //4 14 24 25
    [
      4 - 3 * Constant.numberOfGridColOfGridTable,
      4 - 2 * Constant.numberOfGridColOfGridTable,
      4 - Constant.numberOfGridColOfGridTable,
      4
    ], //4, 14, 24, 34
    [
      5 - 2 * Constant.numberOfGridColOfGridTable,
      5 - Constant.numberOfGridColOfGridTable,
      4,
      5
    ], //5, 15, 24, 25
    [
      4 - 2 * Constant.numberOfGridColOfGridTable,
      4 - Constant.numberOfGridColOfGridTable,
      5 - Constant.numberOfGridColOfGridTable,
      5
    ], //4, 14, 15, 25
    [
      5 - 2 * Constant.numberOfGridColOfGridTable,
      4 - Constant.numberOfGridColOfGridTable,
      5 - Constant.numberOfGridColOfGridTable,
      4
    ], //[5,14,15,24]
    [
      4 - Constant.numberOfGridColOfGridTable,
      5 - Constant.numberOfGridColOfGridTable,
      6 - Constant.numberOfGridColOfGridTable,
      5
    ], //[4,5,6,15]
  ];

  static const List<List<int>> showNextBlock = [
    [1, 2, 6, 7], //4, 5, 15, 16
    [1, 2, 5, 6], //4 5 14 15
    [1, 5, 9, 10], //4 14 24 25
    [1, 5, 9], //4, 14, 24, 34
    [2, 6, 9, 10], //5, 15, 24, 25
    [1, 5, 6, 10], //4, 14, 15, 25
    [2, 6, 5, 9], // [5, 15, 14, 24],
    [0, 1, 2, 5], // [4, 5, 6, 15],
  ];

  static const List pieceColor = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.pink,
    Colors.brown,
    Colors.deepPurple,
  ];

  static List<MyPixel> get originalGridTable => List<MyPixel>.generate(
    Constant.numberOfGridRowOfGridTable * Constant.numberOfGridColOfGridTable,
    (index) {
      return MyPixel(index: index);
    },
  );

  // static const durationLv2 = Duration(milliseconds: 300);

  // static const durationLv1 = Duration(milliseconds: 800);

  // static const durationLv3 = Duration(milliseconds: 30);

  static const listOfLevel = [
    Duration(milliseconds: 800),
    Duration(milliseconds: 300),
    Duration(milliseconds: 30),
  ];
  static const primaryColor = Colors.black;

  // ignore: constant_identifier_names
  static const SOUNDS = [
    'clean.mp3',
    'drop.mp3',
    'explosion.mp3',
    'move.mp3',
    'rotate.mp3',
    'start.mp3'
  ];

  static const TextStyle tetrisBoardTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0);
}
