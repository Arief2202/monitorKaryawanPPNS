// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable

import 'package:flutter/material.dart';
import 'package:monitoring_karyawan_ppns/global_variables.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'dart:async';
import 'dart:developer';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => MonitoringPageState();
}


class MonitoringPageState extends State<MonitoringPage> {
  Timer? timer;
  late List<UserLocation>? userLocation;
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateValue());
  }

  void updateValue() async{
    var url = Uri.parse(global.endpoint_get_all);
    var response = await http.get(url);
    if (response.statusCode == 200) {
        debugPrint(jsonDecode(response.body).toString());
        setState(() {          
          userLocation = List<UserLocation>.from((jsonDecode(response.body) as List).map((x) => UserLocation.fromJson(x)).where((content) => content.nuid != null)); 
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
              SizedBox(height: 50),

              Center(child: Stack(
                // fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(width: mapWidth,'img/m1.png'),
                  // printDots(userLocation, 1, mapWidth),
                  for (UserLocation user in userLocation!) dots(user.nuid, user.currentLocation.x, user.currentLocation.y, user.currentLocation.ruang, mapWidth),
                  
                ]
              )),
              SizedBox(height: 50),

              // Center(child: Stack(
              //   // fit: StackFit.expand,
              //   children: <Widget>[
              //     Image.asset(width: mapWidth,'img/m2.png'),
              //     // dots("1", 0, 0, "M102", mapWidth),
              //   ]
              // )),
              // SizedBox(height: 50),
              
          ],
        ),
      ),
    );
  }
}

// Widget printDots(List<UserLocation> data, int lantai, double width){
//   List<Widget> list = <Widget>[];
//   for(var i = 0; i < data.length; i++){
//     list.add(dots(data[0].nuid, data[0].currentLocation.x, data[0].currentLocation.y, data[0].currentLocation.ruang, width));
//   }
//   return Stack(
//                 // fit: StackFit.expand,
//                 children: <Widget>[
//                 ];
// }

Widget dots(String nuid, String xStr, String yStr, String ruang, double width){
  double x = double.parse(xStr);
  double y = double.parse(yStr);
  int plusX = (width/(380/70)).toInt();
  int plusY = (width/(380/96)).toInt();
  double scaleCircle = 35;
  double scaleText = 45;
  if(ruang == "M102" || ruang == "M203"){

  }
  if(ruang == "M103" || ruang == "M204"){
    plusX = (width/(380/146)).toInt();
  }
  else if(ruang == "M104" || ruang == "M205") plusX = (width/(380/228)).toInt(); 
  return Positioned(
      left: ((width/(380/x)+plusX))-((width/scaleCircle)/2),
      top: ((width/(380/y)+plusY))-((width/scaleCircle)/2),
      width: width/scaleCircle,
      height: width/scaleCircle,
      child: CircleAvatar(
          backgroundColor: Color.fromARGB(200, 255, 0, 0),
          child: Text(nuid, style: TextStyle(fontSize: width/scaleText)),
          foregroundImage: NetworkImage("enterImageUrl"),
      ),
    );
}

class UserLocation{
  String nuid;
  String name;
  String username;
  String email;
  Location currentLocation;
  UserLocation({
    required this.nuid,
    required this.name,
    required this.username,
    required this.email,
    required this.currentLocation
  });
  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
    nuid: json['nuid'],
    name: json['name'],
    username: json['username'],
    email: json['email'],
    currentLocation: Location.fromJson(json['currentLocation']),
  );
}

class Location{
  String x;
  String y;
  String ruang;
  String timestamp;
  Location({
    required this.x,
    required this.y,
    required this.ruang,
    required this.timestamp,
  });
  factory Location.fromJson(Map<String, dynamic> json) => Location(
    x: json['x'],
    y: json['y'],
    ruang: json['ruang'],
    timestamp: json['timestamp'],
  );
}