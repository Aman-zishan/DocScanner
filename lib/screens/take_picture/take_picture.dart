import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:DocScanner/custom_widgets/ExitPopUp.dart';
import 'package:DocScanner/custom_widgets/grdview.dart';
import 'package:DocScanner/screens/image_cropper.dart';
import 'package:DocScanner/screens/take_picture/bugreportmail.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imgLib;
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with SingleTickerProviderStateMixin {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  final bugController = TextEditingController();
  double size = 14;
  double _currentOpacity = 0.0;
  var gridviewstate = false;
  bool done = false;
  bool isGrayScale = false;
  // int count = 0;
  List<String> images = List<String>();

  Color selectedColor = Colors.black;

  void showgrid() {
    gridviewstate = !gridviewstate;
  }

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    //showing popup message exiting app
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return exitPopUp(context);
            });
      },

      child: Scaffold(
        // Wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner
        // until the controller has finished initializing.

        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // If the Future is complete, display the preview.

                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 170),
                    child: isGrayScale
                        ? ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.grey, BlendMode.saturation),
                            key: ValueKey("grayscaleFalse"),
                            child: CameraPreview(_controller))
                        : Container(
                            key: ValueKey("grayscaleTrue"),
                            child: CameraPreview(_controller)),
                  ),

                  //reset message center of screen animation

                  AnimatedSize(
                    vsync: this,
                    //curve: Curves.easeOut,
                    duration: Duration(milliseconds: 500),
                    child: AnimatedOpacity(
                      opacity: _currentOpacity,
                      duration: Duration(milliseconds: 1000),
                      child: Text('reset successful',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: size)),
                    ),
                  ),
                  if (gridviewstate) gridView()
                ],
              );
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 70.0,
          width: 70.0,
          child: FittedBox(
            // Inkwell is used for long press method
            child: InkWell(
              highlightColor: Colors.red,
              onLongPress: () {
                // reseting captured images
                setState(() {
                  done = false;
                  images.clear();
                  size = 24;
                  _currentOpacity = 1.0;
                  Timer(Duration(milliseconds: 1100), () {
                    setState(() {
                      _currentOpacity = 0.0;
                    });
                  });
                  Timer(Duration(milliseconds: 2200), () {
                    setState(() {
                      size = 14;
                    });
                  });
                  //count = 0;
                });
              },
              child: FloatingActionButton(
                backgroundColor: Colors.lightBlueAccent,

                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                // Provide an onPressed callback.
                onPressed: () async {
                  // Take the Picture in a try / catch block. If anything goes wrong,
                  // catch the error.
                  try {
                    // Ensure that the camera is initialized.

                    await _initializeControllerFuture;

                    // Construct the path where the image should be saved using the
                    // pattern package.
                    final path = join(
                      // Store the picture in the temp directory.
                      // Find the temp directory using the `path_provider` plugin.
                      (await getTemporaryDirectory()).path,
                      '${DateTime.now()}.png',
                    );

                    // Attempt to take a picture and log where it's been saved.
                    await _controller.takePicture(path).then((value) {
                      print(File(path).existsSync());
                      File(path).readAsBytes().then((value) {
                        if (isGrayScale) {
                          imgLib.Image originalImage =
                              imgLib.decodeImage(value);
                          imgLib.Image grayImage =
                              imgLib.grayscale(originalImage);
                          grayImage = imgLib.copyRotate(grayImage, 0);
                          File(path)
                              .writeAsBytesSync(imgLib.encodePng(grayImage));
                        }
                      });
                    });

                    images.add(path);
                    if (images.isNotEmpty) {
                      setState(() {
                        done = true;
                        // count++;
                      });
                    }
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                },
                elevation: 2.0,
              ),
            ),
          ),
        ),

        // drawer: Drawer(
        //   // Add a ListView to the drawer. This ensures the user can scroll
        //   // through the options in the drawer if there isn't enough vertical
        //   // space to fit everything.
        //
        //   elevation: 1.5,
        //   child: CDrawer(),
        // ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 110,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isGrayScale = !isGrayScale;
                      });
                    },
                    icon: Icon(
                      Icons.filter_b_and_w,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.grid_on,
                      size: 30,
                    ),
                    color: selectedColor,
                    onPressed: () => {
                      showgrid(),
                      setState(
                        () {
                          if (selectedColor == Colors.blue) {
                            selectedColor = Colors.black;
                          } else {
                            selectedColor = Colors.blue;
                          }
                        },
                      ),
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: images.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ),
                                    iconSize: 40,
                                    onPressed: () async {
                                      // If the picture was taken, display it on a new screen.
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         GeneratePage(imagePath: images),
                                      //   ),
                                      // );
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CropperPage(imagePath: images),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  AnimatedSwitcher(
                                    duration: Duration(milliseconds: 170),
                                    child: Container(
                                      key: ValueKey(images.length),
                                      child: Center(
                                          child:
                                              Text(images.length.toString())),
                                      width: 17,
                                      height: 17,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Icon(
                              Icons.done,
                              color: Colors.black,
                              size: 30,
                            )),
                ),
                //Expanded(child: SizedBox(width: 20.0)),

                Expanded(
                  child: IconButton(
                    onPressed: () => null,
                    icon: Icon(
                      Icons.filter,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),

                BugReportMail()
              ],
            ),
          ),
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
