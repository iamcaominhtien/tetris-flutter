import 'package:flutter/material.dart';
import '../widgets/grid_table.dart';
import '../widgets/list_control_btn/list_control_button.dart';
import '../widgets/tetris_board/tetris_board.dart';

class TetrisHomeForMobile extends StatelessWidget {
  const TetrisHomeForMobile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: const [
              TetrisBoard(),
              GridTable(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 11.0,
        ),
        child: ListControlButton(pageContext: context),
      ),
    );
  }
}
