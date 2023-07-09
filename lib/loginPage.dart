// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:monitoring_karyawan_ppns/global_variables.dart' as globals;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  List<TextEditingController> _data = [TextEditingController(), TextEditingController()];
  List<bool> _error = [false, false, false, false];
  String _passwordMsg = "Value Can\'t Be Empty";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(118, 104, 58, 183),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                    width: 400,
                    height: 350,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              width: double.infinity,
                              // height: MediaQuery.of(context).size.width / 10,
                              child: Text("LOGIN ADMIN", textAlign: TextAlign.center, style: TextStyle(color: Colors.deepPurple, fontSize: 35, fontWeight: FontWeight.bold))),
                          SizedBox(height: 20),
                          Container(
                            //img1
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(fontSize: 20),
                                    errorText: _error[0] ? 'Value Can\'t Be Empty' : null,
                                  ),
                                  onSubmitted: (value) {
                                    _doLogin(context);
                                  },
                                  controller: _data[0],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            //img1
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(fontSize: 20),
                                    errorText: _error[1] ? 'Value Can\'t Be Empty' : null,
                                  ),
                                  onSubmitted: (value) {
                                    _doLogin(context);
                                  },
                                  controller: _data[1],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _doLogin(context);
                              },
                              child: Text(
                                "Log in",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ])),
          ],
        ),
      ),
    );
  }

  Future _doLogin(context) async {
    bool status = true;
    setState(() {
      _passwordMsg = "Value Can\'t Be Empty";
      for (int a = 0; a < 2; a++) {
        if (_data[a].text.isEmpty) {
          _error[a] = true;
          status = false;
        } else
          _error[a] = false;
      }
    });
    if (status) {
      String _username = _data[0].text;
      String _password = _data[1].text;

      if (_username == globals.username && _password == globals.password) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _username);
        await prefs.setString('password', _password);
        setState(() {
          globals.isLoggedIn = true;
        });
        Alert(
          context: context,
          type: AlertType.info,
          desc: "Login Success!",
          buttons: [
            DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Phoenix.rebirth(context);
                })
          ],
        ).show();
      } else {
        Alert(
          context: context,
          type: AlertType.info,
          title: "Login Failed!",
          desc: "Incorrect Username or Password!",
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
    }
  }
}
