import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:tetris/components/my_pixel.dart';
import '../constants/constants.dart';
import '../widgets/play_sound.dart';

class MyTetrisProvider extends ChangeNotifier {
  List<MyPixel> listOfSquare = List<MyPixel>.from(Constant.originalGridTable);
  List<Map<String, dynamic>> listOfLandedBlock = [];
  Map<String, dynamic> currentBlock = {};
  Map<String, dynamic> nextBlock = {};
  int point = 0;
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
  final PlaySound sound = PlaySound();
  var level = Constant.listOfLevel[0];
  dynamic restartGame;
  dynamic pauseGame;

  @override
  void dispose() async {
    super.dispose();
    await stopWatchTimer.dispose();
    sound.dispose();
  }

  void updateTime({String status = 'c'}) {
    //r: reset - p: pause - s: end - c: continue - s: start
    if (status == 'c') {
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
    } else if (status == 'e') {
      stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    } else if (status == 'p') {
      stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    } else if (status == 'r') {
      stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    } else if (status == 's') {
      stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
    }
    // notifyListeners();
  }

  void clear() {
    listOfLandedBlock.clear();
    currentBlock.clear();
    nextBlock.clear();
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
          listOfSquare[i] = MyPixel(
            index: i,
            color: color,
          );
        } else {
          //End game
          // resetGridTableToOriginal();
          // clear();
          // debugPrint("Herrehhhhhh");
          // return;
        }
      }
    }
    // notifyListeners();
  }

  void createANextBlock() {
    nextBlock.clear();
    int indexPiece = Random().nextInt(Constant.pieces.length);
    var block = Constant.pieces[indexPiece];
    var color =
        Constant.pieceColor[Random().nextInt(Constant.pieceColor.length)];
    nextBlock['block'] = block;
    nextBlock['color'] = color;
    nextBlock['type'] = indexPiece;
    nextBlock['rotate'] = 0;
    // debugPrint("createANextBlock");
  }

  bool createABlock() {
    // if (currentBlock.isNotEmpty) {
    //   currentBlock.clear();
    // }
    currentBlock.clear();
    if (nextBlock.isEmpty) {
      createANextBlock();
    }
    currentBlock = Map.from(nextBlock);
    createANextBlock();
    var block = currentBlock['block'];
    var color = currentBlock['color'];
    resetGridTable();

    for (int i in block) {
      if (i >= 0 && listOfSquare[i].color != Colors.black) {
        // resetGridTable();
        resetGridTableToOriginal();
        return false;
      }
    }

    for (int i in block) {
      if (i >= 0) {
        listOfSquare[i] = MyPixel(
          index: i,
          color: color,
          isBorderLight: true,
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
        listOfSquare[newBlock[i]] = MyPixel(
          index: newBlock[i],
          color: currentBlock['color'],
          isBorderLight: true,
        );
      }
    }

    //hitfloor
    var re = currentBlock['block'][0] == newBlock[0] && direction == 'b';
    currentBlock['block'] = List<int>.from(newBlock);

    notifyListeners();
    if (re == true) {
      listOfLandedBlock.add({
        'block': newBlock,
        'color': currentBlock['color'],
      });
    }

    //Kiểm tra khối ở vị trí mới có nửa âm nửa dương không?

    return re;
  }

  List<int> moveBlockToBottom() {
    var newBlock = List<int>.from(currentBlock['block']);
    for (int i = 0; i < newBlock.length; i++) {
      if (newBlock[i] + Constant.numberOfGridColOfGridTable >=
          Constant.numberOfGridRowOfGridTable *
              Constant.numberOfGridColOfGridTable) {
        return newBlock;
      } else {
        if (newBlock[i] + Constant.numberOfGridColOfGridTable >= 0 &&
            listOfSquare[newBlock[i] + Constant.numberOfGridColOfGridTable]
                    .color !=
                Colors.black) {
          return newBlock;
        }
      }
    }
    for (int i = 0; i < newBlock.length; i++) {
      newBlock[i] += Constant.numberOfGridColOfGridTable;
    }
    return newBlock;
  }

  List<int> moveBlockToLeft() {
    List<int> newBlock = [];
    try {
      newBlock = List<int>.from(currentBlock['block']);
      for (int i = 0; i < newBlock.length; i++) {
        if (newBlock[i] % Constant.numberOfGridColOfGridTable == 0) {
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
    } catch (e) {
      debugPrint("Error at move to the left button: $e");
    }

    return newBlock;
  }

  List<int> moveBlockToRight() {
    var newBlock = List<int>.from(currentBlock['block']);
    for (int i = 0; i < newBlock.length; i++) {
      if ((newBlock[i] + 1) % Constant.numberOfGridColOfGridTable == 0) {
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

  bool moveBlockToButtonRightNow() {
    var newBlock = List<int>.from(currentBlock['block']);
    resetGridTable();
    //Tiếp tục đi xuống đến khi nào chạm đích
    while (true) {
      // bool overlap = false;
      // bool hitfloor = false;
      bool check = false;
      //Cho khối đi xuống
      for (int i = 0; i < newBlock.length; i++) {
        newBlock[i] += Constant.numberOfGridColOfGridTable;
      }

      //Kiểm tra vị trí mới của khối có hợp lệ hay không? đè lên khối khác hay chạm đích rồi
      for (int i = 0; i < newBlock.length; i++) {
        if (newBlock[i] >=
            Constant.numberOfGridColOfGridTable *
                Constant.numberOfGridRowOfGridTable) {
          check = true;
          break;
        } else {
          if (newBlock[i] >= 0 &&
              listOfSquare[newBlock[i]].color != Colors.black) {
            check = true;
            break;
          }
        }
      }

      //Khối không hợp lệ: quay lại một hàng
      if (check == true) {
        for (int i = 0; i < newBlock.length; i++) {
          newBlock[i] -= Constant.numberOfGridColOfGridTable;
        }
        break;
      }
    }

    listOfLandedBlock.add({
      'block': newBlock,
      'color': currentBlock['color'],
    });
    resetGridTable();
    notifyListeners();
    clearRow();

    //Kiểm tra xem khối mới có nửa âm nửa dương hay không?
    for (var i in newBlock) {
      if (i < 0) return false;
    }

    return true;
  }

  void clearRow() {
    //Duyệt qua từng hàng: từ dưới lên (cao đến thấp)
    for (int i = Constant.numberOfGridRowOfGridTable - 1; i >= 0; i--) {
      //Kiểm tra có đủ số cột hay không (numberOfGridCol)
      int check = 0;
      for (int j = 0; j < Constant.numberOfGridColOfGridTable; j++) {
        int index = i * Constant.numberOfGridColOfGridTable + j;
        if (listOfSquare[index].color != Colors.black) {
          check++;
        }
      }

      //xóa hàng khi đủ 1 hàng
      if (check == Constant.numberOfGridColOfGridTable) {
        //Cập nhật lại điểm số
        point++;
        var listRemoveBlock = [];

        //Duyệt qua từng khối
        for (int k = 0; k < listOfLandedBlock.length; k++) {
          List<int> block = List<int>.from(listOfLandedBlock[k]['block']);

          //Xóa các ô cùng hàng với hàng cần xóa
          for (int j = block.length - 1; j >= 0; j--) {
            if ((block[j] ~/ Constant.numberOfGridColOfGridTable) == i) {
              block.removeAt(j);
            }
          }

          //Đẩy các ô nằm trên hàng cần xóa xuống 1 hàng
          for (int j = 0; j < block.length; j++) {
            if ((block[j] ~/ Constant.numberOfGridColOfGridTable) < i) {
              block[j] += Constant.numberOfGridColOfGridTable;
            }
          }

          //Nếu khối rỗng thì xóa luôn
          if (block.isEmpty) {
            listRemoveBlock.add(k);
          } else {
            //Cập nhật lại khối
            listOfLandedBlock[k]['block'] = block;
          }
        }

        //Xóa khối
        for (int l = listRemoveBlock.length - 1; l >= 0; l--) {
          listOfLandedBlock.removeAt(listRemoveBlock[l]);
        }

        sound.clear();
        resetGridTable();
        i++;
      } else if (check == 0) {
        break;
      }
    }

    resetGridTable();
    notifyListeners();
  }

  void rotateBlock() {
    int type = currentBlock['type'];
    List<int> block = List.from(currentBlock['block']);
    int rotate = currentBlock['rotate'];

    if (type == 0) {
      // 0 -> x x
      //        x x

      List<List<int>> listRotate = [
        [
          2,
          Constant.numberOfGridColOfGridTable,
          1,
          Constant.numberOfGridColOfGridTable - 1
        ],
        [
          Constant.numberOfGridColOfGridTable - 2,
          0,
          Constant.numberOfGridColOfGridTable - 1,
          1
        ],
        [
          -Constant.numberOfGridColOfGridTable + 1,
          -1,
          -Constant.numberOfGridColOfGridTable,
          -2
        ],
        [
          -1,
          -Constant.numberOfGridColOfGridTable + 1,
          0,
          -Constant.numberOfGridColOfGridTable + 2
        ],
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
              block[i] >=
                  Constant.numberOfGridRowOfGridTable *
                      Constant.numberOfGridColOfGridTable) {
            return;
          }
        }

        var listCheck = [];
        for (var item in block) {
          var temp = item % Constant.numberOfGridColOfGridTable;
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
          if (block[i] < 0 ||
              block[i] >=
                  Constant.numberOfGridRowOfGridTable *
                      Constant.numberOfGridColOfGridTable) {
            return;
          }
        }

        var listCheck = [];
        for (var item in block) {
          var temp = item % Constant.numberOfGridColOfGridTable;
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
        [
          Constant.numberOfGridColOfGridTable - 1,
          0,
          -Constant.numberOfGridColOfGridTable + 1,
          -2
        ],
        [
          -Constant.numberOfGridColOfGridTable,
          -Constant.numberOfGridColOfGridTable,
          -1,
          1
        ],
        [
          Constant.numberOfGridColOfGridTable,
          Constant.numberOfGridColOfGridTable,
          1,
          -2 * Constant.numberOfGridColOfGridTable + 1
        ],
        [
          -Constant.numberOfGridColOfGridTable + 1,
          0,
          Constant.numberOfGridColOfGridTable - 1,
          2 * Constant.numberOfGridColOfGridTable
        ],
      ];

      for (int i = 0; i < block.length; i++) {
        block[i] += listRotate[rotate][i];
      }
      rotate = (rotate + 1) % 4;

      for (int i = 0; i < block.length; i++) {
        if (block[i] < 0 ||
            block[i] >=
                Constant.numberOfGridRowOfGridTable *
                    Constant.numberOfGridColOfGridTable) {
          return;
        }
      }

      var listCheck = [];
      for (var item in block) {
        var temp = item % (Constant.numberOfGridColOfGridTable);
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
        block[0] += (Constant.numberOfGridColOfGridTable - 1);
        for (int i = 1; i < block.length; i++) {
          block[i] = block[i - 1] + 1;
        }
        rotate = 1;
      } else if (rotate == 1) {
        block[0] -= (Constant.numberOfGridColOfGridTable - 2);
        for (int i = 1; i < block.length; i++) {
          block[i] = block[i - 1] + Constant.numberOfGridColOfGridTable;
        }
        rotate = 2;
      } else if (rotate == 2) {
        block[0] += (2 * Constant.numberOfGridColOfGridTable - 2);
        for (int i = 1; i < block.length; i++) {
          block[i] = block[i - 1] + 1;
        }
        rotate = 3;
      } else {
        block[0] -= (2 * Constant.numberOfGridColOfGridTable - 1);
        for (int i = 1; i < block.length; i++) {
          block[i] = block[i - 1] + Constant.numberOfGridColOfGridTable;
        }
        rotate = 0;
      }

      //check valid block
      for (int i = 0; i < block.length; i++) {
        if (block[i] < 0 ||
            block[i] >=
                Constant.numberOfGridRowOfGridTable *
                    Constant.numberOfGridColOfGridTable) {
          return;
        }
      }

      //vertical
      if (block[1] - block[0] == Constant.numberOfGridColOfGridTable) {
        if (block[0] < 0 ||
            block[block.length - 1] >=
                Constant.numberOfGridRowOfGridTable *
                    Constant.numberOfGridColOfGridTable) return;
      } else {
        //horizontal
        int currentRow = block[0] ~/ Constant.numberOfGridColOfGridTable;
        for (int i = 1; i < block.length; i++) {
          if (currentRow != (block[i] ~/ Constant.numberOfGridColOfGridTable)) {
            return;
          }
        }
      }
    } else if (type == 4) {
      // 2:   x
      //      x
      //    x x
      List<List<int>> listRotate = [
        [
          -1,
          -1,
          -Constant.numberOfGridColOfGridTable + 1,
          -Constant.numberOfGridColOfGridTable + 1
        ],
        [
          1,
          -Constant.numberOfGridColOfGridTable + 2,
          0,
          Constant.numberOfGridColOfGridTable - 1
        ],
        [
          Constant.numberOfGridColOfGridTable - 1,
          Constant.numberOfGridColOfGridTable - 1,
          1,
          1
        ],
        [
          -Constant.numberOfGridColOfGridTable + 1,
          0,
          Constant.numberOfGridColOfGridTable - 2,
          -1
        ],
      ];

      for (int i = 0; i < block.length; i++) {
        block[i] += listRotate[rotate][i];
      }
      rotate = (rotate + 1) % 4;

      for (int i = 0; i < block.length; i++) {
        if (block[i] < 0 ||
            block[i] >=
                Constant.numberOfGridRowOfGridTable *
                    Constant.numberOfGridColOfGridTable) {
          return;
        }
      }

      var listCheck = [];
      for (var item in block) {
        var temp = item % (Constant.numberOfGridColOfGridTable);
        if (listCheck.contains(temp) == false) {
          listCheck.add(temp);
        }
      }

      for (int i = 1; i < listCheck.length; i++) {
        if ((listCheck[i] - listCheck[i - 1]).abs() != 1) {
          return;
        }
      }
    } else if (type == 5) {
      // 5 -> x x
      //    x x
      List<List<int>> listRotate = [
        [
          Constant.numberOfGridColOfGridTable,
          1,
          Constant.numberOfGridColOfGridTable - 2,
          -1
        ],
        [
          -Constant.numberOfGridColOfGridTable - 1,
          -2,
          1 - Constant.numberOfGridColOfGridTable,
          0
        ],
        [
          1,
          2 - Constant.numberOfGridColOfGridTable,
          -1,
          -Constant.numberOfGridColOfGridTable
        ],
        [
          0,
          Constant.numberOfGridColOfGridTable - 1,
          2,
          Constant.numberOfGridColOfGridTable + 1
        ],
      ];

      for (int i = 0; i < block.length; i++) {
        block[i] += listRotate[rotate][i];
      }
      rotate = (rotate + 1) % 4;

      //Check valid block
      for (int i = 0; i < block.length; i++) {
        if (block[i] < 0 ||
            block[i] >=
                Constant.numberOfGridRowOfGridTable *
                    Constant.numberOfGridColOfGridTable) {
          return;
        }
      }

      var listCheck = [];
      for (var item in block) {
        var temp = item % (Constant.numberOfGridColOfGridTable);
        if (listCheck.contains(temp) == false) {
          listCheck.add(temp);
        }
      }
      listCheck.sort();

      if (rotate % 2 != 0) {
        for (int i = 1; i < listCheck.length; i++) {
          if ((listCheck[i] - listCheck[i - 1]).abs() != 1) {
            return;
          }
        }
      } else {
        if ((listCheck.last - listCheck.first).abs() != 1) return;
      }
    } else if (type == 6) {
      // 6 -> x
      //    x x
      //    x

      List<List<int>> listRotate = [
        [
          -1,
          1 - Constant.numberOfGridColOfGridTable,
          0,
          2 - Constant.numberOfGridColOfGridTable
        ],
        [
          2,
          Constant.numberOfGridColOfGridTable,
          1,
          Constant.numberOfGridColOfGridTable - 1
        ],
        [
          Constant.numberOfGridColOfGridTable - 2,
          0,
          Constant.numberOfGridColOfGridTable - 1,
          1
        ],
        [
          1 - Constant.numberOfGridColOfGridTable,
          -1,
          -Constant.numberOfGridColOfGridTable,
          -2
        ]
      ];

      for (int i = 0; i < block.length; i++) {
        block[i] += listRotate[rotate][i];
      }
      rotate = (rotate + 1) % 4;

      //Check valid block
      for (int i = 0; i < block.length; i++) {
        if (block[i] < 0 ||
            block[i] >=
                Constant.numberOfGridRowOfGridTable *
                    Constant.numberOfGridColOfGridTable) {
          return;
        }
      }

      var listCheck = [];
      for (var item in block) {
        var temp = item % (Constant.numberOfGridColOfGridTable);
        if (listCheck.contains(temp) == false) {
          listCheck.add(temp);
        }
      }
      listCheck.sort();

      if (rotate % 2 != 0) {
        for (int i = 1; i < listCheck.length; i++) {
          if ((listCheck[i] - listCheck[i - 1]).abs() != 1) {
            return;
          }
        }
      } else {
        if ((listCheck.last - listCheck.first).abs() != 1) return;
      }
    } else if (type == 7) {
      // 7 -> x x x
      //        x

      List<List<int>> listRotate = [
        [1 - Constant.numberOfGridColOfGridTable, -1, -1, 0],
        [0, 0, 0, 1 - Constant.numberOfGridColOfGridTable],
        [0, 1, 1, Constant.numberOfGridColOfGridTable - 1],
        [Constant.numberOfGridColOfGridTable - 1, 0, 0, 0]
      ];

      for (int i = 0; i < block.length; i++) {
        block[i] += listRotate[rotate][i];
      }
      rotate = (rotate + 1) % 4;

      //Check valid block
      for (int i = 0; i < block.length; i++) {
        if (block[i] < 0 ||
            block[i] >=
                Constant.numberOfGridRowOfGridTable *
                    Constant.numberOfGridColOfGridTable) {
          return;
        }
      }

      var listCheck = [];
      for (var item in block) {
        var temp = item % (Constant.numberOfGridColOfGridTable);
        if (listCheck.contains(temp) == false) {
          listCheck.add(temp);
        }
      }
      listCheck.sort();

      if (rotate % 2 == 0) {
        for (int i = 1; i < listCheck.length; i++) {
          if ((listCheck[i] - listCheck[i - 1]).abs() != 1) {
            return;
          }
        }
      } else {
        if ((listCheck.last - listCheck.first).abs() != 1) return;
      }
    }

    //Update block
    currentBlock['block'] = block;
    currentBlock['rotate'] = rotate;

    resetGridTable();
    for (int i = 0; i < block.length; i++) {
      if (block[i] >= 0) {
        listOfSquare[block[i]] = MyPixel(
          index: block[i],
          color: currentBlock['color'],
          isBorderLight: true,
        );
      }
    }
    notifyListeners();
  }

  void changeLevel(Duration chosedLevel) {
    level = chosedLevel;
    notifyListeners();
  }

  void assignRestartGame(dynamic function) {
    restartGame = function;
  }

  void assignPauseGame(dynamic function) {
    pauseGame = function;
  }
}
