import 'package:flutter/material.dart';
import 'package:tetris/constants/constants.dart';

class ControlButton extends StatefulWidget {
  const ControlButton({
    Key? key,
    required this.child,
    required this.callBack,
    required this.errorAt,
    this.isActive = true,
    this.btnColor = Constant.primaryColor,
  }) : super(key: key);
  final Widget child;
  final Function()? callBack;
  final String errorAt;
  final bool isActive;
  final dynamic btnColor;

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  dynamic btnColor;

  @override
  void initState() {
    super.initState();
    btnColor = widget.btnColor;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Material(
          color: btnColor.withOpacity(widget.isActive ? 1.0 : 0.8),
          elevation: 5,
          borderRadius: BorderRadius.circular(8.0),
          child: GestureDetector(
            onTapUp: (details) {
              if (widget.isActive) {
                setState(() {
                  btnColor = widget.btnColor;
                });
              }
            },
            onTapDown: (detailed) {
              if (widget.isActive) {
                setState(() {
                  btnColor = widget.btnColor.withOpacity(0.3);
                });
              }
      
              try {
                if (widget.callBack != null && widget.isActive == true) {
                  widget.callBack!();
                }
              } catch (e) {
                debugPrint(
                    "Have a problem in one of ControlButtons: ${widget.errorAt}, info: $e");
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
