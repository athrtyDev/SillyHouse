import 'package:sillyhouseorg/core/classes/media.dart';

class Activity {
  String? docId;
  String? id;
  String? activityType; // diy, discover, dance
  bool? autoPlay;
  String? coverImageUrl; // get form storage
  String? difficulty; // 0-easy; 1-medium; 2-hard
  String? instruction;
  bool? isFeatured; // true if an activity featured on home screen
  bool? isActive;
  String? mediaUrlAll; // combined all media urls
  String? mediaUrlAllMeta; // combined all media urls' info
  String? name;
  int? skill; // biyluuleed awah onoo. Herew 0 baiwal app deer haruulahgui
  int? version; // cache version. Updates cache when version mismatches
  // tuslah
  int? age;
  int? postCount; // posts from other kids
  List<Media>? listMedia;
  String? cachePathCoverImg;
  //var rng = new Random();

  Activity copyWith({
    String? docId,
    String? id,
    String? activityType,
    bool? autoPlay,
    String? coverImageUrl,
    String? difficulty,
    String? instruction,
    bool? isFeatured,
    bool? isActive,
    String? mediaUrlAll,
    String? mediaUrlAllMeta,
    String? name,
    int? skill,
    int? version,
  }) {
    return Activity(
      docId: docId ?? this.docId,
      id: id ?? this.id,
      activityType: activityType ?? this.activityType,
      autoPlay: autoPlay ?? this.autoPlay,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      difficulty: difficulty ?? this.difficulty,
      instruction: instruction ?? this.instruction,
      isFeatured: isFeatured ?? this.isFeatured,
      isActive: isActive ?? this.isActive,
      mediaUrlAll: mediaUrlAll ?? this.mediaUrlAll,
      mediaUrlAllMeta: mediaUrlAllMeta ?? this.mediaUrlAllMeta,
      name: name ?? this.name,
      skill: skill ?? this.skill,
      version: version ?? this.version,
    );
  }

  Activity(
      {this.id,
      this.docId,
      this.name,
      this.version,
      this.isFeatured,
      this.instruction,
      this.skill,
      this.difficulty,
      this.postCount,
      this.coverImageUrl,
      this.autoPlay,
      this.activityType,
      this.mediaUrlAll,
      this.mediaUrlAllMeta,
      this.isActive,
      this.cachePathCoverImg});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    name = json['name'] ?? '';
    instruction = json['instruction'] ?? '';
    age = json['age'] != null ? int.tryParse(json['age'].toString()) : null;
    skill = json['skill'] != null ? int.tryParse(json['skill'].toString()) : null;
    difficulty = json['difficulty'] ?? '';
    postCount = json['postCount'] != null ? int.tryParse(json['postCount'].toString()) : null;
    mediaUrlAll = json['mediaUrlAll'] ?? null;
    mediaUrlAllMeta = json['mediaUrlAllMeta'] ?? null;
    coverImageUrl = json['coverImageUrl'] ?? null;
    autoPlay = json['autoPlay'] ?? false;
    version = json['version'] != null ? int.tryParse(json['version'].toString()) : 1;
    activityType = json['activityType'] ?? null;
    isFeatured = json['isFeatured'] ?? false;
    isActive = json['isActive'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['instruction'] = this.instruction;
    data['skill'] = this.skill;
    data['age'] = this.age;
    data['difficulty'] = this.difficulty;
    data['postCount'] = this.postCount;
    data['mediaUrlAll'] = this.mediaUrlAll;
    data['mediaUrlAllMeta'] = this.mediaUrlAllMeta;
    data['coverImageUrl'] = this.coverImageUrl;
    data['autoPlay'] = this.autoPlay;
    data['version'] = this.version;
    data['activityType'] = this.activityType;
    data['isFeatured'] = this.isFeatured;
    data['isActive'] = this.isActive;
    return data;
  }

  List<Media>? getListMedia() {
    if (listMedia == null) {
      if (mediaUrlAll == null || mediaUrlAll == "") return [];
      // aa.mp4;bb.mp4  => List[aa.mp4, bb.mp4]
      List<String> listUrlString = mediaUrlAll!.split(";");
      List<String> listUrlTypeString = mediaUrlAllMeta!.split(";");
      listMedia = [];
      for (int index = 0; index < listUrlString.length; index++) {
        Media media = new Media(url: listUrlString[index], type: listUrlTypeString[index]);
        listMedia!.add(media);
      }
    }
    return listMedia;
  }
}
