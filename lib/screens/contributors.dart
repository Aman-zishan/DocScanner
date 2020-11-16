import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

class MainFetchData extends StatefulWidget {
  @override
  _MainFetchDataState createState() => _MainFetchDataState();
}
class _MainFetchDataState extends State<MainFetchData> {

  @override
  void initState() {
    super.initState();
_fetchData();
  }
  List list = List();
  var isLoading = false;
  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get("https://api.github.com/repos/aman-zishan/DocScanner/contributors");
    if (response.statusCode == 200) {
      list = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contributors"),
        ),

        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: EdgeInsets.all(10.0),
                title: new Text(list[index]['login']),
                trailing: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                     Image.network(

                      list[index]['avatar_url'],
                      fit: BoxFit.cover,

                      height: 40.0,
                      width: 40.0,
                    ),

                ),
              );
            }));
  }
}