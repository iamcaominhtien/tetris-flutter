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
            padding: const EdgeInsets.only(top: 7.5),
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
                              child: TetrisBoardWidget(
                                label: "LEVEL",
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Text(
                                      "1",
                                      style: Constant.tetrisBoardTextStyle,
                                    ),
                                  ],
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
}