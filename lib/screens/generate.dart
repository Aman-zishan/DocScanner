import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../shared/cdrawer.dart';

class GeneratePage extends StatefulWidget {
  final List imagePath;
  const GeneratePage({Key key, this.imagePath}) : super(key: key);

  @override
  _GeneratePageState createState() => _GeneratePageState();
}

// A widget that displays the picture taken by the user.
@override
class _GeneratePageState extends State<GeneratePage> {


  var screenHeight = window.physicalSize.height / window.devicePixelRatio;
   var screenWidth = window.physicalSize.width / window.devicePixelRatio;
  final pw.Document pdf = pw.Document();

  bool doneProcessing = false;
  PdfImage image;
  File file;
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
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'DocScanner',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[],
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white),
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
            : Center(child: CircularProgressIndicator()),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.

        elevation: 1.5,
        child: CDrawer(),
      ),
    );
  }

  Future initiateScraping(PdfPageFormat format) async {
    List imageUrl = widget.imagePath;

    for (String item in imageUrl) {
      await addPage(pdf, format, item);
    }
  }

  Future<void> addPage(
      pw.Document pdf, PdfPageFormat format, String imageUrl) async {
    file = new File(imageUrl);
    print('last file: $file');

    image = await pdfImageFromImageProvider(
        pdf: pdf.document, image: FileImage(file));

    print('last image: $image');

    pdf.addPage(pw.MultiPage(maxPages: imageUrl.length,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        build: (pw.Context context) {
          // return <pw.Widget>[

          return <pw.Widget>[
            pw.Column(children: <pw.Widget>[pw.Image(image,width: screenWidth,height: screenHeight)])
          ];
        }));

    setState(() {
      if (imageUrl != '') doneProcessing = true;
    });
  }

  void _printPdf() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      setState(() {
        
      });
      return pdf.save();
    });
  }

  Future sharePdf() async {
    await Printing.sharePdf(
        bytes: pdf.save(), filename: '${DateTime.now()}.pdf');
  }
}
