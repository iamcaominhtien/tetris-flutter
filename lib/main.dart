import 'package:flutter/material.dart';
import 'package:tetris/constants/constants.dart';
import 'pages/tetris_page.dart';
import 'package:flutter/foundation.dart';

void main() {
  if (defaultTargetPlatform == TargetPlatform.windows || kIsWeb) {
    Constant.numberOfGridRow = 19;
    Constant.numberOfGridCol = 28;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TetrisPage(),
    );
  }
}
