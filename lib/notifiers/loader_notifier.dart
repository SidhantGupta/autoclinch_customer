import 'package:flutter/foundation.dart';

abstract class LoadingNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(loading) {
    _isLoading = loading;

    ////("Notifier class called");
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void reset({bool loading = false}) {
    _isLoading = loading;
  }
}

class LoginLoadingNotifier extends LoadingNotifier {}

class ProfileLoadingNotifier extends LoadingNotifier {}

class EditProfileLoadingNotifier extends LoadingNotifier {}

class AddVehicleLoadingNotifier extends LoadingNotifier {}

class AddReviewNotifier extends LoadingNotifier {}

class PaymentLoadingNotifier extends LoadingNotifier {}

class BookingLoadingNotifier extends LoadingNotifier {}

class RegisterLoadingNotifier extends LoadingNotifier {}
