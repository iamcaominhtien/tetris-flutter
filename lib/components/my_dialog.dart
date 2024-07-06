import 'package:flutter/material.dart';

void showMyDialog(BuildContext myContext, Function()? callBack) {
  // var tempContext = myContext;
  showDialog<String>(
      context: myContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bạn có muốn chơi tiếp?"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop('Cancel'),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint("OK");
                Navigator.of(context).pop('OK');
              },
              child: const Text("OK"),
            ),
          ],
        );
      }).then((chosed) {
    if (chosed == 'OK') {
      callBack;
    }
  });
}
