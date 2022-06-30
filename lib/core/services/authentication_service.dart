import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/locator.dart';

class AuthenticationService {
  StreamController<User?> userController = StreamController<User?>();

  Future<void> registerUser(User user) async {
    // Profile picture
    if (user.profileFile != null) {
      final Api _api = locator<Api>();
      String profilePicUrl = await _api.uploadFile(user.profileFile!, "user/profile_pic/" + user.id!, "image");
      user.profile_pic = profilePicUrl;
    }
    // User data
    await FirebaseFirestore.instance.collection('User').add(user.toJson());
    await addUserToStreamAndCache(user);
  }

  Future<User?> fetchUser(String name, String password) async {
    QuerySnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .get();

    if (customerSnapshot.docs.isEmpty) {
      return null;
    } else {
      User user = User.fromJson(customerSnapshot.docs[0].data() as Map<String, dynamic>);
      addUserToStreamAndCache(user);
      return user;
    }
  }

  Future<User?> getUserFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      User user = new User(
          id: prefs.getString('id'),
          name: prefs.getString('username'),
          age: prefs.getInt('age'),
          email: prefs.getString('email'),
          registeredDate: prefs.getString('registeredDate'),
          profile_pic: prefs.getString('profile_pic'),
          type: prefs.getString('type'));
      userController.add(user);
      print('controller set');
      return user;
    } else
      return null;
  }

  addUserToStreamAndCache(User user) async {
    userController.add(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', user.id!);
    prefs.setString('username', user.name!);
    prefs.setInt('age', user.age!);
    prefs.setString('email', user.email ?? "");
    prefs.setString('registeredDate', user.registeredDate ?? "");
    prefs.setString('profile_pic', user.profile_pic ?? "");
    prefs.setString('gender', user.gender ?? "");
    prefs.setString('type', user.type ?? "");
  }

  void removeUserFromStreamAndCache() async {
    userController.add(null);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.remove('username');
    prefs.remove('age');
    prefs.remove('email');
    prefs.remove('registeredDate');
    prefs.remove('gender');
  }

  Future<bool> checkUserNameExists(String name) async {
    QuerySnapshot customerSnapshot = await FirebaseFirestore.instance.collection('User').where('name', isEqualTo: name).get();
    return customerSnapshot.docs.isNotEmpty;
  }
}
