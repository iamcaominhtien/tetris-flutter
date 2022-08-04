import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tetris/components/my_tetris_provider.dart';
import 'package:tetris/constants/constants.dart';

import '../components/control_button.dart';

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
  // late final MyTetrisProvider providerCanListen;
  late BuildContext myContext;
  var iconPlayOrStop = Icons.play_circle;
  Timer? controlTimer;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MyTetrisProvider>(context, listen: false);
    // providerCanListen = Provider.of<MyTetrisProvider>(context, listen: true);
    myContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ControlButton(
                callBack: null,
                child: Column(
                  children: [
                    ControlButton(
                      callBack: null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/images/award.png',
                                height: 20.0),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              Provider.of<MyTetrisProvider>(context,
                                      listen: true)
                                  .point
                                  .toString(),
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    ControlButton(
                      child: const Icon(
                        Icons.rotate_right,
                        color: Colors.white,
                        size: 40.0,
                      ),
                      callBack: () => startGame(),
                    ),
                  ],
                )),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        ControlButton(
                          child: const Icon(
                            Icons.arrow_left,
                            color: Colors.white,
                            size: 40.0,
                          ),
                          callBack: () => moveToLeft(),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ControlButton(
                          child: const Icon(
                            Icons.arrow_drop_up,
                            color: Colors.white,
                            size: 40.0,
                          ),
                          callBack: () => rotate(),
                        ),
                        ControlButton(
                          child: Icon(
                            iconPlayOrStop,
                            size: 30.0,
                            color: Colors.white,
                          ),
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
                        ),
                        ControlButton(
                          child: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                            size: 40.0,
                          ),
                          callBack: () => moveToBottomRightNow(),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        ControlButton(
                          child: const Icon(
                            Icons.arrow_right,
                            color: Colors.white,
                            size: 40.0,
                          ),
                          callBack: () => moveToRight(),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ControlButton(
              child: const Icon(
                Icons.rotate_right,
                color: Colors.white,
                size: 40.0,
              ),
              callBack: () => startGame(),
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
    provider.clear();
    provider.resetGridTableToOriginal();
    provider.createABlock();
    recursiveGame();
    // showMyDialog();
  }

  void stopGame() {
    if (controlTimer != null) {
      controlTimer!.cancel();
      controlTimer = null;
    } else {
      if (provider.currentBlock.isNotEmpty) {
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
    provider.moveBlockToButtonRightNow();
    if (provider.createABlock() == false) {
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
