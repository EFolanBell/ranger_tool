import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? stringResponse;
  Map? mapResponse;
  List? listOfFacts;

  get time => null;

  Future fetchData() async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m'));
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        listOfFacts = mapResponse!['time'];
      });
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rangers Tool'),
        backgroundColor: Colors.green,
      ),
      body: mapResponse == null
          ? Container()
          : Column(
              children: <Widget>[
                Text(
                  mapResponse!['latitude'].toString(),
                  style: TextStyle(fontSize: 30),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                        child: Column(children: <Widget>[
                      time.network(listOfFacts![index]['time']),
                      Text(
                        mapResponse!['time'].toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]));
                  },
                  itemCount: listOfFacts == null ? 0 : listOfFacts?.length,
                )
              ],
            ),
    );
  }
}
