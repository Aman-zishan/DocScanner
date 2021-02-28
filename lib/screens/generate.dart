import 'dart:io';
import 'dart:ui';
import 'package:DocScanner/custom_widgets/custom_button.dart';
import 'package:DocScanner/screens/about.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneratePage extends StatefulWidget {
  final List imagePath;
  const GeneratePage({Key key, this.imagePath}) : super(key: key);

  @override
  _GeneratePageState createState() => _GeneratePageState();
}

// A widget that displays the picture taken by the user.
@override
class _GeneratePageState extends State<GeneratePage> {
  final bugController = TextEditingController();
  final pw.Document pdf = pw.Document();

  bool doneProcessing = false;
  int pageCount = 0;
  int totalPage = 1;
  String appDocPath;
  String searchText;
  String convertedDateTime;

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
                    SizedBox(height: 20.0),
                    CustomButton(
                      onPressed: () {
                        _printPdf();
                      },
                      width: 260.0,
                      title: 'Save Document',
                      icon: Icons.print,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomButton(
                          onPressed: () {
                            sharePdf();
                          },
                          width: 140.0,
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
                          width: 140.0,
                          title: 'About',
                          icon: Icons.info,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0)), //this right here
                                  child: Container(
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelText: 'Report Bug'),
                                            controller: bugController,
                                          ),
                                          SizedBox(
                                            width: 320.0,
                                            child: RaisedButton(
                                                onPressed: () =>
                                                    _sendBugReportMail(
                                                        bugController.text),
                                                child: Text(
                                                  "Report",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          width: 260.0,
                          title: 'Bug report',
                          icon: Icons.bug_report,
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Text(
                              "This project is licensed under GPL-3.0 open source license\n ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 0.5,
                                wordSpacing: 1,
                              ),
                            ),
                            Text(
                              "© copyright Aman Zishan",
                              textAlign: TextAlign.justify,
                            )
                          ],
                        )),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
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
    final File file = new File(imageUrl);
    final PdfImage image = await pdfImageFromImageProvider(
        pdf: pdf.document, image: FileImage(file));

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ),
    );
    setState(() {
      if (imageUrl != '') doneProcessing = true;
    });
  }

  void _printPdf() {
    Printing.layoutPdf(onLayout: (format) async {
      return pdf.save();
    });
  }

  Future sharePdf() async {
    await Printing.sharePdf(
        bytes: pdf.save(), filename: '${DateTime.now()}.pdf');
  }
}

_sendBugReportMail(String bug) async {
  var url = 'mailto:amanzishan.az@gmail.com?subject=Bug&body=$bug';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
