// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:monitoring_karyawan_ppns/global_variables.dart' as global;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:monitoring_karyawan_ppns/absensi.dart';
import 'package:monitoring_karyawan_ppns/history_presensi.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => MonitoringPageState();
}

class MonitoringPageState extends State<MonitoringPage> {
  Timer? timer;
  late List<UserLocation>? userLocation;

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateValue());
    userLocation = [
      UserLocation(nuid: "", email: "", name: "", username: "", currentLocation: Location(x: "0", y: "0", ruang: "", timestamp: "")),
    ];
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateValue() async {
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
    double mapWidth = MediaQuery.of(context).size.width / 1.2;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {
                  timer?.cancel(),
                  Navigator.pop(context),
                }),
        title: Text("Mapping Karyawan"),
      ),
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Center(
                child: Stack(
                    // fit: StackFit.expand,
                    children: <Widget>[
                  // Image.asset(width: mapWidth, 'img/m1.png'),
                  Image.asset(width: mapWidth, 'img/mp1.png'),
                  for (UserLocation user in userLocation!) user.currentLocation.ruang[1] == '1' || user.currentLocation.ruang == "parkiran" ? dots(user, user.currentLocation.x, user.currentLocation.y, user.currentLocation.ruang, mapWidth, context) : SizedBox(),
                ])),
            // SizedBox(height: 10),
            // Center(
            //     child: Stack(
            //         // fit: StackFit.expand,
            //         children: <Widget>[
            //       Image.asset(width: mapWidth, 'img/m2.png'),
            //       // printDots(userLocation, 1, mapWidth),
            //       for (UserLocation user in userLocation!) user.currentLocation.ruang[1] == '2' ? dots(user.nuid, user.currentLocation.x, user.currentLocation.y, user.currentLocation.ruang, mapWidth) : SizedBox(),
            //     ])),
            SizedBox(height: 50),
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

Widget dots(UserLocation user, String xStr, String yStr, String ruang, double width, BuildContext context) {
  var f = NumberFormat("###0.0#", "en_US");
  double x = double.parse(xStr);
  double y = double.parse(yStr);
  // int totalWidth = 310; //map tanpa parkir
  int totalWidth = 510; //map dengan parkir
  int plusX = 0;
  int plusY = (width / (totalWidth / 96)).toInt();
  double scaleCircle = 65;
  double scaleText = 75;
  if (ruang == "parkiran") {
    plusX = (width / (totalWidth / 310)).toInt();
    plusY = (width / (totalWidth / 84)).toInt();
  }
  if (ruang == "M103" || ruang == "M203") {
    plusX = (width / (totalWidth / 76)).toInt();
  } else if (ruang == "M104" || ruang == "M204") plusX = (width / (totalWidth / 158)).toInt();
  return Positioned(
    left: ((width / (totalWidth / x) + plusX)) - ((width / scaleCircle) / 2),
    top: ((width / (totalWidth / y) + plusY)) - ((width / scaleCircle) / 2),
    width: width / scaleCircle,
    height: width / scaleCircle,
    child: GestureDetector(
        onTap: () {
          Alert(
              context: context,
              desc: "NUID :\n${user.nuid}\n\nName :\n${user.name}\n\nUsername :\n${user.username}\n\nEmail :\n${user.email}\n\nLokasi (${user.currentLocation.ruang})\nX : ${f.format(double.parse(user.currentLocation.x))}\nY : ${f.format(double.parse(user.currentLocation.y))}",
              buttons: [
                DialogButton(
                  child: Text(
                    "History Lokasi",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return AbsensiPage(id: int.parse(user.nuid));
                    }));
                  },
                  color: Color.fromRGBO(0, 179, 134, 1.0),
                ),
                DialogButton(
                  child: Text(
                    "History Absensi",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return HistoryPresensiPage(id: int.parse(user.nuid));
                    }));
                  },
                  color: Color.fromRGBO(0, 179, 134, 1.0),
                ),
              ],
              style: AlertStyle(
                descStyle: TextStyle(fontSize: 15),
                descTextAlign: TextAlign.center,
              )).show();
        },
        child: CircleAvatar(
          backgroundColor: Color.fromARGB(200, 255, 0, 0),
          child: Text(user.nuid, style: TextStyle(fontSize: width / scaleText)),
          foregroundImage: NetworkImage("enterImageUrl"),
        )),
  );
}

class UserLocation {
  String nuid;
  String name;
  String username;
  String email;
  Location currentLocation;
  UserLocation({required this.nuid, required this.name, required this.username, required this.email, required this.currentLocation});
  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
        nuid: json['nuid'],
        name: json['name'],
        username: json['username'],
        email: json['email'],
        currentLocation: Location.fromJson(json['currentLocation']),
      );
}

class Location {
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
