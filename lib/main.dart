import 'package:flutter/material.dart';
import 'dart:async';
import './pages/login.dart';
import './pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    bool loggedIn = false;
    var username;
    var email;
    var imageurl;

    @override
    void initState() {
      super.initState();
      this._function();
    }

    Future<Null> _function() async {
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
      this.setState(() {
        if (prefs.getString("token") != null) {
          loggedIn = true;
          username = prefs.getString('username');
          email = prefs.getString('email');
          imageurl = prefs.getString('imageurl');
        } else {
          loggedIn = false;
        }
      });
  } 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loggedIn ? HomePage(email,imageurl,username):AuthPage(),
    );
  }
}