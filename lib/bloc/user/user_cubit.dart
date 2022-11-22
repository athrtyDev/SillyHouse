import 'dart:io';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:uuid/uuid.dart';
import 'cubit.dart';

class UserCubit extends Cubit<UserState> with HydratedMixin {
  UserCubit() : super(UserState());

  void login(String name, String password) async {
    try {
      final Api _api = Api();
      name = name.toLowerCase()[0].toUpperCase() + name.toLowerCase().substring(1);
      User? user = await _api.fetchUser(name, password);
      emit(UserState(user: user));
    } on Exception catch (_) {
      emit(UserState(user: null));
    }
  }

  Future<bool> register(String name, String password, String age, String email, String gender, File? profileFile) async {
    try {
      final Api _api = Api();
      // Check user name exists
      name = name.toLowerCase()[0].toUpperCase() + name.toLowerCase().substring(1);
      if (await _api.checkUserNameExists(name)) {
        return false;
      } else {
        // Register user
        var uuid = Uuid();
        User user = new User();
        user.id = uuid.v4();
        user.name = name.toLowerCase()[0].toUpperCase() + name.toLowerCase().substring(1);
        user.password = password;
        user.age = int.tryParse(age);
        user.email = email;
        user.gender = gender;
        user.registeredDate = DateTime.now().toString();
        user.postTotal = 0;
        user.likeTotal = 0;
        user.skillTotal = 0;
        user.profileFile = profileFile;
        await _api.registerUser(user);
        emit(UserState(user: user));
        return true;
      }
    } on Exception catch (_) {
      emit(UserState(user: null));
      return false;
    }
  }

  void removeUser() async {
    try {
      final Api api = Api();
      api.removeUser(state.user!.id!);
      logOut();
    } on Exception catch (_) {
      emit(UserState(user: null));
    }
  }

  void logOut() async {
    app.allPost = null; // post awahdaa tuhain user like darsan esehiig tootsoj bga bolhor null bolgoh
    clear();
    emit(UserState(user: null));
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    return UserState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    return state.toMap();
  }
}
