// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable

import 'package:flutter/material.dart';
import 'package:monitoring_karyawan_ppns/monitoring.dart';
import 'package:monitoring_karyawan_ppns/absensi.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Monitoring Karyawan"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          
            Container(
              height: 50.0,
              width: 300.0,
              child: ElevatedButton(
                child: new Text("Monitoring Karyawan"),
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
                child: new Text("Absensi"),
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
          ],
        ),
      );
  }
}
