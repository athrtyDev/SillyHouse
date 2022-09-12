import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sillyhouseorg/core/services/tool.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class TakeProfilePicturePage extends StatefulWidget {
  @override
  _TakeProfilePicturePageState createState() => _TakeProfilePicturePageState();
}

class _TakeProfilePicturePageState extends State<TakeProfilePicturePage> with WidgetsBindingObserver {
  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  late CameraController _cameraController;
  Future<void>? _initializeCameraControllerFuture;
  String? whichCamera;
  var cameras;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    cameras = await availableCameras();
    setState(() {
      if (cameras == null || cameras.length == 0) return;
      WidgetsBinding.instance.addObserver(this);
      CameraDescription camera = cameras.length > 1 ? cameras[1] : cameras[0];
      whichCamera = cameras.length > 1 ? 'front' : 'back';
      _cameraController = CameraController(camera, ResolutionPreset.medium, imageFormatGroup: ImageFormatGroup.jpeg);
      _initializeCameraControllerFuture = _cameraController.initialize();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      // TODO pop screen when screen is locked. Camera causes issue.
      print('screen is inactive');
    }
  }

  void _selectMedia(BuildContext context, String type) async {
    final picker = ImagePicker();
    var pickedFile;
    if (type == 'image')
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    else
      pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    PickedMedia media = new PickedMedia();
    media.type = type;
    //media.storageFile = await Tool.compressImage(File(pickedFile.path));
    media.storageFile = File(pickedFile.path);
    Navigator.pop(context, media);
  }

  void _takePicture(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;
      imageCache.clear();
      PickedMedia media = new PickedMedia();
      XFile fileImage = await _cameraController.takePicture();
      print('new image path: ' + fileImage.path);
      media.path = fileImage.path;
      media.type = 'image';
      media.storageFile = await Tool.compressImage(File(fileImage.path));
      Navigator.pop(context, media);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
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
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
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
                          CameraDescription camera = cameras[1];
                          whichCamera = 'front';
                          _cameraController = CameraController(camera, ResolutionPreset.medium);
                          _initializeCameraControllerFuture = _cameraController.initialize();
                        } else {
                          CameraDescription camera = cameras[0];
                          whichCamera = 'back';
                          _cameraController = CameraController(camera, ResolutionPreset.medium);
                          _initializeCameraControllerFuture = _cameraController.initialize();
                        }
                      });
                    },
                  ),
                  FloatingActionButton(
                    heroTag: 2,
                    backgroundColor: Styles.baseColor1,
                    child: Icon(Icons.camera, color: Colors.white),
                    onPressed: () {
                      _takePicture(context);
                    },
                  ),
                  FloatingActionButton(
                    heroTag: 3,
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.image, color: Colors.white, size: 30),
                    onPressed: () {
                      _selectMedia(context, 'image');
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
