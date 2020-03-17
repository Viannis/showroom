import 'dart:async';
import 'package:flutter/material.dart';
import './home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(47,47,47,1),
      child: Center(
        child: GoogleSignInButton(
          borderRadius: 5,
          darkMode: true,
          onPressed: (){
            _ensureLoggedIn().then((user){
              if(user.uid != null){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomePage(user.email, user.photoUrl, user.displayName)));
              }
              else{
                setState(() {
                  
                });
              }
            });
          },
        ),
      ),
    );
  }

  Future<FirebaseUser> _ensureLoggedIn() async{
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState((){
        prefs.setString('username', user.displayName);
        prefs.setString('token', user.uid);
        prefs.setString('email', user.email);
        prefs.setString('imageurl', user.photoUrl);
      });
      return user;
  }
}