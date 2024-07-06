import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:tetris/constants/constants.dart';

class PlaySound {
  late Soundpool pool;

  final _soundIds = <String, int>{};

  bool mute = false;

  void play(String name) {
    final soundId = _soundIds[name];
    if (soundId != null && !mute) {
      debugPrint(soundId.toString());
      pool.play(soundId);
    }
  }

  PlaySound() {
    pool =
        Soundpool.fromOptions(options: const SoundpoolOptions(maxStreams: 6));
    for (var value in Constant.SOUNDS) {
      scheduleMicrotask(() async {
        final data = await rootBundle.load('assets/audio/$value');
        _soundIds[value] = await pool.load(data);
      });
    }
  }

  void dispose() {
    pool.dispose();
  }

  void start() {
    play('start.mp3');
  }

  void clear() {
    play('clean.mp3');
  }

  void fall() {
    play('drop.mp3');
  }

  void rotate() {
    play('rotate.mp3');
  }

  void move() {
    play('move.mp3');
  }
}
