import 'package:DocScanner/controller/takepicture_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Filter extends StatelessWidget {
  final TakePikcController controller = Get.put(TakePikcController());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        onPressed: () {
          controller.filter();
        },
        icon: Icon(
          Icons.filter_b_and_w,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}
