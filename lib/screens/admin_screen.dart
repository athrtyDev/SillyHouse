import 'dart:async';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/classes/media.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/utils/media_controller.dart';
import 'package:sillyhouseorg/widgets/button.dart';
import 'package:sillyhouseorg/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/widgets/my_text_field.dart';
import 'package:sillyhouseorg/widgets/styles.dart';
import 'package:sillyhouseorg/widgets/activity_tile.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with TickerProviderStateMixin {
  final Api? _api = Api();
  Map<String?, List<Activity>?>? mapActivity;
  List<ActivityType>? listType;
  String? selectedTab;
  ScrollController? scrollViewController;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    initAdminData();
    scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollViewController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mapActivity == null
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            top: false,
            child: Scaffold(
              appBar: myAppBar(title: "Admin panel"),
              backgroundColor: Styles.backgroundColor,
              body: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    _tabs(),
                    Divider(height: 20, thickness: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GridView.count(
                              controller: scrollViewController,
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              children: mapActivity![selectedTab]!.map((Activity activity) {
                                return ActivityTile(
                                  activity: activity,
                                  color: Styles.whiteColor,
                                  onTap: () {
                                    showDetail(activity);
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                // isExtended: true,
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
                onPressed: () {
                  showDetail(new Activity());
                },
              ),
            ),
          );
  }

  _tabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (String? key in mapActivity!.keys)
          InkWell(
            onTap: () {
              setState(() {
                selectedTab = key;
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                padding: EdgeInsets.all(10),
                color: selectedTab == key ? Styles.baseColor1 : Styles.backgroundColor,
                child: Text(key!),
              ),
            ),
          )
      ],
    );
  }

  initAdminData() async {
    List<Activity>? allActivity = await _api!.getAllActivity();
    app.allActivity = allActivity;
    listType = await _api!.getActivityType();
    mapActivity = new Map<String?, List<Activity>?>();
    for (Activity item in allActivity!) {
      if (item.isActive!) {
        // Group by featured
        if (item.isFeatured!) {
          List<Activity>? listFeatured;
          if (mapActivity!.containsKey('Featured'))
            listFeatured = mapActivity!['Featured'];
          else
            listFeatured = [];
          listFeatured!.add(item);
          mapActivity!['Featured'] = listFeatured;
        }
        // Group by activityType
        List<Activity>? list;
        if (mapActivity!.containsKey(item.activityType))
          list = mapActivity![item.activityType];
        else
          list = [];
        list!.add(item);
        mapActivity![item.activityType] = list;
      } else {
        // Group by disabled
        List<Activity>? listDisabled;
        if (mapActivity!.containsKey('Disabled'))
          listDisabled = mapActivity!['Disabled'];
        else
          listDisabled = [];
        listDisabled!.add(item);
        mapActivity!['Disabled'] = listDisabled;
      }
    }
    setState(() {
      mapActivity;
      selectedTab = mapActivity!.keys.first;
    });
  }

  showDetail(Activity selectedActivity) {
    String? _type = selectedActivity.activityType;
    bool? _autoPlay = selectedActivity.autoPlay ?? true;
    String? _difficulty = selectedActivity.difficulty;
    TextEditingController _id = TextEditingController();
    _id.text = selectedActivity.id ?? "";
    TextEditingController _instruction = TextEditingController();
    _instruction.text = selectedActivity.instruction ?? "";
    bool? _isActive = selectedActivity.isActive ?? true;
    bool? _isFeatured = selectedActivity.isFeatured ?? false;
    TextEditingController _name = TextEditingController();
    _name.text = selectedActivity.name ?? "";
    TextEditingController _skill = TextEditingController();
    _skill.text = selectedActivity.skill == null ? "" : selectedActivity.skill.toString();
    int _version = (selectedActivity.version ?? 0) + 1;
    //cover
    String? _coverUrl = selectedActivity.coverImageUrl;
    Media? pickedMediaCover;
    //media
    List<Media> listMedia = [];
    for (var item in selectedActivity.getListMedia()!) listMedia.add(item);
    listMedia.add(new Media());
    int _carouselIndex = 0;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
            return ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.88,
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          child: Text('close'),
                          color: Styles.backgroundColor,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Text("id")),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: _id,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Text("Name")),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: _name,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Text("Instruction")),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: _instruction,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Text("Skill")),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: _skill,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    //crossAxisAlignment: CrossAxisAlignment.,
                    children: [
                      for (var item in listType!)
                        InkWell(
                          onTap: () {
                            myState(() {
                              _type = item.type;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(right: 15),
                              color: _type == item.type ? Styles.baseColor1 : Styles.backgroundColor,
                              child: Text(item.name!)),
                        ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          myState(() {
                            _difficulty = "easy";
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 15),
                            color: _difficulty == "easy" ? Styles.baseColor1 : Styles.backgroundColor,
                            child: Text("easy")),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          myState(() {
                            _difficulty = "medium";
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 15),
                            color: _difficulty == "medium" ? Styles.baseColor1 : Styles.backgroundColor,
                            child: Text("medium")),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          myState(() {
                            _difficulty = "hard";
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 15),
                            color: _difficulty == "hard" ? Styles.baseColor1 : Styles.backgroundColor,
                            child: Text("hard")),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Featured"),
                      Checkbox(
                        value: _isFeatured,
                        onChanged: (bool? value) {
                          myState(() {
                            _isFeatured = value;
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      Text("Auto play"),
                      Checkbox(
                        value: _autoPlay,
                        onChanged: (bool? value) {
                          myState(() {
                            _autoPlay = value;
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      Text("Active"),
                      Checkbox(
                        value: _isActive,
                        onChanged: (bool? value) {
                          myState(() {
                            _isActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Text("Cover image"),
                  SizedBox(height: 5),
                  Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        pickedMediaCover != null || _coverUrl != null
                            ? Container(
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                                child: (pickedMediaCover == null
                                    ? CachedNetworkImage(
                                        imageUrl: _coverUrl ?? "",
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => Container(height: 100, color: Colors.amber),
                                      )
                                    : Image.file(pickedMediaCover!.file!, fit: BoxFit.cover)),
                              )
                            : Center(
                                child: InkWell(
                                  onTap: () async {
                                    Media temp = await _selectMedia('image');
                                    myState(() {
                                      pickedMediaCover = temp;
                                      //_coverUrl = pickedMediaCover.storageFile.path;
                                    });
                                  },
                                  child: Container(
                                    color: Styles.backgroundColor,
                                    padding: EdgeInsets.all(8),
                                    child: Text('add cover'),
                                  ),
                                ),
                              ),
                        Positioned(
                            right: 10,
                            top: 10,
                            child: InkWell(
                              onTap: () {
                                myState(() {
                                  _coverUrl = null;
                                  pickedMediaCover = null;
                                });
                              },
                              child: Container(
                                color: Styles.backgroundColor,
                                padding: EdgeInsets.all(8),
                                child: Text('x'),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Instructions"),
                  SizedBox(height: 5),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        myState(() {
                          _carouselIndex = index;
                        });
                      },
                    ),
                    items: listMedia.map((media) {
                      TextEditingController youtubeInput = TextEditingController();
                      return Builder(
                        builder: (BuildContext mediaContext) {
                          return Stack(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                                  child: media.type != null
                                      ? (media.type == 'video'
                                          ?
                                          // VIDEO
                                          Container(
                                              height: 300, color: Colors.blueGrey, child: Center(child: Text('Video uploaded')))
                                          : media.type == "youtube"
                                              ? // youtube
                                              Container(
                                                  height: 300,
                                                  color: Colors.blueGrey,
                                                  child: Center(child: Text(media.url ?? "...")))
                                              :
                                              // IMAGE
                                              media.url != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: media.url!,
                                                      fit: BoxFit.fill,
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                    )
                                                  : Image.file(media.file!, fit: BoxFit.cover))
                                      : Container(
                                          height: 300,
                                          color: Colors.grey,
                                          child: Center(
                                              child: Column(
                                            children: [
                                              SizedBox(height: 50),
                                              Text('шинээр нэмэх'),
                                              SizedBox(height: 15),
                                              InkWell(
                                                  onTap: () async {
                                                    Media newMedia = await _selectMedia('image');
                                                    myState(() {
                                                      listMedia.removeLast();
                                                      listMedia.add(newMedia);
                                                      listMedia.add(new Media());
                                                    });
                                                  },
                                                  child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      color: Colors.orange,
                                                      child: Center(child: Text('image')))),
                                              SizedBox(height: 15),
                                              InkWell(
                                                  onTap: () async {
                                                    Media newMedia = await _selectMedia('video');
                                                    myState(() {
                                                      listMedia.removeLast();
                                                      listMedia.add(newMedia);
                                                      listMedia.add(new Media());
                                                    });
                                                  },
                                                  child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      color: Colors.lightBlueAccent,
                                                      child: Center(child: Text('video')))),
                                              SizedBox(height: 15),
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextField(
                                                        controller: youtubeInput,
                                                        decoration: InputDecoration(
                                                          fillColor: Styles.whiteColor,
                                                          filled: true,
                                                          hintText: "Youtube link here...",
                                                          hintStyle: TextStyle(
                                                            fontFamily: 'NunitoSans',
                                                            fontWeight: Styles.wSemiBold,
                                                            fontSize: Styles.medium,
                                                            color: Styles.textColor50,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Button(
                                                      text: 'upload',
                                                      onTap: () {
                                                        Media newMedia = Media(
                                                          url: youtubeInput.text,
                                                          type: "youtube",
                                                        );
                                                        myState(() {
                                                          listMedia.removeLast();
                                                          listMedia.add(newMedia);
                                                          listMedia.add(new Media());
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )))),
                              media.type != null
                                  ? Positioned(
                                      right: 10,
                                      top: 10,
                                      child: InkWell(
                                        onTap: () {
                                          myState(() {
                                            listMedia.remove(listMedia[_carouselIndex]);
                                          });
                                        },
                                        child: Container(
                                          color: Styles.backgroundColor,
                                          padding: EdgeInsets.all(10),
                                          child: Text('x'),
                                        ),
                                      ))
                                  : SizedBox(),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 400),
                  Container(
                    height: 60,
                    child: isUpdating
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Styles.baseColor1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, color: Colors.white, size: 23),
                                SizedBox(width: 8),
                                Text('upload', style: GoogleFonts.kurale(fontSize: 16, color: Colors.white)),
                              ],
                            ),
                            onPressed: () async {
                              //try {
                              myState(() {
                                isUpdating = true;
                              });
                              Activity newActivity = Activity(
                                id: _id.text.toString(),
                                activityType: _type,
                                autoPlay: _autoPlay,
                                difficulty: _difficulty,
                                instruction: _instruction.text,
                                isActive: _isActive,
                                isFeatured: _isFeatured,
                                name: _name.text.toString(),
                                skill: int.tryParse(_skill.text.toString()) ?? 0,
                                version: _version,
                                coverImageUrl: _coverUrl,
                              );
                              // Cover
                              String? newCoverUrl;
                              if (newActivity.coverImageUrl == null && pickedMediaCover != null) {
                                // New cover upload
                                newCoverUrl = await _api!.uploadFile(pickedMediaCover!.file!,
                                    "activity_${newActivity.activityType}/${newActivity.id}/cover", "image");
                              }
                              // Instructions
                              String mediaUrlAll = "";
                              String mediaUrlAllMeta = "";
                              int index = 0;
                              for (Media media in listMedia) {
                                if (media.type != null) {
                                  index++;
                                  if (media.url != null) {
                                    mediaUrlAll += "${media.url};";
                                    mediaUrlAllMeta += "${media.type};";
                                  } else if (media.file != null) {
                                    String newMediaUrl = await _api!.uploadFile(media.file!,
                                        "activity_${newActivity.activityType}/${newActivity.id}/${index}", media.type);
                                    mediaUrlAll += "${newMediaUrl};";
                                    mediaUrlAllMeta += "${media.type};";
                                  }
                                }
                              }
                              mediaUrlAll =
                                  mediaUrlAll.length > 0 ? mediaUrlAll.substring(0, mediaUrlAll.length - 1) : mediaUrlAll;
                              mediaUrlAllMeta = mediaUrlAllMeta.length > 0
                                  ? mediaUrlAllMeta.substring(0, mediaUrlAllMeta.length - 1)
                                  : mediaUrlAllMeta;
                              // Create activity
                              newActivity.coverImageUrl = newActivity.coverImageUrl ?? newCoverUrl;
                              newActivity.mediaUrlAll = mediaUrlAll;
                              newActivity.mediaUrlAllMeta = mediaUrlAllMeta;
                              if (selectedActivity.docId == null)
                                _api!.createActivity(newActivity);
                              else {
                                newActivity.docId = selectedActivity.docId;
                                _api!.updateActivity(newActivity);
                              }
                              await initAdminData();
                              myState(() {
                                isUpdating = false;
                              });
                              Navigator.of(context).pop();
                              Flushbar(
                                message: 'Амжилттай',
                                padding: EdgeInsets.all(25),
                                backgroundColor: Styles.baseColor1,
                                duration: Duration(seconds: 3),
                              )..show(context);
                              // } on Exception catch (e) {
                              //   print('error uploading ' + e.toString());
                              //   Flushbar(
                              //     message: 'Алдаа гарлаа. ${e.toString()}',
                              //     padding: EdgeInsets.all(25),
                              //     backgroundColor: Styles.baseColor1,
                              //     duration: Duration(seconds: 3),
                              //   )..show(context);
                              // }
                            },
                          ),
                  ),
                ])),
              ),
            );
          });
        });
  }

  Future<Media> _selectMedia(String type) async {
    MyMediaObject? obj = await mediaController.galleryPicker();
    Media media = new Media();
    media.type = type;
    media.file = obj!.storageFile;
    return media;
  }
}
