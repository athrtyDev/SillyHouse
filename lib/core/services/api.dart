import 'dart:async';
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

  Future<InterfaceDynamic?> getInterfaceDynamic() async {
    print("Request:::::: getInterfaceDynamic");
    QuerySnapshot itemSnapshot = await FirebaseFirestore.instance.collection('Interface_dynamic').get();

    if (itemSnapshot.docs.isEmpty) {
      return null;
    } else {
      InterfaceDynamic _dynamic = InterfaceDynamic.fromJson(itemSnapshot.docs.first.data() as Map<String, dynamic>);
      return _dynamic;
    }
  }

  Future<void> registerUser(User user) async {
    print("Request:::::: registerUser");
    if (user.profileFile != null) {
      final Api _api = Api();
      String profilePicUrl = await _api.uploadFile(user.profileFile!, "user/profile_pic/" + user.id!, "image");
      user.profile_pic = profilePicUrl;
    }
    await FirebaseFirestore.instance.collection('User').add(user.toJson());
  }

  Future<User?> fetchUser(String name, String password) async {
    print("Request:::::: fetchUser");
    QuerySnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .get();

    if (customerSnapshot.docs.isEmpty) {
      return null;
    } else {
      return User.fromJson(customerSnapshot.docs[0].data() as Map<String, dynamic>);
    }
  }

  Future<bool> checkUserNameExists(String name) async {
    print("Request:::::: checkUserNameExists");
    QuerySnapshot customerSnapshot = await FirebaseFirestore.instance.collection('User').where('name', isEqualTo: name).get();
    return customerSnapshot.docs.isNotEmpty;
  }

  Future<List<ActivityType>?> getActivityType() async {
    print("Request:::::: getActivityType");
    QuerySnapshot itemSnapshot =
        await FirebaseFirestore.instance.collection('Activity_type').orderBy('id', descending: false).get();

    if (itemSnapshot.docs.isEmpty)
      return null;
    else
      return itemSnapshot.docs.map((type) => new ActivityType.fromJson(type.data() as Map<String, dynamic>)).toList();
  }

  Future<List<Activity>?> getAllActivity() async {
    print("Request:::::: getAllActivity");
    // Important!: Return both active and inactive
    QuerySnapshot itemSnapshot = await FirebaseFirestore.instance.collection('Activity').orderBy('id', descending: false).get();
    if (itemSnapshot.docs.isEmpty)
      return null;
    else {
      List<Activity> list = [];
      itemSnapshot.docs.map((activity) => new Activity.fromJson(activity.data() as Map<String, dynamic>)).toList();
      for (var item in itemSnapshot.docs) {
        Activity activity = new Activity.fromJson(item.data() as Map<String, dynamic>);
        activity.docId = item.id;
        list.add(activity);
      }
      return list;
    }
  }

  Future<List<Activity>?> getActivityByType(String activityType) async {
    print("Request:::::: getActivityByType");
    QuerySnapshot itemSnapshot = await FirebaseFirestore.instance
        .collection('Activity')
        .where('isActive', isEqualTo: true)
        .where('activityType', isEqualTo: activityType)
        .get();

    if (itemSnapshot.docs.isEmpty)
      return null;
    else
      return itemSnapshot.docs.map((activity) => new Activity.fromJson(activity.data() as Map<String, dynamic>)).toList();
  }

  Future<Activity?> getActivityById(String id, String type) async {
    print("Request:::::: getActivityById");
    QuerySnapshot itemSnapshot = await FirebaseFirestore.instance
        .collection('Activity')
        .where('activityType', isEqualTo: type)
        .where('id', isEqualTo: id)
        .get();

    if (itemSnapshot.docs.isEmpty)
      return null;
    else {
      Activity activity = Activity.fromJson(itemSnapshot.docs[0].data() as Map<String, dynamic>);
      return activity;
    }
  }

  Future<Post?> savePost(Post post, File? file) async {
    print("Request:::::: savePost");
    try {
      File thumbnailFile;
      String coverDownloadUrl = '';
      String postId = Uuid().v4();
      if (post.uploadMediaType == 'video') {
        // Compress video
        print('Compress video starting... ' + DateTime.now().toString());
        MediaInfo mediaInfo = await (VideoCompress.compressVideo(
          file!.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: true,
          includeAudio: true,
        ) as FutureOr<MediaInfo>);
        print('Compress video success! ' + DateTime.now().toString());
        file = mediaInfo.file;

        // Thumbnail image
        thumbnailFile = await VideoCompress.getFileThumbnail(mediaInfo.path!,
            quality: 30, // default(100)
            position: -1 // default(-1)
            );

        // save thumbnail image
        coverDownloadUrl = await uploadFile(
            thumbnailFile,
            "post/" +
                post.user!.name! +
                "_" +
                post.user!.id! +
                "/" +
                post.activity!.activityType! +
                "_" +
                post.activity!.id! +
                "_" +
                postId +
                "_cover",
            "image");
      }

      // save media to storage
      String downloadUrl = await uploadFile(
          file!,
          "post/" +
              post.user!.name! +
              "_" +
              post.user!.id! +
              "/" +
              post.activity!.activityType! +
              "_" +
              post.activity!.id! +
              "_" +
              postId +
              "_media",
          post.uploadMediaType);

      // prepare post data
      Map<String, dynamic> postJson = new Map();
      postJson['postId'] = postId;
      postJson['uploadMediaType'] = post.uploadMediaType;
      postJson['userId'] = post.user!.id;
      postJson['userName'] = post.user!.name;
      postJson['userProfilePic'] = post.user!.profile_pic;
      postJson['activityId'] = post.activity!.id;
      postJson['activityName'] = post.activity!.name;
      postJson['activityType'] = post.activity!.activityType;
      postJson['activityDifficulty'] = post.activity!.difficulty;
      postJson['skillPoints'] = post.activity!.skill;
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

      // prepare new post object for cache
      post.postId = postId;
      post.likeCount = 0;
      post.mediaDownloadUrl = downloadUrl;
      post.coverDownloadUrl = post.uploadMediaType == 'video' ? coverDownloadUrl : downloadUrl;
      post.postDate = DateTime.now();
      post.userName = post.user!.name;
      post.userId = post.user!.id;
      post.userProfilePic = post.user!.profile_pic;

      return post;
    } catch (e) {
      print('SavePost function error:' + e.toString());
      return null;
    }
  }

  Future<List<Post>?> getAllPost() async {
    print("Request:::::: getAllPost");
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance.collection('Post').orderBy('postDate', descending: true).get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      List<Post>? listAll = [];
      for (var item in postSnapshot.docs) {
        Post post = new Post.fromJson(item.data() as Map<String, dynamic>);
        post.docId = item.id;
        listAll.add(post);
      }
      return listAll;
    }
  }

  Future<List<Post>?> getPostByUser(String userId) async {
    print("Request:::::: getPostByUser");
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('Post')
        .where('userId', isEqualTo: userId)
        .orderBy('postDate', descending: true)
        .get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((post) => new Post.fromJson(post.data() as Map<String, dynamic>)).toList();
    }
  }

  Future<List<Post>?> getPostStory() async {
    print("Request:::::: getPostStory");
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('Post')
        .where('isFeatured', isEqualTo: true)
        .orderBy('postDate', descending: true)
        .get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((post) => new Post.fromJson(post.data() as Map<String, dynamic>)).toList();
    }
  }

  Future<List<Post>?> getPostByActivity(String activityId) async {
    print("Request:::::: getPostByActivity");
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('Post')
        .where('activityId', isEqualTo: activityId)
        .orderBy('postDate', descending: true)
        .get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((post) => new Post.fromJson(post.data() as Map<String, dynamic>)).toList();
    }
  }

  Future<void> deletePost(Post post) async {
    print("Request:::::: deletePost");
    // delete document
    await FirebaseFirestore.instance.collection('Post').where("postId", isEqualTo: post.postId).get().then((snapshot) {
      snapshot.docs.first.reference.delete();
      print('Successfully deleted document');
    });

    // delete file from storage
    Reference ref = await FirebaseStorage.instance.refFromURL(post.mediaDownloadUrl!);
    await ref.delete();
    print('deleting media... ' + post.mediaDownloadUrl!);
    print('Successfully deleted MEDIA storage item');

    if (post.uploadMediaType == 'video') {
      ref = await FirebaseStorage.instance.refFromURL(post.coverDownloadUrl!);
      await ref.delete();
      print('deleting cover... ' + post.coverDownloadUrl!);
      print('Successfully deleted COVER storage item');
    }

    // // delete from cache
    // if (await File(post.cacheMediaPath).exists()) {
    //   File(post.cacheMediaPath).delete();
    //   print('Successfully deleted ' + post.cacheMediaPath + ' cache');
    // }
  }

  Future<List<Comment>?> getListComment(String? postId) async {
    print("Request:::::: getListComment");
    QuerySnapshot postSnapshot;
    if (postId == null || postId == '') {
      postSnapshot = await FirebaseFirestore.instance.collection('Comment').orderBy('date').get();
    } else {
      postSnapshot =
          await FirebaseFirestore.instance.collection('Comment').where('postId', isEqualTo: postId).orderBy('date').get();
    }

    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((comment) => new Comment.fromJson(comment.data() as Map<String, dynamic>)).toList();
    }
  }

  Future<void> postComment(Comment newComment) async {
    print("Request:::::: postComment");
    final CollectionReference ref = FirebaseFirestore.instance.collection('Comment');
    ref.doc().set(newComment.toJson());
  }

  Future<List<Like>?> getAllLikes() async {
    print("Request:::::: getAllLikes");
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance.collection('Like').get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((like) => new Like.fromJson(like.data() as Map<String, dynamic>)).toList();
    }
  }

  Future<List<Like>?> getLikeByUser(String userId) async {
    print("Request:::::: getLikeByUser");
    QuerySnapshot postSnapshot =
        await FirebaseFirestore.instance.collection('Like').where('likedUserId', isEqualTo: userId).get();
    if (postSnapshot.docs.isEmpty) {
      return null;
    } else {
      return postSnapshot.docs.map((like) => new Like.fromJson(like.data() as Map<String, dynamic>)).toList();
    }
  }

  Future<void> updatePost(Post post) async {
    print("Request:::::: updatePost");
    FirebaseFirestore.instance.collection('Post').doc(post.docId).update(post.toJson());
  }

  Future<void> deleteComment(String? commentId) async {
    print("Request:::::: deleteComment");
    FirebaseFirestore.instance.collection('Comment').where("commentId", isEqualTo: commentId).get().then((snapshot) {
      snapshot.docs.first.reference.delete();
    });
  }

  Future<void> createActivity(Activity activity) async {
    print("Request:::::: createActivity");
    final CollectionReference ref = FirebaseFirestore.instance.collection('Activity');
    ref.doc().set(activity.toJson());
  }

  Future<void> updateActivity(Activity activity) async {
    print("Request:::::: updateActivity");
    FirebaseFirestore.instance.collection('Activity').doc(activity.docId).update(activity.toJson());
  }

  Future<String> uploadFile(File file, String path, String? type) async {
    print("Request:::::: uploadFile");
    type = type == 'image' ? 'image/jpeg' : 'video/mp4';
    print('File upload starting... ' + DateTime.now().toString());
    UploadTask fileUploadTask = FirebaseStorage.instance.ref().child(path).putFile(file, SettableMetadata(contentType: type));
    String downloadUrl = await (await fileUploadTask).ref.getDownloadURL();
    print('File upload success! ' + DateTime.now().toString());
    return downloadUrl;
  }

  Future<ChallengeSubmit> getChallengeSubmitByUser(String userId) async {
    print("Request:::::: getChallengeSubmitByUser");
    QuerySnapshot itemSnapshot =
        await FirebaseFirestore.instance.collection('Challenge_submits').where('userId', isEqualTo: userId).get();

    if (itemSnapshot.docs.isEmpty)
      return ChallengeSubmit.initial();
    else
      return ChallengeSubmit.fromJson(itemSnapshot.docs[0].data() as Map<String, dynamic>, itemSnapshot.docs[0].id);
  }

  Future<void> createChallengeSubmit(ChallengeSubmit submit) async {
    print("Request:::::: createChallengeSubmit");
    final CollectionReference ref = FirebaseFirestore.instance.collection('Challenge_submits');
    ref.doc().set(submit.toJson());
  }

  Future<void> updateChallengeSubmit(ChallengeSubmit submit) async {
    print("Request:::::: updateChallengeSubmit");
    FirebaseFirestore.instance.collection('Challenge_submits').doc(submit.docId).update(submit.toJson());
  }
}
