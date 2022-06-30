import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
import 'package:sillyhouseorg/locator.dart';

class PostStoriesModel extends BaseModel {
  final Api? _api = locator<Api>();
  List<Post>? listPost;

  void getFeaturedPost() async {
    setState(ViewState.Busy);
    listPost = await _api!.getPostStory();
    setState(ViewState.Idle);
    notifyListeners();
  }
}
