import 'package:flutter/material.dart';
import '../components/my_pixel.dart';

class Constant {
  static const int numberOfGridRow = 21; //15
  static const int numberOfGridCol = 15; //10

  static const List<List<int>> pieces = [
    // [4, 5,Constant.numberOfGridCol+5, Constant.numberOfGridCol+6],
    // [4, 5, 4+Constant.numberOfGridCol, 5+Constant.numberOfGridCol],
    // [4, 4+Constant.numberOfGridCol, 4+2*Constant.numberOfGridCol, 5+2*Constant.numberOfGridCol],
    // [4, 4+Constant.numberOfGridCol, 4+2*Constant.numberOfGridCol, 4+3*Constant.numberOfGridCol],
    // [5, 5+Constant.numberOfGridCol, 4+2*Constant.numberOfGridCol, 5+2*Constant.numberOfGridCol],
    // // [4, 14, 15, 25],
    // [5, 15, 14, 24],
    // [4, 5, 6, 15],

    [
      4 - Constant.numberOfGridCol,
      5 - Constant.numberOfGridCol,
      5,
      6
    ], //4, 5, 15, 16
    [
      4 - Constant.numberOfGridCol,
      5 - Constant.numberOfGridCol,
      4,
      5
    ], //4 5 14 15
    [
      4 - 2 * Constant.numberOfGridCol,
      4 - Constant.numberOfGridCol,
      4,
      5
    ], //4 14 24 25
    [
      4 - 3 * Constant.numberOfGridCol,
      4 - 2 * Constant.numberOfGridCol,
      4 - Constant.numberOfGridCol,
      4
    ], //4, 14, 24, 34
    [
      5 - 2 * Constant.numberOfGridCol,
      5 - Constant.numberOfGridCol,
      4,
      5
    ], //5, 15, 24, 25
    // [-6, 4, 5, 15], //4, 14, 15, 25
    // [-5, 5, 4, 14],
    // [-6, -5, -4, 5],
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

  static final List<MyPixel> originalGridTable = List<MyPixel>.generate(
    Constant.numberOfGridRow * Constant.numberOfGridCol,
    (index) {
      return MyPixel(index: index);
    },
  );

  static const duration = Duration(milliseconds: 300);

  static const primaryColor = Colors.black;

  static const TextStyle tetrisBoardTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0);
}
