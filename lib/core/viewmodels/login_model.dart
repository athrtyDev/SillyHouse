import 'dart:io';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/core/services/authentication_service.dart';
import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
import 'package:sillyhouseorg/locator.dart';
import 'package:uuid/uuid.dart';

class LoginModel extends BaseModel {
  final AuthenticationService? _authenticationService = locator<AuthenticationService>();

  var customer;
  String? errorMessage;

  Future<User?> login(String name, String password) async {
    setState(ViewState.Busy);
    name = name.toLowerCase()[0].toUpperCase() + name.toLowerCase().substring(1);
    User? user = await _authenticationService!.fetchUser(name, password);
    setState(ViewState.Idle);
    return user;
  }

  Future<bool> registerUser(String name, String password, String age, String email, String gender, File? profileFile) async {
    setState(ViewState.Busy);
    // Check user name exists
    name = name.toLowerCase()[0].toUpperCase() + name.toLowerCase().substring(1);
    if (await _authenticationService!.checkUserNameExists(name)) {
      setState(ViewState.Idle);
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
      await _authenticationService!.registerUser(user);

      setState(ViewState.Idle);
      return true;
    }
  }
}
