import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:tetris/components/my_tetris_provider.dart';
import 'package:tetris/constants/constants.dart';

import 'tetris_board_widget.dart';

class TetrisBoard extends StatefulWidget {
  const TetrisBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<TetrisBoard> createState() => _TetrisBoardState();
}

class _TetrisBoardState extends State<TetrisBoard> {
  late final MyTetrisProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MyTetrisProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: provider.stopWatchTimer.rawTime,
        initialData: provider.stopWatchTimer.rawTime.value,
        builder: (context, snapshot) {
          final value = snapshot.data!;
          final displayTime =
              StopWatchTimer.getDisplayTime(value, milliSecond: false);
          return Padding(
            padding: const EdgeInsets.only(top: 13.5),
            child: SizedBox(
              height: 60.0,
              width: double.infinity,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                            color: Constant.primaryColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TetrisBoardWidget(
                          label: 'TIME',
                          child: Text(
                            displayTime,
                            style: Constant.tetrisBoardTextStyle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Constant.primaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => chooseLevel(context),
                                child: Container(
                                  color: Constant.primaryColor,
                                  child: TetrisBoardWidget(
                                    label: "LEVEL",
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          (Constant.listOfLevel.indexOf(provider.level)+1).toString(),
                                          style: Constant.tetrisBoardTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Expanded(
                              flex: 2,
                              child: TetrisBoardWidget(
                                label: 'SCORE',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      'assets/images/award.png',
                                      height: 18.0,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    AutoSizeText(
                                      Provider.of<MyTetrisProvider>(context,
                                              listen: true)
                                          .point
                                          .toString(),
                                      style: Constant.tetrisBoardTextStyle,
                                      maxLines: 1,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        });
  }

  void chooseLevel(BuildContext context) {
    Duration level = provider.level;
    provider.pauseGame();
    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ChooseLevelBoard(
            level: level,
            callBack: (Duration value) {
              level = value;
            },
          );
        }).then((chose) {
      if (level != provider.level) {
        provider.changeLevel(level);
      }
      debugPrint(level.toString());

      if (chose == 'restart') {
        provider.restartGame();
      } else {
        provider.pauseGame();
      }
    });
  }
}

class ChooseLevelBoard extends StatefulWidget {
  const ChooseLevelBoard({
    Key? key,
    required this.level,
    required this.callBack,
  }) : super(key: key);

  final Duration level;
  final Function(Duration value) callBack;

  @override
  State<ChooseLevelBoard> createState() => _ChooseLevelBoardState();
}

class _ChooseLevelBoardState extends State<ChooseLevelBoard> {
  late Duration level;

  @override
  void initState() {
    super.initState();
    level = widget.level;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
          child: Text(
        "CHỌN LEVEL",
        style: TextStyle(
          fontWeight: FontWeight.w900,
        ),
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RadioListTile<Duration>(
            title: const Text('Level 1'),
            value: Constant.listOfLevel[0],
            groupValue: level,
            onChanged: (value) {
              setState(() {
                level = value!;
              });
              widget.callBack(level);
            },
          ),
          RadioListTile<Duration>(
            title: const Text('Level 2'),
            value: Constant.listOfLevel[1],
            groupValue: level,
            onChanged: (value) {
              setState(() {
                level = value!;
              });
              widget.callBack(level);
            },
          ),
          RadioListTile<Duration>(
            title: const Text('Level 3'),
            value: Constant.listOfLevel[2],
            groupValue: level,
            onChanged: (value) {
              setState(() {
                level = value!;
              });
              widget.callBack(level);
            },
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () => Navigator.of(context).pop('continue'),
              child: const Text(
                "Tiếp tục",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('restart');
              },
              child: const Text("Chơi lại"),
            ),
          ],
        )
      ],
    );
  }
}
