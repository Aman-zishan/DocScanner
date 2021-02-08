import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

exitPopUp(BuildContext context) {
  return Container(
    decoration: BoxDecoration(color: Colors.transparent),
    height: 100,
    width: double.infinity,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Do you really want to exit?",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: Colors.black,
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 18, color: Colors.white, letterSpacing: 1),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  FlatButton(
                    onPressed: () {
                      exit(0);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: Colors.white30,
                    child: Text(
                      "Yes",
                      style: TextStyle(
                          fontSize: 18, letterSpacing: 1, color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
