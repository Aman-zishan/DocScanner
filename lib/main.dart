import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:edge_detection/edge_detection.dart';





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
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}


// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}


class TakePictureScreenState extends State<TakePictureScreen> {
  
  
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
   

    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Text('DocScanner',style: TextStyle(color: Colors.black),),actions: <Widget>[
  
  ],
      backgroundColor: Colors.white,
      iconTheme: new IconThemeData(color: Colors.black),
      ),
      
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        
        future: _initializeControllerFuture,
        
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
         child: FloatingActionButton(
        
        backgroundColor: Colors.lightBlueAccent,
       
        
        child: Icon(Icons.camera_alt,),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeneratePage(imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
         
        },
        elevation: 2.0,
        
      ),
        ),
      ),
      
    drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
      
            elevation: 1.5,
            child: Column(children: <Widget>[
              DrawerHeader(
                
                  margin: EdgeInsets.zero,
                 padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      
                  image: AssetImage("images/logo.png"),
                  fit: BoxFit.cover),
                
                
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
        ),
      ),
    
    bottomNavigationBar: BottomAppBar(
      
      
    child: Container(
      height: 150,
      
      child: Row(
        
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        
          
        
       
        Expanded(child: Container(alignment:Alignment.center,child: Icon(Icons.filter_b_and_w, color: Colors.black, size: 30,),),),
        
        Expanded(child: Container(alignment:Alignment.center,child: Icon(Icons.filter, color: Colors.black,size: 30,),),),
        
      ],
    ),
    ),
    shape: CircularNotchedRectangle(),
    notchMargin: 4.0,
    color: Colors.white,
    
    
  ),
 
    );
  }
}
class GeneratePage extends StatefulWidget {
  final String imagePath;
  const GeneratePage({Key key, this.imagePath}) : super(key: key);
  

  @override
  _GeneratePageState createState() => _GeneratePageState();
}
// A widget that displays the picture taken by the user.
@override
class _GeneratePageState extends State<GeneratePage> {
 

  final pw.Document pdf = pw.Document();
  
  bool doneProcessing = false;
  int pageCount = 0;
  int totalPage = 1;
  String appDocPath;
  String searchText;

  @override
  void initState() {
 
    initiateScraping(PdfPageFormat.a4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.imagePath;
    return Scaffold(
            appBar: AppBar(title: Text('DocScanner',style: TextStyle(color: Colors.black),),actions: <Widget>[

  ],
  iconTheme: new IconThemeData(color: Colors.black),
      backgroundColor: Colors.white
      ),
      body: Center(
        child: doneProcessing
            ? Center(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      sharePdf();
                    },
                    icon: Icon(Icons.share),
                    iconSize: 50,
                  ),
                  RaisedButton(
                      child: const Text('Print Document'),
                      onPressed: () {
                        _printPdf();
                      })
                ],
              ))
            : Center(
                child: CircularProgressIndicator()
                 
                
              ),
      ),
          drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
      
            elevation: 1.5,
            child: Column(children: <Widget>[
              DrawerHeader(
                
                  margin: EdgeInsets.zero,
                 padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      
                  image: AssetImage("images/logo.png"),
                  fit: BoxFit.cover),
                
                
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
        ),
      ),
    );
  }

  Future initiateScraping(PdfPageFormat format) async {
   
    String imageUrl = widget.imagePath;

    
    await addPage(pdf, format, imageUrl);
  }

  Future<void> addPage(
      pw.Document pdf, PdfPageFormat format, String imageUrl) async {
    final File file = new File(imageUrl);
    final PdfImage image = await pdfImageFromImageProvider(
        pdf: pdf.document, image: FileImage(file));

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(image),
      );
    }));
    setState(() {
      
      if (imageUrl != '') doneProcessing = true;
    });
  }
  

  void _printPdf() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      await initiateScraping(format);
      return pdf.save();
    });
  }

  Future sharePdf() async {

    await Printing.sharePdf(
        bytes: pdf.save(), filename: '${DateTime.now()}.pdf');
  }
}
  