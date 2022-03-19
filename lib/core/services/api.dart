import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sillyhouseorg/core/classes/Interface_dynamic.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/classes/challenge_submit.dart';
import 'package:sillyhouseorg/core/classes/like.dart';
import 'package:sillyhouseorg/core/classes/comment.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:http/http.dart' as http;
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_compress/video_compress.dart';

class Api {
  var client = new http.Client();

  Future<InterfaceDynamic> getInterfaceDynamic() async {
    QuerySnapshot itemSnapshot = await FirebaseFirestore.instance.collection('Interface_dynamic').get();

    if (itemSnapshot.docs.isEmpty) {
      return null;
    } else {
      InterfaceDynamic dynamic = InterfaceDynamic.fromJson(itemSnapshot.docs.first.data());
      return dynamic;
    }
  }

  Future<List<ActivityType>> getActivityType() async {
    QuerySnapshot itemSnapshot =
        await FirebaseFirestore.instance.collection('Activity_type').orderBy('id', descending: false).get();

    if (itemSnapshot.docs.isEmpty)
      return null;
    else
      return itemSnapshot.docs.map((type) => new ActivityType.fromJson(type.data())).toList();
  }

  Future<List<Activity>> getAllActivity() async {
    // Important!: Return both active and inactive
    QuerySnapshot itemSnapshot = await FirebaseFirestore.instance.collection('Activity').orderBy('id', descending: false).get();
    if (itemSnapshot.docs.isEmpty)
      return null;
    else {
      List<Activity> list = [];
      itemSnapshot.docs.map((activity) => new Activity.fromJson(activity.data())).toList();
      for (var item in itemSnapshot.docs) {
        Activity activity = new Activity.fromJson(item.data());
        activity.docId = item.id;
        list.add(activity);
      }
      return list;
    }
  }

  Future<List<Activity>> getActivityByType(String activityType) async {
    QuerySnapshot itemSnapshot = await FirebaseFirestore.instance
        .collection('Activity')
        .where('isActive', isEqualTo: true)
        .where('activityType', isEqualTo: activityType)
        .get();

    if (itemSnapshot.docs.isEmpty)
      return null;
    else
      return itemSnapshot.docs.map((activity) => new Activity.fromJson(activity.data())).toList();
  }

  Future<Activity> getActivityById(String id, String type) async {
    QuerySnapshot itemSnapshot = await FirebaseFirestore.instance
        .collection('Activity')
        .where('activityType', isEqualTo: type)
        .where('id', isEqualTo: id)
        .get();

    if (itemSnapshot.docs.isEmpty)
      return null;
    else {
      Activity activity = Activity.fromJson(itemSnapshot.docs[0].data());
      return activity;
    }
  }

  Future<String> savePost(Post post, File file) async {
    try {
      File thumbnailFile;
      String coverDownloadUrl = '';
      String postId = Uuid().v4();
      if (post.uploadMediaType == 'video') {
        // Compress video
        print('Compress video starting... ' + DateTime.now().toString());
        MediaInfo mediaInfo = await VideoCompress.compressVideo(
          file.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: true,
          includeAudio: true,
        );
        print('Compress video success! ' + DateTime.now().toString());
        file = mediaInfo.file;

        // Thumbnail image
        thumbnailFile = await VideoCompress.getFileThumbnail(mediaInfo.path,
            quality: 30, // default(100)
            position: -1 // default(-1)
            );

        // save thumbnail image
        coverDownloadUrl = await uploadFile(
            thumbnailFile,
            "post/" +
                post.user.name +
                "_" +
                post.user.id +
                "/" +
                post.activity.activityType +
                "_" +
                post.activity.id +
                "_" +
                postId +
                "_cover",
            "image");
      }

      // save media to storage
      String downloadUrl = await uploadFile(
          file,
          "post/" +
              post.user.name +
              "_" +
              post.user.id +
              "/" +
              post.activity.activityType +
              "_" +
              post.activity.id +
              "_" +
              postId +
              "_media",
          post.uploadMediaType);

      // prepare post data
      Map<String, dynamic> postJson = new Map();
      postJson['postId'] = postId;
      postJson['uploadMediaType'] = post.uploadMediaType;
      postJson['userId'] = post.user.id;
      postJson['userName'] = post.user.name;
      postJson['activityId'] = post.activity.id;
      postJson['activityName'] = post.activity.name;
      postJson['activityType'] = post.activity.activityType;
      postJson['activityDifficulty'] = post.activity.difficulty;
      postJson['skillPoints'] = post.activity.skill;
      postJson['likeCount'] = 0;
      postJson['mediaDownloadUrl'] = downloadUrl;
      postJson['coverDownloadUrl'] = post.uploadMediaType == 'video' ? coverDownloadUrl : downloadUrl;
      postJson['postDate'] = DateTime.now();

      // order -> batch
      var db = FirebaseFirestore.instance;
      DocumentReference orderReference = db.collection("Post").doc();
      WriteBatch batch = db.batch();
      batch.set(orderReference, postJson);

      // execute batch
      await batch.commit().then((value) {
        print('Post upload succeeded. ' + DateTime.now().toString());
      }).catchError((error) {
        print('Post upload error:' + error);
      });
      return postId;
    } catch (e) {
      print('SavePost function error:' + e);
      return null;
    }
  }

