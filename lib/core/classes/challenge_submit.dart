import 'package:sillyhouseorg/core/classes/post.dart';

class ChallengeSubmit {
  String? docId;
  String? userId;
  String? userName;
  int? total;
  int? done;
  List<Post>? listPost;
  String? modifiedDate;

  ChallengeSubmit({this.docId, this.userId, this.userName, this.total, this.done, this.listPost, this.modifiedDate});

  ChallengeSubmit.initial()
      : total = 3,
        done = 0;

  ChallengeSubmit.fromJson(Map<String, dynamic> json, String docId) {
    this.docId = docId;
    userId = json['userId'];
    userName = json['userName'];
    total = json['total'];
    done = json['done'];
    if (json['listPost'] != null) {
      listPost = [];
      json['listPost'].forEach((v) {
        listPost!.add(new Post.fromJson(v));
      });
    }
    modifiedDate = json['modifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId ?? null;
    data['userName'] = this.userName ?? null;
    data['total'] = this.total ?? null;
    data['done'] = this.done ?? null;
    if (this.listPost != null) {
      data['listPost'] = this.listPost!.map((v) => v.toJson()).toList();
    }
    data['modifiedDate'] = this.modifiedDate ?? null;
    return data;
  }
}
