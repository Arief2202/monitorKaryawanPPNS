// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable

import 'package:flutter/material.dart';
import 'package:monitoring_karyawan_ppns/monitoring.dart';
import 'package:monitoring_karyawan_ppns/absensi.dart';
import 'package:monitoring_karyawan_ppns/history_presensi.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monitoring_karyawan_ppns/global_variables.dart' as globals;

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => MenuState();
}


class MenuState extends State<Menu> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double mapWidth = MediaQuery.of(context).size.width/1.2;
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text("Monitoring Karyawan"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                Alert(
                  context: context,
                  type: AlertType.info,
                  desc: "Do you want to Logout ?",
                  buttons: [
                    DialogButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('username');
                          await prefs.remove('password');
                          setState(() {
                            globals.isLoggedIn = false;
                          });
                          Phoenix.rebirth(context);
                        }),
                    DialogButton(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Phoenix.rebirth(context);
                        })
                  ],
                ).show();

              })
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          
            Container(
              height: 50.0,
              width: 300.0,
              child: ElevatedButton(
                child: new Text("Mapping Karyawan"),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return MonitoringPage();
                    })
                  );
                },
              ),
            ),
            
            Container(height: 20.0),//SizedBox(height: 20.0),        
            
            Container(
              height: 50.0,
              width: 300.0,
              child: ElevatedButton(
                child: new Text("History Lokasi"),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return AbsensiPage();
                    })
                  );
                },
              ),
            ),

            Container(height: 20.0),//SizedBox(height: 20.0),        
            
            Container(
              height: 50.0,
              width: 300.0,
              child: ElevatedButton(
                child: new Text("History Presensi"),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return HistoryPresensiPage();
                    })
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}
