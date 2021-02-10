import 'package:DocScanner/screens/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Submit extends StatelessWidget {
  final images;
  Submit({this.images});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Obx(() => images.length > 0
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
                        //setState(() {});
                      },
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 170),
                      child: Container(
                        key: ValueKey(images.length),
                        child: Center(child: Text(images.length.toString())),
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
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
    );
  }
}
