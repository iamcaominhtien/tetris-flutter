import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class ChooseLevelBoard extends StatefulWidget {
  const ChooseLevelBoard({
    Key? key,
    required this.level,
    required this.callBack,
  }) : super(key: key);

  final Duration level;
  final Function(Duration value) callBack;

  @override
  State<ChooseLevelBoard> createState() => _ChooseLevelBoardState();
}

class _ChooseLevelBoardState extends State<ChooseLevelBoard> {
  late Duration level;

  @override
  void initState() {
    super.initState();
    level = widget.level;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
          child: Text(
        "CHỌN LEVEL",
        style: TextStyle(
          fontWeight: FontWeight.w900,
        ),
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RadioListTile<Duration>(
            title: const Text('Level 1'),
            value: Constant.listOfLevel[0],
            groupValue: level,
            onChanged: (value) {
              setState(() {
                level = value!;
              });
              widget.callBack(level);
            },
          ),
          RadioListTile<Duration>(
            title: const Text('Level 2'),
            value: Constant.listOfLevel[1],
            groupValue: level,
            onChanged: (value) {
              setState(() {
                level = value!;
              });
              widget.callBack(level);
            },
          ),
          RadioListTile<Duration>(
            title: const Text('Level 3'),
            value: Constant.listOfLevel[2],
            groupValue: level,
            onChanged: (value) {
              setState(() {
                level = value!;
              });
              widget.callBack(level);
            },
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () => Navigator.of(context).pop('continue'),
              child: const Text(
                "Tiếp tục",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('restart');
              },
              child: const Text("Chơi lại"),
            ),
          ],
        )
      ],
    );
  }
}
