import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../widgets/grid_table.dart';

class MyTetrisProvider extends ChangeNotifier {
  List<MyPixel> listOfSquare = List<MyPixel>.from(Constant.originalGridTable);
  List<Map<String, dynamic>> listOfLandedBlock = [];
  Map<String, dynamic> currentBlock = {};
  int point = 0;

  void clear() {
    listOfLandedBlock.clear();
    currentBlock.clear();
  }

  void resetGridTableToOriginal() {
    listOfSquare.clear();
    listOfSquare = List<MyPixel>.from(Constant.originalGridTable);
    notifyListeners();
  }

  void resetGridTable() {
    resetGridTableToOriginal();
    for (var landedBlock in listOfLandedBlock) {
      var block = landedBlock['block'];
      var color = landedBlock['color'];

      for (int i in block) {
        if (i >= 0) {
          listOfSquare[i] = MyPixel(index: i, color: color);
        } else {
          //End game
          resetGridTableToOriginal();
          clear();
          return;
        }
      }
    }
    // notifyListeners();
  }

  bool createABlock() {
    if (currentBlock.isNotEmpty) {
      currentBlock.clear();
    }
    int indexPiece = Random().nextInt(Constant.pieces.length);
    var block = Constant.pieces[indexPiece];
    var color =
        Constant.pieceColor[Random().nextInt(Constant.pieceColor.length)];
    currentBlock['block'] = block;
    currentBlock['color'] = color;
    currentBlock['type'] = indexPiece;
    currentBlock['rotate'] = 0;
    resetGridTable();

    for (int i in block) {
      if (i >= 0 && listOfSquare[i].color != Colors.black) {
        resetGridTableToOriginal();
        return false;
      }
    }

    for (int i in block) {
      if (i >= 0) {
        listOfSquare[i] = MyPixel(
          index: i,
          color: color,
        );
      }
    }

    notifyListeners();
    return true;
  }

  bool updateBlock({String direction = 'b'}) {
    //b: bottom, l: left, r: right
    resetGridTable();
    late List<int> newBlock;
    if (direction == 'b') {
      newBlock = moveBlockToBottom();
    } else if (direction == 'l') {
      newBlock = moveBlockToLeft();
    } else {
      newBlock = moveBlockToRight();
    }

    for (int i = 0; i < newBlock.length; i++) {
      if (newBlock[i] >= 0) {
        listOfSquare[newBlock[i]] =
            MyPixel(index: newBlock[i], color: currentBlock['color']);
      }
    }

    var re = currentBlock['block'][0] == newBlock[0] && direction == 'b';
    currentBlock['block'] = List<int>.from(newBlock);
    notifyListeners();

    if (re == true) {
      listOfLandedBlock.add({
        'block': newBlock,
        'color': currentBlock['color'],
      });
    }
    return re;
  }

  List<int> moveBlockToBottom() {
    var newBlock = List<int>.from(currentBlock['block']);
    for (int i = 0; i < newBlock.length; i++) {
      if (newBlock[i] + Constant.numberOfGridCol >=
          Constant.numberOfGridRow * Constant.numberOfGridCol) {
        return newBlock;
      } else {
        if (newBlock[i] + Constant.numberOfGridCol >= 0 &&
            listOfSquare[newBlock[i] + Constant.numberOfGridCol].color !=
                Colors.black) {
          return newBlock;
        }
      }
    }
    for (int i = 0; i < newBlock.length; i++) {
      newBlock[i] += Constant.numberOfGridCol;
    }
    return newBlock;
  }

  List<int> moveBlockToLeft() {
    var newBlock = List<int>.from(currentBlock['block']);
    for (int i = 0; i < newBlock.length; i++) {
      if (newBlock[i] % 10 == 0) {
        return newBlock;
      } else {
        if (newBlock[i] - 1 >= 0 &&
            listOfSquare[newBlock[i] - 1].color != Colors.black) {
          return newBlock;
        }
      }
    }
    for (int i = 0; i < newBlock.length; i++) {
      newBlock[i] -= 1;
    }
    return newBlock;
  }

  List<int> moveBlockToRight() {
    var newBlock = List<int>.from(currentBlock['block']);
    for (int i = 0; i < newBlock.length; i++) {
      if ((newBlock[i] + 1) % 10 == 0) {
        return newBlock;
      } else {
        if (newBlock[i] + 1 >= 0 &&
            listOfSquare[newBlock[i] + 1].color != Colors.black) {
          return newBlock;
        }
      }
    }
    for (int i = 0; i < newBlock.length; i++) {
      newBlock[i] += 1;
    }
    return newBlock;
  }

