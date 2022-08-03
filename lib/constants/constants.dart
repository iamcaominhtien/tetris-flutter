import 'package:flutter/material.dart';
import '../widgets/grid_table.dart';

class Constant {
  static const int numberOfGridRow = 15;
  static const int numberOfGridCol = 10;

  static const List<List<int>> pieces = [
    // [4, 5,15, 16],
    // [4, 5, 14, 15],
    // [4, 14, 24, 25],
    // // [4, 14, 24, 34],
    // // [5, 15, 24, 25],
    // // [4, 14, 15, 25],
    // // [5, 15, 14, 24],
    // // [4, 5, 6, 15],

    [-6, -5, 5, 6], //4, 5, 15, 16
    // [-6, -5, 4, 5], //4 5 14 15
    // [-6, 4, 14, 15], //4 14 25 25
    // [-26, -16, -6, 4], //4, 14, 24, 34
    // [-5, 5, 14, 15], //5, 15, 24, 25
    // [-6, 4, 5, 15], //4, 14, 15, 25
    // [-5, 5, 4, 14],
    // [-6, -5, -4, 5],
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

  static final List<MyPixel> originalGridTable = List<MyPixel>.generate(
    Constant.numberOfGridRow * Constant.numberOfGridCol,
    (index) {
      return MyPixel(index: index);
    },
  );

  static const duration = Duration(milliseconds: 300);
}
