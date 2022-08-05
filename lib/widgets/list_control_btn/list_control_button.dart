import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tetris/components/my_tetris_provider.dart';
import 'package:tetris/constants/constants.dart';
import 'package:tetris/widgets/list_control_btn/show_next_block.dart';
import 'control_button.dart';

class ListControlButton extends StatefulWidget {
  const ListControlButton({
    required this.pageContext,
    Key? key,
  }) : super(key: key);
  final BuildContext pageContext;

  @override
  State<ListControlButton> createState() => _ListControlButtonState();
}

class _ListControlButtonState extends State<ListControlButton> {
  late final MyTetrisProvider provider;
  late BuildContext myContext;
  var iconPlayOrStop = Icons.play_circle;
  Timer? controlTimer;
  List<Map<String, dynamic>> listBtn = [];
  bool isActive = false; //turn off all ControlButton (except play button)

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MyTetrisProvider>(context, listen: false);
    myContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7.5),
      child: SizedBox(
        height: 90,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  ControlButton(
                    callBack: () => moveToLeft(),
                    errorAt: "MoveLeftButton",
                    isActive: isActive,
                    btnColor: Colors.yellow,
                    child: const Icon(
                      Icons.arrow_left,
                      color: Colors.black,
                      size: 35.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ControlButton(
                    errorAt: "RightToBottomRightNow",
                    isActive: isActive,
                    btnColor: const Color.fromARGB(255, 248, 20, 4),
                    callBack: () => moveToBottomRightNow(),
                    child: const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 2,
              child: ShowNextBlock(),
            ),
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ControlButton(
                          callBack: () => moveToRight(),
                          errorAt: "MoveRightButton",
                          btnColor: const Color.fromARGB(255, 3, 182, 9),
                          isActive: isActive,
                          child: const Icon(
                            Icons.arrow_right,
                            color: Colors.white,
                            size: 35.0,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ControlButton(
                          errorAt: "RotateButton",
                          isActive: isActive,
                          btnColor: const Color.fromARGB(255, 117, 50, 25),
                          callBack: () => rotate(),
                          child: const Icon(
                            Icons.rotate_right,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    //right - play(P) - rotate - playOrStop button
                    child: Column(
                      children: [
                        ControlButton(
                          errorAt: "P or PlayButton",
                          btnColor: Colors.blue[800],
                          callBack: () => startGame(),
                          child: const Text(
                            'P',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ControlButton(
                          errorAt: "PlayOrStopButton",
                          isActive: isActive,
                          callBack: () {
                            setState(() {
                              if (iconPlayOrStop == Icons.pause) {
                                iconPlayOrStop = Icons.play_circle;
                              } else {
                                iconPlayOrStop = Icons.pause;
                              }
                            });
                            // rotate();
                            stopGame();
                          },
                          child: Icon(
                            iconPlayOrStop,
                            size: 25.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startGame() {
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

  void moveToLeft() async {
    await playMusic();
    provider.updateBlock(direction: 'l');
  }

  void moveToRight() {
    provider.updateBlock(direction: 'r');
  }

  void moveToBottomRightNow() {
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
    provider.rotateBlock();
  }

  Future playMusic() async {
    await SystemSound.play(SystemSoundType.click);
  }
}
