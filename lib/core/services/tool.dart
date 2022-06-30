import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/media.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class Tool {
  static String? nullEmptyString(String? s) {
    if (s == null || s == '')
      return null;
    else
      return s;
  }

  static String convertDoubleToString(double d) {
    return d.toStringAsFixed(d.truncateToDouble() == d ? 0 : 2);
  }

  static Future<File?> compressImage(File file) async {
    try {
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = dir.absolute.path + "/temp.jpg";
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 50,
      );
      return result;
    } on Exception catch (e) {
      print("error on compress image: $e");
      return file;
    }
  }

  static Future download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  static Future<String?> cacheActivity(Activity activity, String path, Dio dio) async {
    try {
      // Template: cache/discover4_v1_cover.png
      String fullPath = path + "/" + activity.activityType! + activity.id! + "_v" + activity.version.toString() + "_cover.png";
      // check if file is cached already
      if (await File(fullPath).exists()) {
        print('cacheeee EXISTS: ' + fullPath);
      } else {
        print('cacheeee file not exists. downloading: ' + fullPath);
        await download(dio, activity.coverImageUrl!, fullPath);
        // clear previous cache with outdated version
        if (activity.version! > 1) {
          String checkPath =
              path + "/" + activity.activityType! + activity.id! + "_v" + (activity.version! - 1).toString() + "_cover.png";
          if (await File(checkPath).exists()) {
            print('cacheeee deleting: ' + checkPath);
            File(checkPath).delete();
          }
        }
      }
      return fullPath;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> cacheMedia(Activity activity, Media media, int mediaCount, String path, Dio dio) async {
    try {
      // Template: cache/discover4_v1_media1.png
      String fullPath = path +
          "/" +
          activity.activityType! +
          activity.id! +
          "_v" +
          activity.version.toString() +
          "_media" +
          mediaCount.toString() +
          (media.type == 'image' ? ".png" : ".mp4");
      // check if file is cached already
      if (await File(fullPath).exists()) {
        print('cacheeee EXISTS: ' + fullPath);
      } else {
        print('cacheeee file not exists. downloading: ' + fullPath);
        await download(dio, media.url!, fullPath);
        // clear previous cache with outdated version
        if (activity.version! > 1) {
          String checkPath = path +
              "/" +
              activity.activityType! +
              activity.id! +
              "_v" +
              (activity.version! - 1).toString() +
              "_media" +
              mediaCount.toString() +
              (media.type == 'image' ? ".png" : ".mp4");
          if (await File(checkPath).exists()) {
            print('cacheeee deleting: ' + checkPath);
            File(checkPath).delete();
          }
        }
      }
      return fullPath;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> cachePost(Post post) async {
    try {
      var cacheDir = await (getExternalCacheDirectories() as FutureOr<List<Directory>>);
      String path = cacheDir.first.path;
      var dio = Dio();
      // post93defbb6-3a65-4a7b-8c09-905e6af9f1c1
      String fullPath = path + "/post" + post.postId!;
      // check if file is cached already
      if (await File(fullPath).exists()) {
        print('cacheeee EXISTS: ' + fullPath);
      } else {
        print('cacheeee file not exists. downloading: ' + fullPath);
        await download(dio, post.mediaDownloadUrl!, fullPath);
      }
      return fullPath;
    } catch (e) {
      print("Tool cachePost error: " + e.toString());
      return null;
    }
  }

  static Future<void> cacheNewPublishedPost(String postId, var fileBytes) async {
    // post93defbb6-3a65-4a7b-8c09-905e6af9f1c1
    var cacheDir = await (getExternalCacheDirectories() as FutureOr<List<Directory>>);
    String path = cacheDir.first.path;
    String fullPath = path + "/post" + postId;
    await File(fullPath).writeAsBytes(fileBytes);
    print('cached new file: ' + fullPath);
  }
}