  void rotateBlock() {
    int type = currentBlock['type'];
    List<int> block = List.from(currentBlock['block']);
    int rotate = currentBlock['rotate'];

    if (type == 0) {
      // 0 -> x x
      //        x x

      List<List<int>> listRotate = [
        [2, 10, 1, 9],
        [8, 0, 9, 1],
        [-9, -1, -10, -2],
        [-1, -9, 0, -8],
      ];
      for (int i = 0; i < block.length; i++) {
        block[i] += listRotate[rotate][i];
      }
      rotate = (rotate + 1) % 4;

      //check valid block
      //vertical block
      if (rotate % 2 != 0) {
        for (int i = 0; i < block.length; i++) {
          if (block[i] < 0 ||
              block[i] >= Constant.numberOfGridRow * Constant.numberOfGridCol)
            return;
        }

        var listCheck = [];
        for (var item in block) {
          var temp = item % Constant.numberOfGridCol;
          if (listCheck.contains(temp) == false) {
            listCheck.add(temp);
          }
        }

        if (listCheck.length == block.length - 2) {
          if ((listCheck[1] - listCheck[0]).abs() != 1) {
            return;
          }
        } else {
          return;
        }
      } else {
        //horizontal block
        for (int i = 0; i < block.length; i++) {
          if (block[i] < 0 || block[i] >= Constant.numberOfGridRow * 10) return;
        }

        var listCheck = [];
        for (var item in block) {
          var temp = item % 10;
          if (listCheck.contains(temp) == false) {
            listCheck.add(temp);
          }
        }

        if (listCheck.length == block.length - 1) {
          for (int i = 1; i < listCheck.length; i++) {
            if ((listCheck[i] - listCheck[i - 1]) != 1) return;
          }
        } else {
          return;
        }
      }
    } else if (type == 1) {
      // 1: x x
      //    x x
    } else if (type == 2) {
      // 2: x
      //    x
      //    x x
      List<List<int>> listRotate = [
        [9, 0, -9, -2],
        [-10, -10, -1, 1],
        [10, 10, 1, -19],
        [-9, 0, 9, 20],
      ];

      for (int i = 0; i < block.length; i++) {
        block[i] += listRotate[rotate][i];
      }
      rotate = (rotate + 1) % 4;

      for (int i = 0; i < block.length; i++) {
        if (block[i] < 0 || block[i] >= Constant.numberOfGridRow * 10) return;
      }

      var listCheck = [];
      for (var item in block) {
        var temp = item % 10;
        if (listCheck.contains(temp) == false) {
          listCheck.add(temp);
        }
      }

      for (int i = 1; i < listCheck.length; i++) {
        if ((listCheck[i] - listCheck[i - 1]).abs() != 1) {
          return;
        }
      }
    } else if (type == 3) {
      // 3 -> x
      //      x
      //      x
      //      x

      if (rotate == 0) {
        block[0] += 9;
        for (int i = 1; i < block.length; i++) {
          block[i] = block[i - 1] + 1;
        }
        rotate = 1;
      } else if (rotate == 1) {
        block[0] -= 8;
        for (int i = 1; i < block.length; i++) {
          block[i] = block[i - 1] + 10;
        }
        rotate = 2;
      } else if (rotate == 2) {
        block[0] += 18;
        for (int i = 1; i < block.length; i++) {
          block[i] = block[i - 1] + 1;
        }
        rotate = 3;
      } else {
        block[0] -= 19;
        for (int i = 1; i < block.length; i++) {
          block[i] = block[i - 1] + 10;
        }
        rotate = 0;
      }

      //check valid block
      //vertical
      if (block[1] - block[0] == 10) {
        if (block[0] < 0 ||
            block[block.length - 1] >= Constant.numberOfGridRow * 10) return;
      } else {
        //horizontal
        int currentRow = block[0] ~/ 10;
        for (int i = 1; i < block.length; i++) {
          if (currentRow != (block[i] ~/ 10)) {
            return;
          }
        }
      }
    }

    //Update block
    currentBlock['block'] = block;
    currentBlock['rotate'] = rotate;

    resetGridTable();
    for (int i = 0; i < block.length; i++) {
      if (block[i] >= 0) {
        listOfSquare[block[i]] =
            MyPixel(index: block[i], color: currentBlock['color']);
      }
    }
    notifyListeners();
  }
}
