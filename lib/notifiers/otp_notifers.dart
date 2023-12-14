import '/notifiers/loader_notifier.dart' show LoadingNotifier;
import 'package:flutter/foundation.dart' show ChangeNotifier;

class CounterNotifier extends ChangeNotifier {
  final int timerMaxSeconds;
  final int maximumTry;
  int _currentSecond = 0;
  int _totalTry = 1;
  bool isMaximumTryed = false;

  CounterNotifier({this.timerMaxSeconds = 30, this.maximumTry = 3}) {
    _totalTry = 1;
  }

  int get currentSecond => _currentSecond;
  set currentSecond(newValue) {
    _currentSecond = newValue;
    notifyListeners();
  }

  void nextCounter(Function() restart) {
    _totalTry++;
    ////('nextCounter _totalTry: $_totalTry');
    if (_totalTry <= maximumTry) {
      restart();
      isMaximumTryed = false;
    } else {
      isMaximumTryed = true;
      notifyListeners();
    }
  }

  void reset({int currentSecond = 0}) {
    _currentSecond = currentSecond;
  }
}

class OtpLoadingNotifier extends LoadingNotifier {}
