import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.black),
        title: Text(
          'About',
          style: TextStyle(
            color: Colors.black,
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
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Center(
                  child: Text(
                    'Aman Zishan',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  indent: 130,
                  endIndent: 130,
                ),
                SizedBox(height: 20.0),
                Text(
                  'DocScanner',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries'),
                SizedBox(height: 15.0),
                Text(
                  'Features',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries'),
                SizedBox(height: 15.0),
                Text(
                  'Version',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text('Beta v1.0.1'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
