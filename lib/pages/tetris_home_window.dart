import 'package:flutter/material.dart';
import 'package:tetris/widgets/keyboard.dart';
import '../widgets/grid_table.dart';

class TetrixHomeForWindow extends StatelessWidget {
  const TetrixHomeForWindow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: KeyboardController(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                const SizedBox(width: 990,child: GridTable(),),
                Expanded(
                  flex: 1,
                  child: Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
