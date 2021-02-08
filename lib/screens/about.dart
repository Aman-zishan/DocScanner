import 'package:flutter/material.dart';
import 'package:DocScanner/screens/contributors.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//List data = getContributors();

    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(
          'About',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset("images/logo.png")),
                  ),
                ),
                SizedBox(height: 15.0),
                SizedBox(height: 20.0),
                Text(
                    'DocScanner is a simple open sourced Document scanner App, DocScanner is built to make scanning documents convenient for the users. This App contains absolutely zero Ads. '),
                SizedBox(height: 15.0),
                Text(
                  'Features',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                    '- Take image and convert to pdf\n- Grey filter mode\n- Crop, rotate images after capture\n- Print and share pdf '),
                SizedBox(height: 15.0),
                Text(
                  'Version',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text('v1.0.0-Beta'),
                SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainFetchData(),
                        ),
                      );
                    },
                    child: const Text('see contributors',
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
