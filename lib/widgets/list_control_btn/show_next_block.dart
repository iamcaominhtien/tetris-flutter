import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/my_pixel.dart';
import '../../components/my_tetris_provider.dart';
import '../../constants/constants.dart';

class ShowNextBlock extends StatelessWidget {
  const ShowNextBlock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Constant.primaryColor,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Consumer<MyTetrisProvider>(
          builder: (context, nextBlock, child) {
            List<int> block = [];
            var color = Constant.primaryColor;
            if (nextBlock.nextBlock.isNotEmpty) {
              block = Constant.showNextBlock[nextBlock.nextBlock['type']];
              color = nextBlock.nextBlock['color'];
            }

            return GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: Constant.numberOfGridColOfShowNextBlock,
              children: List.generate(
                Constant.numberOfGridColOfShowNextBlock *
                    Constant.numberOfGridRowOfShowNextBlock,
                (index) => MyPixel(
                  index: index,
                  isRadius: false,
                  color: block.contains(index) ? color : Constant.primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
