// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:monitoring_karyawan_ppns/global_variables.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'dart:async';
import 'dart:developer';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({super.key});

  @override
  State<AbsensiPage> createState() => AbsensiPageState();
}


class AbsensiPageState extends State<AbsensiPage> {
  Timer? timer;
  // late List<UserLocation>? userLocation;
  void initState() {
    // timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateValue());
  }

  void updateValue() async{
    var url = Uri.parse(global.endpoint_get_all);
    var response = await http.get(url);
    if (response.statusCode == 200) {
        debugPrint(jsonDecode(response.body).toString());
        setState(() {          
          // userLocation = List<UserLocation>.from((jsonDecode(response.body) as List).map((x) => UserLocation.fromJson(x)).where((content) => content.nuid != null)); 
        });
    }
  }

  Widget build(BuildContext context) {
    double mapWidth = MediaQuery.of(context).size.width/1.2;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {
            timer?.cancel(),
            Navigator.pop(context),            
          }
        ),
        title: Text("Monitoring Karyawan"),
      ),
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[   
              Container(
                width: 50,
                height: 50,
                child: Table(
                  border: TableBorder.all(color: Color.fromARGB(255, 0, 0, 0), width: 2),
                  columnWidths: {
                    0: FixedColumnWidth(100.0),
                    1: FlexColumnWidth(100.0),
                    2: FixedColumnWidth(100.0),
                  },
                  children: const [
                    TableRow(children: [
                      Text("1", style: TextStyle(fontSize: 15.0),),
                      Text("Mohit", style: TextStyle(fontSize: 15.0),),
                      Text("25", style: TextStyle(fontSize: 15.0),),
                    ]),
                    TableRow(children: [
                      Text("2", style: TextStyle(fontSize: 15.0),),
                      Text("Ankit", style: TextStyle(fontSize: 15.0),),
                      Text("27", style: TextStyle(fontSize: 15.0),),
                    ]),
                    TableRow(children: [
                      Text("3", style: TextStyle(fontSize: 15.0),),
                      Text("Rakhi", style: TextStyle(fontSize: 15.0),),
                      Text("26", style: TextStyle(fontSize: 15.0),),
                    ]),
                    TableRow(children: [
                      Text("4", style: TextStyle(fontSize: 15.0),),
                      Text("Yash", style: TextStyle(fontSize: 15.0),),
                      Text("29", style: TextStyle(fontSize: 15.0),),
                    ]),
                    TableRow(children: [
                      Text("5", style: TextStyle(fontSize: 15.0),),
                      Text("Pragati", style: TextStyle(fontSize: 15.0),),
                      Text("28", style: TextStyle(fontSize: 15.0),),
                    ]),
                  ],
                ),
              ),              
          ],
        ),
      ),
    );
  }
}
