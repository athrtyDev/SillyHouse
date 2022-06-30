import 'dart:io';
import 'package:camera/camera.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/comment.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/locator.dart';

class Post {
  String? postId;
  DateTime? postDate;
  String? uploadMediaType;
  String? mediaDownloadUrl;
  String? coverDownloadUrl; // if it is video. null on image
  String? userId;
  String? userName;
  Activity? activity;
  User? user;
  File? uploadingFile;
  int? skillPoints;
  bool? isFeatured;
  // tuslah
  int? likeCount;
  bool isUserLiked = false;
  List<Comment>? listComment;
  PickedMedia? pickedMedia;
  late List<CameraDescription> cameras;
  bool isSelected = false;
  late String cacheMediaPath;
  final Api? _api = locator<Api>();

  Post(
      {this.postId,
      this.activity,
      this.user,
      this.uploadMediaType,
      this.userId,
      this.userName,
      this.isFeatured,
      this.mediaDownloadUrl,
      this.postDate,
      this.uploadingFile,
      this.coverDownloadUrl,
      this.likeCount,
      this.skillPoints});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['postId'] ?? null;
    uploadMediaType = json['uploadMediaType'] ?? null;
    userId = json['userId'] ?? null;
    userName = json['userName'] ?? '';
    activity = new Activity(
      id: json['activityId'] ?? null,
      name: json['activityName'] ?? '',
      activityType: json['activityType'] ?? '',
      difficulty: json['activityDifficulty'] ?? '',
    );
    mediaDownloadUrl = json['mediaDownloadUrl'] ?? null;
    coverDownloadUrl = (json['coverDownloadUrl'] == null || json['coverDownloadUrl'] == "")
        ? json['mediaDownloadUrl']
        : json['coverDownloadUrl'];
    postDate = json['postDate'] == null ? (DateTime.parse(json['postDate'].toDate().toString())) : null;
    skillPoints = json['skillPoints'] != null ? int.tryParse(json['skillPoints'].toString()) : null;
    likeCount = json['likeCount'] != null ? int.tryParse(json['likeCount'].toString()) : null;
    isFeatured = json['isFeatured'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId ?? '';
    data['uploadMediaType'] = this.uploadMediaType ?? '';
    data['userId'] = this.userId ?? '';
    data['userName'] = this.userName ?? '';
    data['activityId'] = this.activity!.id ?? '';
    data['activityName'] = this.activity!.name ?? '';
    data['activityType'] = this.activity!.activityType ?? '';
    data['activityDifficulty'] = this.activity!.difficulty ?? '';
    data['mediaDownloadUrl'] = this.mediaDownloadUrl ?? '';
    data['coverDownloadUrl'] = this.coverDownloadUrl ?? '';
    data['postDate'] = this.postDate ?? '';
    data['skillPoints'] = this.skillPoints ?? '';
    data['likeCount'] = this.likeCount ?? '';
    data['isFeatured'] = this.isFeatured ?? '';
    return data;
  }

  void likePost(Post post, String? userId) {
    post.isUserLiked = true;
    if (post.likeCount == null) post.likeCount = 0;
    post.likeCount = post.likeCount! + 1;
    _api!.likePost(post, userId);
  }

  void dislikePost(Post post, String? userId) {
    post.isUserLiked = false;
    post.likeCount = post.likeCount! - 1;
    _api!.dislikePost(post, userId);
  }
}
