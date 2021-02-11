import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'package:DocScanner/controller/takepicture_controller.dart';
import 'package:DocScanner/screens/take_picture/filter.dart';
import 'package:DocScanner/screens/take_picture/gridView.dart';
import 'package:DocScanner/screens/take_picture/submit.dart';
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
import 'package:DocScanner/screens/about.dart';

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
  final TakePikcController controller = Get.put(TakePikcController());

  CameraController _controller;
  Future<void> _initializeControllerFuture;
  final bugController = TextEditingController();
  double size = 14;
  double _currentOpacity = 0.0;
  var images = [].obs;

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
              return GetBuilder<TakePikcController>(
                init: TakePikcController(),
                builder: (_) {
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // If the Future is complete, display the preview.
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 170),
                        child: _.isGrayScale
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
                      if (_.gridView) gridView()
                    ],
                  );
                },
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
                if (images.isNotEmpty) {
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
                  setState(() {});
                }
              },
              child: GetBuilder<TakePikcController>(
                init: TakePikcController(),
                builder: (_) {
                  return FloatingActionButton(
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
                            if (_.isGrayScale) {
                              imgLib.Image originalImage =
                                  imgLib.decodeImage(value);
                              imgLib.Image grayImage =
                                  imgLib.grayscale(originalImage);
                              grayImage = imgLib.copyRotate(grayImage, 0);
                              File(path).writeAsBytesSync(
                                  imgLib.encodePng(grayImage));
                            }
                          });
                        });

                        images.add(path);
                        setState(() {});
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                    elevation: 2.0,
                  );
                },
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
                Filter(),
                Gridvieww(),
                Submit(images: images),
                Expanded(
                  child: IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutPage(),
                      ),
                    ),
                    icon: Icon(
                      Icons.info_outlined,
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
