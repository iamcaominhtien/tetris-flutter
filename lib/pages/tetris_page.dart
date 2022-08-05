import 'package:flutter/material.dart';
import '../components/my_tetris_provider.dart';
import '../widgets/grid_table.dart';
import '../widgets/list_control_btn/list_control_button.dart';
import 'package:provider/provider.dart';

import '../widgets/tetris_board/tetris_board.dart';

class TetrisPage extends StatefulWidget {
  const TetrisPage({Key? key}) : super(key: key);

  @override
  State<TetrisPage> createState() => _TetrisPageState();
}

class _TetrisPageState extends State<TetrisPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyTetrisProvider>(
      create: (context) => MyTetrisProvider(),
      child: const MaterialApp(
        color: Color(0xFF232323),
        debugShowCheckedModeBanner: false,
        home: TetrixHome(),
      ),
    );
  }
}

class TetrixHome extends StatelessWidget {
  const TetrixHome({
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

