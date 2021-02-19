import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BugReportMail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bugController = TextEditingController();

    return Expanded(
      child: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  _sendBugReportMail(bugController.text),
                              child: Text(
                                "Report",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        icon: Icon(
          Icons.bug_report,
          color: Colors.black,
          size: 35,
        ),
      ),
    );
  }

  _sendBugReportMail(String bug) async {
    var url = 'mailto:amanzishan.az@gmail.com?subject=Bug&body=$bug';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
