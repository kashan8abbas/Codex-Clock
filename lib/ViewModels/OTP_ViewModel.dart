import 'dart:async';
import 'package:flutter/material.dart';

class OtpViewModel {
  final ValueNotifier<int> secondsRemaining = ValueNotifier<int>(47);
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void resetTimer() {
    secondsRemaining.value = 47;
    startTimer();
  }

  void dispose() {
    _timer?.cancel();
  }
}
