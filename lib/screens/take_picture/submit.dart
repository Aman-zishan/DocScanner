import 'package:DocScanner/screens/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Submit extends StatefulWidget {
  final List images;
  Submit({this.images});

  @override
  _SubmitState createState() => _SubmitState();
}

class _SubmitState extends State<Submit> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut);
    animation = Tween(begin: 35.0, end: 55.0).animate(curve);

    animationController.forward();
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Obx(() => widget.images.length > 0
            ? Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Container(
                          height: animation.value,
                          child: IconButton(
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
                                      CropperPage(imagePath: widget.images),
                                ),
                              );
                            },
                            color: Colors.green,
                            icon: Icon(
                              Icons.done,
                              size: 30,
                            ),
                          ),
                        );
                      },
                    ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.done,
                    //     color: Colors.green,
                    //   ),
                    //   iconSize: 40,
                    //   onPressed: () async {
                    //     // If the picture was taken, display it on a new screen.
                    //     // Navigator.push(
                    //     //   context,
                    //     //   MaterialPageRoute(
                    //     //     builder: (context) =>
                    //     //         GeneratePage(imagePath: images),
                    //     //   ),
                    //     // );
                    //     await Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) =>
                    //             CropperPage(imagePath: widget.images),
                    //       ),
                    //     );
                    //     //setState(() {});
                    //   },
                    // ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 170),
                      child: Container(
                        key: ValueKey(widget.images.length),
                        child: Center(
                            child: Text(widget.images.length.toString())),
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
