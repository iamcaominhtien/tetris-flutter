import 'package:flutter/material.dart';

class GestureSignalProvider extends ChangeNotifier {
  String? signal;

  void setSignal(String? signal) {
    this.signal = signal;
    notifyListeners();
  }
}
