import 'package:flutter/material.dart';

import '../constants/constants.dart';

class MyPixel extends StatelessWidget {
  const MyPixel({
    Key? key,
    required this.index,
    this.color = Constant.primaryColor,
    this.isRadius = false,
    this.isBorderLight = false,
  }) : super(key: key);
  final int index;
  final dynamic color;
  final bool isRadius;
  final bool isBorderLight;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: ShaderMask(
        shaderCallback: (bounds) => RadialGradient(
                colors: [Colors.white, color, color],
                center: Alignment.topLeft,
                radius: 1.0,
                tileMode: TileMode.mirror)
            .createShader(bounds),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: isRadius == true
                ? BorderRadius.circular(4.0)
                : BorderRadius.circular(0.0),
            border: isBorderLight
                ? Border.all(
                    color: Colors.white,
                    width: 1.0,
                  )
                : Border.all(width: 0.0),
          ),
          margin: const EdgeInsets.only(
              top: 1,
              left: 1,
              right: 1,
              // left: index % Constant.numberOfGridCol == 0 ? 0 : 1,
              // right: (index + 1) % Constant.numberOfGridCol == 0 ? 0 : 1,
              bottom: 1),
        ),
      ),
    );
  }
}
