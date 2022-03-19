import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/core/services/authentication_service.dart';
import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/locator.dart';
import 'package:flutter/material.dart';

class PostStoriesModel extends BaseModel {
  final Api _api = locator<Api>();
  List<Post> listPost;

  void getFeaturedPost() async {
    setState(ViewState.Busy);
    listPost = await _api.getPostStory();
    setState(ViewState.Idle);
    notifyListeners();
  }
}
