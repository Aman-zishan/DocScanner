import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import './generate.dart';
import '../shared/cdrawer.dart';

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

class TakePictureScreenState extends State<TakePictureScreen> {
  List<String> images = List<String>();

  //images = ['jithin'];

  bool done = false;
  int count = 0;
  CameraController _controller;
  Future<void> _initializeControllerFuture;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DocScanner',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[],
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.black),
      ),

      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.lightBlueAccent,

            child: Icon(
              Icons.camera_alt,
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
                await _controller.takePicture(path);
                print("path : $path");

                images.add(path);

                print('done1 : $done');
                if (images.isNotEmpty) {
                  setState(() {
                    done = true;
                    count++;
                  });

                  print('image path : $images');
                  print('done2 : $done');
                  //images.add(path);
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

      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.

        elevation: 1.5,
        child: CDrawer(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 150,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.filter_b_and_w,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top:50),
                    alignment: Alignment.center,
                    child: done
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                              IconButton(
                              icon: Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                              iconSize: 40,
                              onPressed: () {
                                // If the picture was taken, display it on a new screen.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GeneratePage(imagePath: images),
                                  ),
                                );
                              },
                            ),
                             Container(child: Center(child: Text(count.toString())),width: 17,height: 17,decoration: BoxDecoration(color: Colors.green,shape: BoxShape.circle),),
                          ],
                          )
                        : Icon(
                            Icons.done,
                            color: Colors.black,
                            size: 30,
                          )),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.filter,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        color: Colors.white,
      ),
    );
  }
}
