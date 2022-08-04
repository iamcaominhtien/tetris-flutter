import 'package:flutter/material.dart';

class ControlButton extends StatefulWidget {
  const ControlButton({
    Key? key,
    required this.child,
    required this.callBack,
  }) : super(key: key);
  final Widget child;
  final Function()? callBack;

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  var btnColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapUp: (details) {
          setState(() {
            btnColor = Colors.black;
          });
        },
        onTapDown: (detailed) {
          setState(() {
            btnColor = Colors.red;
          });
        },
        onTap: () {
          try {
            if (widget.callBack != null) {
              widget.callBack!();
            }
          } catch (e) {
            debugPrint("Have a problem in one of ControlButtons: $e");
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
