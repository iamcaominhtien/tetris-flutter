import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tetris/widgets/play_sound.dart';
import '../components/my_tetris_provider.dart';
import '../constants/constants.dart';

///keyboard controller to play game
class KeyboardController extends StatefulWidget {
  final Widget child;

  const KeyboardController({super.key, required this.child});

  @override
  State<KeyboardController> createState() => _KeyboardControllerState();
}

class _KeyboardControllerState extends State<KeyboardController> {
  late final MyTetrisProvider provider;
  late BuildContext myContext;
  var iconPlayOrStop = Icons.play_circle;
  Timer? controlTimer;
  List<Map<String, dynamic>> listBtn = [];
  bool isActive = false; //turn off all ControlButton (except play button)
  late final PlaySound _sound;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MyTetrisProvider>(context, listen: false);
    myContext = context;
    _sound = provider.sound;
    RawKeyboard.instance.addListener(_onKey);
  }

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyUpEvent) {
      return;
    }

    final key = event.data.logicalKey;

    if (key == LogicalKeyboardKey.arrowUp) {
      rotate();
    } else if (key == LogicalKeyboardKey.arrowDown) {
      moveToBottomRightNow();
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      moveToLeft();
    } else if (key == LogicalKeyboardKey.arrowRight) {
      moveToRight();
    } else if (key == LogicalKeyboardKey.keyP) {
      stopGame();
    } else if (key == LogicalKeyboardKey.keyS) {
      startGame();
    } 
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void startGame() {
    _sound.start();
    if (controlTimer != null) {
      controlTimer!.cancel();
    }
    setState(() {
      iconPlayOrStop = Icons.pause;
    });
    provider.updateTime(status: 's');
    provider.clear();
    provider.resetGridTableToOriginal();
    provider.createABlock();

    setState(() {
      isActive = true;
    });
    recursiveGame();
    // showMyDialog();
  }

  void stopGame() {
    if (controlTimer != null) {
      controlTimer!.cancel();
      controlTimer = null;
      provider.updateTime(status: 'p');
    } else {
      if (provider.currentBlock.isNotEmpty) {
        provider.updateTime(status: 'c');
        recursiveGame();
      }
    }
  }

  void showMyDialog() {
    // var tempContext = myContext;
    showDialog<String>(
        context: myContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Bạn có muốn chơi tiếp?"),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop('Cancel'),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  debugPrint("OK");
                  Navigator.of(context).pop('OK');
                },
                child: const Text("OK"),
              ),
            ],
          );
        }).then((chose) {
      if (chose == 'OK') {
        startGame();
      } else {
        provider.clear();
        provider.resetGridTableToOriginal();
        setState(() {
          isActive = false;
          iconPlayOrStop = Icons.play_circle;
        });
      }
    });
  }

  void recursiveGame() {
    Timer.periodic(
      Constant.duration,
      (timer) {
        try {
          var hitFloor = provider.updateBlock();
          controlTimer = timer;
          if (hitFloor) {
            provider.clearRow();
            if (provider.createABlock() == false) {
              provider.updateTime(status: 'e');
              timer.cancel();
              controlTimer = null;
              showMyDialog();
              return;
            }
            timer.cancel();
            controlTimer = null;
            recursiveGame();
          } else {}
        } catch (e) {
          timer.cancel();
          controlTimer = null;
          provider.updateTime(status: 'e');
          return;
          // startGame();
        }
      },
    );
  }

  void moveToLeft() {
    // await playMusic();
    _sound.move();
    provider.updateBlock(direction: 'l');
  }

  void moveToRight() {
    _sound.move();
    provider.updateBlock(direction: 'r');
  }

  void moveToBottomRightNow() {
    _sound.fall();
    var isContinue = provider.moveBlockToButtonRightNow();
    if (provider.createABlock() == false || isContinue == false) {
      provider.updateTime(status: 'e');
      controlTimer!.cancel();
      controlTimer = null;
      showMyDialog();
      return;
    }
    // setState(() {
    //   iconPlayOrStop = Icons.pause;
    // });
    // recursiveGame();
  }

  void rotate() {
    _sound.rotate();
    provider.rotateBlock();
  }
}
