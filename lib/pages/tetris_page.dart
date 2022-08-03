import 'package:flutter/material.dart';
import '../components/my_tetris_provider.dart';
import '../widgets/grid_table.dart';
import '../widgets/list_control_button.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: const Color(0xFF232323),
      body: Column(
        children: const [
          GridTable(),
        ],
      ),
      bottomNavigationBar: ListControlButton(pageContext: context),
    );
  }
}
