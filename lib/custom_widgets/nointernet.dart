import 'package:flutter/material.dart';

Widget noInternet({BuildContext context}) {
  return Center(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Text('no internet')],
  ));
}
