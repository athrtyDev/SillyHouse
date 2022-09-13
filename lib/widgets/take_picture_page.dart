import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/core/services/tool.dart';
import 'package:sillyhouseorg/utils/media_controller.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class TakePicturePage extends StatefulWidget {
  final Post? post;

  TakePicturePage({required this.post});

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> with WidgetsBindingObserver {
  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //var vidPath;
  late CameraController _cameraController;
  Future<void>? _initializeCameraControllerFuture;
  int _selectedIndex = 0;
  bool _start = false;
  bool _isRec = false;
  String? whichCamera;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        _start = !_start;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    CameraDescription camera = widget.post!.cameras[0];
    whichCamera = 'back';
    _cameraController = CameraController(camera, ResolutionPreset.medium, imageFormatGroup: ImageFormatGroup.jpeg);
    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      // TODO pop screen when screen is locked. Camera causes issue.
      print('screen is inactive');
    }
  }

  _selectMedia() async {
    MyMediaObject? media = await mediaController.galleryPicker();
    if (media == null) return;
    widget.post!.pickedMedia = media;
    Navigator.pushNamed(context, '/publish', arguments: widget.post);
  }

  void _takePicture(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;
      imageCache.clear();
      if (_selectedIndex == 0) {
        //final imgPath = join((await getTemporaryDirectory()).path, (fileName + ".jpeg"));
        //XFile fileImage = XFile(imgPath);
        XFile fileImage = await _cameraController.takePicture();

        print('new image path: ' + fileImage.path);
        MyMediaObject media = new MyMediaObject(
          path: fileImage.path,
          type: 'image',
          storageFile: await Tool.compressImage(File(fileImage.path)),
        );
        widget.post!.pickedMedia = media;
        widget.post!.pickedMedia!.isSelfie = whichCamera == "front";
        Navigator.pushNamed(context, '/publish', arguments: widget.post);
      } else {
        if (_start) {
          //await _cameraController.startVideoRecording(vidPath);
          await _cameraController.startVideoRecording();
          setState(() {
            _start = !_start;
            _isRec = !_isRec;
          });
        } else {
          XFile file = await _cameraController.stopVideoRecording();
          setState(() {
            _start = !_start;
            _isRec = !_isRec;
          });
          MyMediaObject media = new MyMediaObject(
            path: file.path,
            type: 'video',
            storageFile: File(file.path),
          );
          widget.post!.pickedMedia = media;
          //Navigator.pop(context, media);
          Navigator.pushNamed(context, '/publish', arguments: widget.post);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  FutureBuilder(
                    future: _initializeCameraControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_cameraController);
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  _isRec == true
                      ? SafeArea(
                          child: Container(
                            height: 40,
                            // alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Color(0xFFEE4400),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "Бичиж байна",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFFFAFAFA)),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(height: 0),
                  Positioned(
                      top: 50,
                      right: 30,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.close_rounded, color: Styles.textColor),
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _onItemTapped(0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      height: 40,
                      width: 120,
                      child: Center(
                          child:
                              Text('Зураг', style: GoogleFonts.kurale(color: _selectedIndex == 0 ? Colors.black : Colors.white))),
                    ),
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      _onItemTapped(1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      height: 40,
                      width: 120,
                      child: Center(
                          child: Text('Бичлэг',
                              style: GoogleFonts.kurale(color: _selectedIndex == 1 ? Colors.black : Colors.white))),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 1,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.autorenew, color: Colors.white, size: 30),
                    onPressed: () {
                      setState(() {
                        if (whichCamera == 'back') {
                          CameraDescription camera = widget.post!.cameras[1];
                          whichCamera = 'front';
                          _cameraController = CameraController(camera, ResolutionPreset.high);
                          _initializeCameraControllerFuture = _cameraController.initialize();
                        } else {
                          CameraDescription camera = widget.post!.cameras[0];
                          whichCamera = 'back';
                          _cameraController = CameraController(camera, ResolutionPreset.high);
                          _initializeCameraControllerFuture = _cameraController.initialize();
                        }
                      });
                    },
                  ),
                  FloatingActionButton(
                    heroTag: 2,
                    backgroundColor: Styles.baseColor1,
                    child: _selectedIndex == 1
                        ? _isRec == true
                            ? Icon(Icons.pause, color: Colors.white)
                            : Icon(Icons.play_arrow, color: Colors.white)
                        : Icon(Icons.camera, color: Colors.white),
                    onPressed: () {
                      _takePicture(context);
                    },
                  ),
                  FloatingActionButton(
                    heroTag: 3,
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.image, color: Colors.white, size: 30),
                    onPressed: () {
                      _selectMedia();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
