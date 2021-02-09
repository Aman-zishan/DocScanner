import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TakePikcController extends GetxController {
  bool isGrayScale = false;
  bool gridView = false;
  Color selectedColor = Colors.black;

  void filter() {
    isGrayScale = !isGrayScale;
    update();
  }

  void gridview() {
    gridView = !gridView;
    if (selectedColor == Colors.blue) {
      selectedColor = Colors.black;
    } else {
      selectedColor = Colors.blue;
    }
    update();
  }
}
