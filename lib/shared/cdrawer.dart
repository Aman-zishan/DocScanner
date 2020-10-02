import 'package:flutter/material.dart';

class CDrawer extends StatelessWidget {
  const CDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DrawerHeader(
          child: Container(),
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/logo.png"), fit: BoxFit.cover),
          ),
        ),
        ListTile(
          title: Text('Features'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
          },
        ),
        ListTile(
          title: Text('- Convert image to pdf\n- Share pdf\n- Print pdf'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
          },
        ),
        ListTile(
          title: Text('v1.0.0(beta)'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
          },
        ),
        ListTile(
          title: Text('©AmanZishan'),
        ),
      ],
    );
  }
}
