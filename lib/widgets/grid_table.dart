// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris/constants/constants.dart';

import '../components/my_tetris_provider.dart';

class GridTable extends StatelessWidget {
  const GridTable({
    super.key,
  });

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
          double heightOfGrid = Constant.numberOfGridRowOfGridTable * sizeOfCell;
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
                      return GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: Constant.numberOfGridColOfGridTable,
                        children: provider.listOfSquare,
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
}
