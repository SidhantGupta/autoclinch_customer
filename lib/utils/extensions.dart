import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/notifiers/loader_notifier.dart' show LoadingNotifier;

extension ScreenLoader on Widget {
  Widget setScreenLoader<T extends LoadingNotifier>() {
    return Stack(
      children: [
        this,
        Consumer<T>(
          builder: (context, value, child) {
            return (value.isLoading)
                ? InkWell(
                    child: const Opacity(
                        opacity: 1,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                  )
                : SizedBox();
          },
        ),
      ],
    );
  }
}

extension SafeAreaApply on Widget {
  Widget addSafeArea({required BuildContext context, Color? color}) {
    return Container(
      color: color ?? Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: this,
      ),
    );
  }
}

extension StringExt on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
  // bool get isNotNullOrEmpty => this != null && this!.trim().isNotEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}
