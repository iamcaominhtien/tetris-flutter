import 'package:flutter/material.dart';
import 'package:tetris/pages/tetris_home_mobile.dart';
import 'package:tetris/pages/tetris_home_window.dart';
import '../components/my_tetris_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

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
      child: MaterialApp(
        color: const Color(0xFF232323),
        debugShowCheckedModeBanner: false,
        home: defaultTargetPlatform == TargetPlatform.android ||defaultTargetPlatform == TargetPlatform.iOS
            ? const TetrisHomeForMobile()
            : const TetrixHomeForWindow(),
      ),
    );
  }
}
