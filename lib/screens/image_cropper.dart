import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'generate.dart';

class CropperPage extends StatefulWidget {
  final List imagePath;
  const CropperPage({Key key, this.imagePath}) : super(key: key);

  @override
  _CropperPageState createState() => _CropperPageState();
}

// A widget that displays the picture taken by the user.
@override
class _CropperPageState extends State<CropperPage> {
  int currIndex = 0;
  double scale;
  double _scaleFactor = 1.0;
  double _prevScaleFactor = 1.0;
  ScrollPhysics pagePhysics;
  PageController pageController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    pagePhysics = NeverScrollableScrollPhysics();
  }

  Widget imageBody(double _height, double _width, String image) {
    Widget body;
    if (isEditing) {
      body = Container(
        child: ExtendedImage.file(
          File(image),
          fit: BoxFit.cover,
          mode: ExtendedImageMode.gesture,
          onDoubleTap: (_) {
            print("double tap");
          },
          initGestureConfigHandler: (imageState) {
            return GestureConfig(
                minScale: 1.0,
                gestureDetailsIsChanged: (details) {
                  _prevScaleFactor = _scaleFactor;
                  _scaleFactor = details.totalScale;

                  if (!(_prevScaleFactor < 1.071 && _scaleFactor < 1.071)) {
                    setState(() {
                      pagePhysics = NeverScrollableScrollPhysics();
                    });
                  } else {
                    setState(() {
                      pagePhysics = BouncingScrollPhysics();
                    });
                  }
                });
          },
        ),
      );
    } else {
      body = Container(
        // padding: EdgeInsets.fromLTRB(5, 47, 5, 17),
        child: ExtendedImage.file(
          File(image),
          fit: BoxFit.cover,
          mode: ExtendedImageMode.gesture,
          onDoubleTap: (_) {
            print("double tap");
          },
          initGestureConfigHandler: (imageState) {
            return GestureConfig(
                minScale: 1.0,
                gestureDetailsIsChanged: (details) {
                  _prevScaleFactor = _scaleFactor;
                  _scaleFactor = details.totalScale;

                  if (!(_prevScaleFactor < 1.071 && _scaleFactor < 1.071)) {
                    setState(() {
                      pagePhysics = NeverScrollableScrollPhysics();
                    });
                  } else {
                    setState(() {
                      pagePhysics = BouncingScrollPhysics();
                    });
                  }
                });
          },
        ),
      );
    }
    return body;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 310),
            child: isEditing
                ? Container(
                    key: ValueKey(isEditing.toString() + "delete"),
                  )
                : Tooltip(
                    key: ValueKey(isEditing.toString() + "delete"),
                    message: "delete",
                    child: IconButton(
                        // padding: EdgeInsets.fromLTRB(31, 0, 17, 0),
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          print("edit");
                          setState(() {
                            widget.imagePath.removeAt(currIndex);
                            currIndex -= 1;
                            if (widget.imagePath.length == 0) {
                              Navigator.of(context).pop();
                            }
                          });
                        }),
                  ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 310),
            child: Tooltip(
              key: ValueKey(isEditing.toString() + "edit"),
              message: "edit",
              child: IconButton(
                  // padding: EdgeInsets.fromLTRB(31, 0, 17, 0),
                  icon: isEditing ? Icon(Icons.done) : Icon(Icons.edit),
                  onPressed: () async {
                    print("edit");
                    ImageCropper.cropImage(
                        sourcePath: widget.imagePath[currIndex],
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio3x2,
                          CropAspectRatioPreset.original,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio16x9
                        ],
                        androidUiSettings: AndroidUiSettings(
                            toolbarTitle: 'Cropper',
                            toolbarColor: Colors.black,
                            toolbarWidgetColor: Colors.white,
                            activeControlsWidgetColor: Colors.red,
                            hideBottomControls: false,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false),
                        iosUiSettings: IOSUiSettings(
                          minimumAspectRatio: 1.0,
                        )).then((newImagePath) {
                      if (newImagePath != null) {
                        widget.imagePath[currIndex] = newImagePath.path;
                        setState(() {
                          // isEditing = !isEditing;
                        });
                      }
                    });
                  }),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: pagePhysics,
            children: widget.imagePath.map((image) {
              return imageBody(_height, _width, image);
            }).toList(),
            onPageChanged: (int newIndex) {
              // setState(() {
              //   currIndex = newIndex;
              // });
              currIndex = newIndex;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.fast_rewind_outlined,
                size: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.fast_forward_outlined,
                size: 40,
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          // Inkwell is used for long press method
          child: InkWell(
            highlightColor: Colors.red,
            child: FloatingActionButton(
              backgroundColor: Colors.greenAccent,

              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
              // Provide an onPressed callback.
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GeneratePage(imagePath: widget.imagePath),
                  ),
                );
              },
              elevation: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
