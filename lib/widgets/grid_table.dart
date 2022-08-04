import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris/constants/constants.dart';
import '../components/my_tetris_provider.dart';

class GridTable extends StatefulWidget {
  const GridTable({
    Key? key,
  }) : super(key: key);

  @override
  State<GridTable> createState() => _GridTableState();
}

class _GridTableState extends State<GridTable> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyTetrisProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: Constant.numberOfGridCol,
            children: provider.listOfSquare,
          ),
        );
      },
    );
  }
}

class MyPixel extends StatelessWidget {
  const MyPixel({
    Key? key,
    required this.index,
    this.color = Colors.black,
  }) : super(key: key);
  final int index;
  final dynamic color;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4.0),
        ),
        margin: EdgeInsets.only(
            top: 2,
            left: index % Constant.numberOfGridCol == 0 ? 0 : 2,
            right: (index + 1) % Constant.numberOfGridCol == 0 ? 0 : 2,
            bottom: 2),
      ),
    );
  }
}