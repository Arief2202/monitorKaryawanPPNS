// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, non_constant_identifier_names, prefer_interpolation_to_compose_strings, prefer_const_constructors, use_build_context_synchronously, unused_import

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monitoring_karyawan_ppns/loginPage.dart';
import 'package:monitoring_karyawan_ppns/listKaryawan.dart';
import 'package:monitoring_karyawan_ppns/absensi.dart';
import 'package:monitoring_karyawan_ppns/history_presensi.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monitoring_karyawan_ppns/global_variables.dart' as globals;
import 'package:monitoring_karyawan_ppns/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // scaffoldBackgroundColor: Color(0xFF736AB7),
      ),
      home: LoaderOverlay(child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final String? password = prefs.getString('password');

    if (username != null && password != null) {
      setState(() {
        globals.loadingAutologin = true;
      });
      context.loaderOverlay.show();

      if (username == globals.username && password == globals.password) {
        setState(() {
          globals.isLoggedIn = true;
        });
      } else {
        await prefs.remove('username');
        await prefs.remove('password');
        setState(() {
          globals.isLoggedIn = false;
        });
        Alert(
          context: context,
          type: AlertType.info,
          title: "Login Failed!",
          desc: "Please relogin",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ).show();
      }
      setState(() {
        globals.loadingAutologin = false;
      });
      context.loaderOverlay.hide();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return globals.loadingAutologin ? Scaffold() : Scaffold(body: globals.isLoggedIn ? Menu() : LoginPage());
  }
}
