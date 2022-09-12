import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> NavKey = GlobalKey<NavigatorState>();

class Constant {
  static final int firestore_file_max_size = 10 * 1024 * 1024;
}

class UserRole {
  static const String admin = "admin";
  static const String teacher = "teacher";
  static const String user = "user";
}
