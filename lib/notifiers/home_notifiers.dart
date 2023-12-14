import '/notifiers/loader_notifier.dart' show LoadingNotifier;
import 'package:flutter/foundation.dart';

class HomeLoadingNotifier extends LoadingNotifier {}

class HomeVendorsNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class HomeLocationNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
