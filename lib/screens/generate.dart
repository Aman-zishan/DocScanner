import 'dart:io';

import 'package:DocScanner/custom_widgets/cuetom_button.dart';
import 'package:DocScanner/screens/about.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //     title: Text(
      //       'DocScanner',
      //       style: TextStyle(color: Colors.black),
      //     ),
      //     actions: <Widget>[],
      //     iconTheme: new IconThemeData(color: Colors.black),
      //     backgroundColor: Colors.white),
      body: SafeArea(
        child: Center(
          child: doneProcessing
              ? Column(
                  children: <Widget>[
                    Image.asset(
                      'images/logo.png',
                      width: width,
                    ),
                    SizedBox(height: 50.0),
                    Text(
                      'Scanning Completed!',
                      style: TextStyle(
                        fontSize: 24.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    CustomButton(
                      onPressed: () {
                        _printPdf();
                      },
                      width: 260.0,
                      title: 'Print Document',
                      icon: Icons.print,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomButton(
                          onPressed: () {},
                          width: 120.0,
                          title: 'Share',
                          icon: Icons.share,
                        ),
                        SizedBox(width: 20.0),
                        CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutPage(),
                              ),
                            );
                          },
                          width: 120.0,
                          title: 'About',
                          icon: Icons.info,
                        ),
                      ],
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
      // drawer: Drawer(
      //   // Add a ListView to the drawer. This ensures the user can scroll
      //   // through the options in the drawer if there isn't enough vertical
      //   // space to fit everything.
      //
      //   elevation: 1.5,
      //   child: CDrawer(),
      // ),
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
      return pdf.save();
    });
  }

  Future sharePdf() async {
    await Printing.sharePdf(
        bytes: pdf.save(), filename: '${DateTime.now()}.pdf');
  }
}
