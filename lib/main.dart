import 'dart:async';
import 'package:DocScanner/screens/intro_screen/into_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/take_picture/take_picture.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/TakePictureScreen': (BuildContext context) =>
            TakePictureScreen(camera: firstCamera),
        '/Introscreen': (BuildContext context) => Intro(
              camera: firstCamera,
            ),
      },
    ),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    final prefs = await SharedPreferences.getInstance();
    final myBool = prefs.getBool('my_bool_key') ?? false;
    myBool
        ? Navigator.of(context).pushReplacementNamed('/TakePictureScreen')
        : Navigator.of(context).pushReplacementNamed('/Introscreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
        child: new Image.asset('images/splash_logo.png'),
      ),
    );
  }
}
