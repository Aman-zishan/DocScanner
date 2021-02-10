import 'package:DocScanner/custom_widgets/nointernet.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'dart:async';

// ignore: must_be_immutable
class MainFetchData extends StatelessWidget {
  List list = List();
  var isLoading = false.obs;
  Future _fetchData() async {
    isLoading = true.obs;

    final response = await http.get(
        "https://api.github.com/repos/aman-zishan/DocScanner/contributors");
    if (response.statusCode == 200) {
      list = json.decode(response.body) as List;

      isLoading = false.obs;
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
        body: FutureBuilder(
            future: _fetchData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasError
                  ? noInternet(context: context)
                  : isLoading.value
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
                                child: Image.network(
                                  list[index]['avatar_url'],
                                  fit: BoxFit.cover,
                                  height: 40.0,
                                  width: 40.0,
                                ),
                              ),
                            );
                          });
            }));
  }
}
