import 'dart:convert';
import 'package:sillyhouseorg/core/classes/user.dart';

class UserState {
  final User? user;

  UserState({this.user});

  Map<String, dynamic>? toMap() {
    return user == null ? null : user!.toJson();
  }

  factory UserState.fromMap(Map<String, dynamic>? map) {
    if (map == null)
      return UserState(
        user: User.initial(),
      );
    ;

    return UserState(
      user: User.fromJson(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserState.fromJson(String source) => UserState.fromMap(json.decode(source));
}
