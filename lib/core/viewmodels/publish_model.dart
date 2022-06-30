import 'dart:io';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
import 'package:sillyhouseorg/locator.dart';

class PublishModel extends BaseModel {
  final Api? _api = locator<Api>();

  void uploadFile(Post post, File file) async {
    //setState(ViewState.Busy);
    String? postId = await _api!.savePost(post, file);
    // cache new published file
    //var oldFileBytes = await file.readAsBytes();
    //await Tool.cacheNewPublishedPost(postId, oldFileBytes);
    // // means: if post is made by app's camera. Not uploaded from phone
    // if (post.pickedMedia.storageFile == null && await File(post.pickedMedia.path).exists()) {
    //   await File(post.pickedMedia.path).delete();
    // }
    //setState(ViewState.Idle);
    //return postId != null;
  }
}
