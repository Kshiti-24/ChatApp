import 'dart:math';

import 'package:camera/camera.dart';
import 'package:convo/Screens/image_screen.dart';
import 'package:convo/Screens/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:convo/main.dart';

List<CameraDescription>? cameras;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  Future<void>? cameraValue;
  bool isRecording = false;
  bool isFlashOn = false;
  bool isCameraFront = false;
  double transform = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420);
    cameraValue = _cameraController!.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cameraController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(_cameraController!));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Positioned(
              bottom: 0.0,
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isFlashOn = !isFlashOn;
                              });
                              isFlashOn
                                  ? _cameraController!
                                      .setFlashMode(FlashMode.torch)
                                  : _cameraController!
                                      .setFlashMode(FlashMode.off);
                            },
                            icon: Icon(
                              isFlashOn ? Icons.flash_on : Icons.flash_off,
                              size: 28,
                              color: Colors.white,
                            )),
                        GestureDetector(
                          onLongPress: () async {
                            final path = join(
                                (await getTemporaryDirectory()).path,
                                "${DateTime.now}.mp4");
                            await _cameraController!.startVideoRecording();
                            setState(() {
                              isRecording = true;
                            });
                          },
                          onLongPressUp: () async {
                            final path = join(
                                (await getTemporaryDirectory()).path,
                                "${DateTime.now}.mp4");
                            XFile? video =
                                await _cameraController!.stopVideoRecording();
                            video.saveTo(path);
                            setState(() {
                              isRecording = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoScreen(
                                          path: path,
                                        )));
                          },
                          onTap: () async {
                            if (!isRecording) {
                              final path = join(
                                  (await getTemporaryDirectory()).path,
                                  "${DateTime.now}.png");
                              XFile picture =
                                  await _cameraController!.takePicture();
                              print(picture.path);
                              picture.saveTo(path);
                              log.d(picture.path);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageScreen(
                                            path: path,
                                          )));
                            }
                          },
                          child: isRecording
                              ? Icon(
                                  Icons.radio_button_on,
                                  color: Colors.red,
                                  size: 80,
                                )
                              : Icon(
                                  Icons.panorama_fish_eye,
                                  size: 70,
                                  color: Colors.white,
                                ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isCameraFront = !isCameraFront;
                                transform = transform + pi;
                              });
                              int cameraPos = isCameraFront ? 0 : 1;
                              _cameraController = CameraController(
                                  cameras![cameraPos], ResolutionPreset.high,
                                  imageFormatGroup: ImageFormatGroup.yuv420);
                              cameraValue = _cameraController!.initialize();
                            },
                            icon: Transform.rotate(
                              angle: transform,
                              child: Icon(
                                Icons.flip_camera_ios,
                                size: 28,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                    Text(
                      "Hold for video, tap for photo",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void takePhoto(BuildContext context) async {
    final path =
        join((await getTemporaryDirectory()).path, "${DateTime.now}.png");
    XFile picture = await _cameraController!.takePicture();
    picture.saveTo(path);
    print(picture.path);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ImageScreen()));
  }
}
