import 'dart:io';
import 'package:DocScanner/controller/takepicture_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Gallery extends StatelessWidget {
  final TakePikcController controller = Get.put(TakePikcController());

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image.toString() != 'null') {
      controller.takepicture(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        onPressed: () {
          _imgFromGallery();
        },
        icon: Icon(
          Icons.filter,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}
