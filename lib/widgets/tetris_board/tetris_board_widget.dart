import 'package:flutter/material.dart';

class TetrisBoardWidget extends StatelessWidget {
  const TetrisBoardWidget({
    Key? key,
    required this.label,
    required this.child,
  }) : super(key: key);

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        child
      ],
    );
  }
}
