import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Gallery extends StatelessWidget {
  imgFromGallery() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    return _image = image;
  }

  @override
  File _image;
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        onPressed: () {
          imgFromGallery();
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
