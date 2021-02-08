import 'package:flutter/material.dart';

gridView() {
  return Stack(
    children: <Widget>[
      Container(
        decoration: BoxDecoration(border: Border.all(width: 0)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 0, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0, color: Colors.white),
                ),
              ),
            )),
            Expanded(child: Container()),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0, color: Colors.white),
                ),
              ),
            )),
          ],
        ),
      ),
    ],
  );
}
