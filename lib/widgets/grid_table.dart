// import 'package:flutter/foundation.dart';
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
  double heightOfGrid = 420.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        heightOfGrid =
            (((constraints.maxWidth - 30) / Constant.numberOfGridCol) *
                        Constant.numberOfGridRow +
                    26 * 2)
                .ceilToDouble();
        return Center(
          child: SizedBox(
            width: double.infinity,
            height: heightOfGrid,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 13.0),
                decoration: BoxDecoration(
                  color: Constant.primaryColor,
                  // color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    // color: const Color.fromARGB(137, 29, 27, 27),
                    color: const Color.fromARGB(135, 68, 62, 62),
                    border: Border.all(color: Colors.white, width: 1.0),
                  ),
                  child: Consumer<MyTetrisProvider>(
                    builder: (context, provider, child) => GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: Constant.numberOfGridCol,
                      children: provider.listOfSquare,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