  Future<List<Post>> getAllPost() async {
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance.collection('Post').orderBy('postDate', descending: true).get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((post) => new Post.fromJson(post.data())).toList();
    }
  }

  Future<List<Post>> getPostByUser(User user) async {
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('Post')
        .where('userId', isEqualTo: user.id)
        .orderBy('postDate', descending: true)
        .get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((post) => new Post.fromJson(post.data())).toList();
    }
  }

  Future<List<Post>> getPostStory() async {
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('Post')
        .where('isFeatured', isEqualTo: true)
        .orderBy('postDate', descending: true)
        .get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((post) => new Post.fromJson(post.data())).toList();
    }
  }

  Future<List<Post>> getPostByActivity(Activity activity) async {
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('Post')
        //.where('activityType', isEqualTo: activity.activityType)
        .where('activityId', isEqualTo: activity.id)
        .orderBy('postDate', descending: true)
        .get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((post) => new Post.fromJson(post.data())).toList();
    }
  }

  Future<void> deletePost(Post post) async {
    // delete document
    await FirebaseFirestore.instance.collection('Post').where("postId", isEqualTo: post.postId).get().then((snapshot) {
      snapshot.docs.first.reference.delete();
      print('Successfully deleted document');
    });

    // delete file from storage
    Reference ref = await FirebaseStorage.instance.refFromURL(post.mediaDownloadUrl);
    await ref.delete();
    print('deleting media... ' + post.mediaDownloadUrl);
    print('Successfully deleted MEDIA storage item');

    if (post.uploadMediaType == 'video') {
      ref = await FirebaseStorage.instance.refFromURL(post.coverDownloadUrl);
      await ref.delete();
      print('deleting cover... ' + post.coverDownloadUrl);
      print('Successfully deleted COVER storage item');
    }

    // delete from cache
    if (await File(post.cacheMediaPath).exists()) {
      File(post.cacheMediaPath).delete();
      print('Successfully deleted ' + post.cacheMediaPath + ' cache');
    }
  }

  Future<List<Comment>> getListComment(String postId) async {
    QuerySnapshot postSnapshot;
    if (postId == null || postId == '') {
      postSnapshot = await FirebaseFirestore.instance.collection('Comment').orderBy('date', descending: true).get();
    } else {
      postSnapshot = await FirebaseFirestore.instance
          .collection('Comment')
          .where('postId', isEqualTo: postId)
          .orderBy('date', descending: true)
          .get();
    }

    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((comment) => new Comment.fromJson(comment.data())).toList();
    }
  }

  Future<void> postComment(Comment newComment) async {
    final CollectionReference ref = FirebaseFirestore.instance.collection('Comment');
    ref.doc().set(newComment.toJson());
  }

  Future<List<Like>> getAllLikes() async {
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance.collection('Like').get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((like) => new Like.fromJson(like.data())).toList();
    }
  }

  void likePost(Post post, String userId) {
    Like like = new Like();
    like.postId = post.postId;
    like.likedUserId = userId;
    final CollectionReference ref = FirebaseFirestore.instance.collection('Like');
    ref.doc().set(like.toJson());
  }

  void dislikePost(Post post, String userId) {
    FirebaseFirestore.instance
        .collection('Like')
        .where("likedUserId", isEqualTo: userId)
        .where("postId", isEqualTo: post.postId)
        .get()
        .then((snapshot) {
      snapshot.docs.first.reference.delete();
    });
  }

  Future<void> deleteComment(String commentId) async {
    FirebaseFirestore.instance.collection('Comment').where("commentId", isEqualTo: commentId).get().then((snapshot) {
      snapshot.docs.first.reference.delete();
    });
  }

  Future<void> createActivity(Activity activity) async {
    final CollectionReference ref = FirebaseFirestore.instance.collection('Activity');
    ref.doc().set(activity.toJson());
  }

  Future<void> updateActivity(Activity activity) async {
    FirebaseFirestore.instance.collection('Activity').doc(activity.docId).update(activity.toJson());
  }

  Future<String> uploadFile(File file, String path, String type) async {
    type = type == 'image' ? 'image/jpeg' : 'video/mp4';
    print('File upload starting... ' + DateTime.now().toString());
    UploadTask fileUploadTask = FirebaseStorage.instance.ref().child(path).putFile(file, SettableMetadata(contentType: type));
    String downloadUrl = await (await fileUploadTask).ref.getDownloadURL();
    print('File upload success! ' + DateTime.now().toString());
    return downloadUrl;
  }

  Future<ChallengeSubmit> getChallengeSubmitByUser(User user) async {
    QuerySnapshot itemSnapshot =
        await FirebaseFirestore.instance.collection('Challenge_submits').where('userId', isEqualTo: user.id).get();

    if (itemSnapshot.docs.isEmpty)
      return ChallengeSubmit.initial();
    else
      return ChallengeSubmit.fromJson(itemSnapshot.docs[0].data(), itemSnapshot.docs[0].id);
  }

  Future<void> createChallengeSubmit(ChallengeSubmit submit) async {
    final CollectionReference ref = FirebaseFirestore.instance.collection('Challenge_submits');
    ref.doc().set(submit.toJson());
  }

  Future<void> updateChallengeSubmit(ChallengeSubmit submit) async {
    FirebaseFirestore.instance.collection('Challenge_submits').doc(submit.docId).update(submit.toJson());
  }
}
