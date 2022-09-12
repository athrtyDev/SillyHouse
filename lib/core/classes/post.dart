import 'dart:io';
import 'package:camera/camera.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/comment.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/utils/utils.dart';

class Post {
  String? docId;
  String? postId;
  DateTime? postDate;
  String? uploadMediaType;
  String? mediaDownloadUrl;
  String? coverDownloadUrl; // if it is video. null on image
  String? userId;
  String? userName;
  String? userProfilePic;
  Activity? activity;
  User? user;
  File? uploadingFile;
  int? skillPoints;
  bool? isFeatured;
  late int likeCount;
  late String likedUserIds;
  late int commentCount;
  // tuslah
  bool isUserLiked = false;
  List<Comment>? listComment;
  PickedMedia? pickedMedia;
  late List<CameraDescription> cameras;
  bool isSelected = false;
  // late String cacheMediaPath;

  Post(
      {this.postId,
      this.activity,
      this.user,
      this.uploadMediaType,
      this.userId,
      this.userName,
      this.userProfilePic,
      this.isFeatured,
      this.mediaDownloadUrl,
      this.postDate,
      this.uploadingFile,
      this.coverDownloadUrl,
      this.likeCount = 0,
      this.likedUserIds = "",
      this.commentCount = 0,
      this.skillPoints});

  Post.fromJson(Map<String, dynamic> json) {
    docId = json['docId'] ?? null;
    postId = json['postId'] ?? null;
    uploadMediaType = json['uploadMediaType'] ?? null;
    userId = json['userId'] ?? null;
    userName = json['userName'] ?? '';
    userProfilePic = json['userProfilePic'] ?? '';
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
    postDate = Utils.timestampToDate(json['postDate']);
    skillPoints = json['skillPoints'] != null ? int.tryParse(json['skillPoints'].toString()) : null;
    isFeatured = json['isFeatured'] ?? false;
    likeCount = json['likeCount'] != null ? int.parse(json['likeCount'].toString()) : 0;
    likedUserIds = json['likedUserIds'] ?? "";
    commentCount = json['commentCount'] != null ? int.parse(json['commentCount'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docId'] = this.docId ?? '';
    data['postId'] = this.postId ?? '';
    data['uploadMediaType'] = this.uploadMediaType ?? '';
    data['userId'] = this.userId ?? '';
    data['userName'] = this.userName ?? '';
    data['userProfilePic'] = this.userProfilePic ?? '';
    data['activityId'] = this.activity!.id ?? '';
    data['activityName'] = this.activity!.name ?? '';
    data['activityType'] = this.activity!.activityType ?? '';
    data['activityDifficulty'] = this.activity!.difficulty ?? '';
    data['mediaDownloadUrl'] = this.mediaDownloadUrl ?? '';
    data['coverDownloadUrl'] = this.coverDownloadUrl ?? '';
    data['postDate'] = this.postDate ?? '';
    data['skillPoints'] = this.skillPoints ?? 0;
    data['likeCount'] = this.likeCount;
    data['likedUserIds'] = this.likedUserIds;
    data['commentCount'] = this.commentCount;
    data['isFeatured'] = this.isFeatured ?? '';
    return data;
  }
}
