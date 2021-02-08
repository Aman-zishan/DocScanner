import 'package:DocScanner/controller/takepicture_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './gridView.dart';

class Gridvieww extends StatelessWidget {
  final TakePikcController controller = Get.put(TakePikcController());

  var gridviewstate = false;

  void showgrid() {
    controller.gridview();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<TakePikcController>(
        init: TakePikcController(),
        builder: (_) {
          return IconButton(
            icon: Icon(
              Icons.grid_on,
              size: 30,
            ),
            color: _.selectedColor,
            onPressed: () => {
              showgrid(),
            },
          );
        },
      ),
    );
  }
}
