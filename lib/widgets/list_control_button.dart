import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris/components/my_tetris_provider.dart';
import 'package:tetris/constants/constants.dart';

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
  Timer? controlTimer;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MyTetrisProvider>(context, listen: false);
    myContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ControlButton(
            child: const Text(
              "PLAY",
              style: TextStyle(color: Colors.white, fontSize: 17.0),
            ),
            callBack: () => startGame(),
          ),
          ControlButton(
            child: const Text(
              "STOP",
              style: TextStyle(color: Colors.white, fontSize: 17.0),
            ),
            callBack: () => stopGame(),
          ),
          ControlButton(
            child: const Icon(
              Icons.arrow_left,
              color: Colors.white,
              size: 40.0,
            ),
            callBack: () => moveToLeft(),
          ),
          ControlButton(
            child: const Icon(
              Icons.arrow_right,
              color: Colors.white,
              size: 40.0,
            ),
            callBack: () => moveToRight(),
          ),
          ControlButton(
            child: const Icon(
              Icons.rotate_right,
              color: Colors.white,
              size: 35.0,
            ),
            callBack: () => rotate(),
          ),
          ControlButton(
            child: Text(
              provider.point.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 17.0),
            ),
            callBack: () {},
          ),
        ]),
      ),
    );
  }

  void startGame() {
    if (controlTimer != null) {
      controlTimer!.cancel();
    }
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
            if (provider.createABlock() == false) {
              timer.cancel();
              controlTimer = null;
              // endGame();
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

  void moveToLeft() {
    provider.updateBlock(direction: 'l');
  }

  void moveToRight() {
    provider.updateBlock(direction: 'r');
  }

  void rotate() {
    provider.rotateBlock();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}

class ControlButton extends StatelessWidget {
  const ControlButton({
    Key? key,
    required this.child,
    required this.callBack,
  }) : super(key: key);
  final Widget child;
  final Function() callBack;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: callBack,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
