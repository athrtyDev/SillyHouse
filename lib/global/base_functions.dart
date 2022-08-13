import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

BaseFunctions baseFunctions = BaseFunctions();

class BaseFunctions {
  void logCatcher({required String eventName, Map<String, dynamic>? properties}) async {
    try {
      if (true || kReleaseMode) {
        await FirebaseAnalytics.instance.logEvent(
          name: eventName,
          parameters: properties,
        );
      }
    } on Exception catch (e) {
      print("Error on segment tracking. $e");
    }
  }

  // ------------------ SINGLETON -----------------------
  static final BaseFunctions _baseFunctions = BaseFunctions._internal();

  factory BaseFunctions() {
    return _baseFunctions;
  }

  BaseFunctions._internal();
}
