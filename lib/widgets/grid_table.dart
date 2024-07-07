// import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris/components/gesture_signal.dart';
import 'package:tetris/constants/constants.dart';

import '../components/my_tetris_provider.dart';

class GridTable extends StatefulWidget {
  const GridTable({
    super.key,
  });

  @override
  State<GridTable> createState() => _GridTableState();
}

class _GridTableState extends State<GridTable> {
  Timer? _onLongPressTimer;
  late final gestureSignalProvider = context.read<GestureSignalProvider>();

  @override
  void dispose() {
    _onLongPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: LayoutBuilder(
        builder: (context, constraints) {
          var sizeOfCell = ((constraints.maxWidth - 30.0) /
              Constant.numberOfGridColOfGridTable);
          Constant.numberOfGridRowOfGridTable =
              ((constraints.maxHeight - 26) / sizeOfCell).floor();
          double heightOfGrid =
              Constant.numberOfGridRowOfGridTable * sizeOfCell;
          Provider.of<MyTetrisProvider>(context, listen: false)
              .resetGridTableToOriginal(false);
          return Center(
            child: Container(
              height: heightOfGrid + 26,
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.0),
              decoration: BoxDecoration(
                color: Constant.primaryColor,
                // color: Colors.grey,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  // color: const Color.fromARGB(137, 29, 27, 27),
                  color: const Color.fromARGB(135, 68, 62, 62),
                  border: Border.all(color: Colors.white, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Consumer<MyTetrisProvider>(
                    builder: (context, provider, child) {
                      return GestureDetector(
                        onTapDown: (details) => onPressDown(details, context),
                        onLongPressStart: (details) =>
                            onLongPressDown(details, context),
                        // onTapUp: onPressUp,
                        onLongPressUp: onLongPressUp,
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: Constant.numberOfGridColOfGridTable,
                          children: provider.listOfSquare,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onPressUp(LongPressEndDetails details) {
    print('onLongPressUp');
  }

  String? detectSize(details, context) {
    // find the position of press
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    final double x = localOffset.dx;
    final double y = localOffset.dy;

    // get size of table
    final maxWidth = box.size.width;
    final maxHeight = box.size.height;

    // get middle of table
    final middleX = maxWidth / 2;

    // area of right side
    if (x > middleX && y < maxHeight * 0.7) {
      return 'r';
    }
    // area of left side
    if (x < middleX && y < maxHeight * 0.7) {
      return 'l';
    }
    //area of bottom side
    if (y >= maxHeight * 0.7) {
      return 'b';
    }

    return null;
  }

  void onPressDown(details, context) {
    gestureSignalProvider.setSignal(detectSize(details, context));
    // switch (detectSize(details, context)) {
    //   case 'l':
    //     print('move left');
    //     break;
    //   case 'r':
    //     print('move right');
    //     break;
    //   case 'b':
    //     print('move down');
    //     break;
    // }
  }

  void onLongPressDown(LongPressStartDetails details, context) {
    _onLongPressTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) {
        gestureSignalProvider.setSignal(detectSize(details, context));
        // switch (detectSize(details, context)) {
        //   case 'l':
        //     print('move left');
        //     break;
        //   case 'r':
        //     print('move right');
        //     break;
        //   case 'b':
        //     print('move down');
        //     break;
        // }
      },
    );
  }

  void onLongPressUp() {
    _onLongPressTimer?.cancel();
    // print('stop moving');
  }
}
