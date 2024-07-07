import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris/pages/tetris_home_mobile.dart';
import 'package:tetris/pages/tetris_home_window.dart';

import '../components/gesture_signal.dart';
import '../components/my_tetris_provider.dart';

class TetrisPage extends StatefulWidget {
  const TetrisPage({super.key});

  @override
  State<TetrisPage> createState() => _TetrisPageState();
}

class _TetrisPageState extends State<TetrisPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyTetrisProvider>(
          create: (_) => MyTetrisProvider(),
        ),
        ChangeNotifierProvider<GestureSignalProvider>(
          create: (_) => GestureSignalProvider(),
        )
      ],
      child: MaterialApp(
        color: const Color(0xFF232323),
        debugShowCheckedModeBanner: false,
        home: defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS
            ? const TetrisHomeForMobile()
            : const TetrisHomeForWindow(),
      ),
    );
  }
}
