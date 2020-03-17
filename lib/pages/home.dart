import 'package:flutter/material.dart';
import './first.dart';
import './info.dart';
import '../main.dart';
import './wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final String email;
  final String username;
  final String imageurl;
  HomePage(this.email, this.imageurl, this.username);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedPage = 0;
  final _pageOptions = [First(), Wishlist(), Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(47, 47, 47, 1),
      drawer: AppDrawer(widget.email,widget.username,widget.imageurl),
      key: _scaffoldKey,
      body: Container(
          padding: EdgeInsets.only(top:30,left:30,right:30),
          margin: EdgeInsets.only(top: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: 'Roboto',
                              fontSize: 30.0,
                            ),
                            children: <TextSpan>[
                          new TextSpan(
                              text: 'allCars',
                              style: TextStyle(
                                  color: Color.fromRGBO(237, 237, 237, 1))),
                          new TextSpan(
                              text: '.in',
                              style: TextStyle(
                                  color: Color.fromRGBO(191, 162, 102, 1)))
                        ])),
                    IconButton(
                      icon: Icon(IconData(0xe800, fontFamily: 'CustomMenu'),
                          color: Color.fromRGBO(214, 214, 214, 1), size: 19),
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                    )
                  ],
                ),
                _pageOptions[_selectedPage],
              ],
            ),
          )),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: BottomNavigationBar(
            showUnselectedLabels: false,
            backgroundColor: Color.fromRGBO(71, 71, 71, 0.3),
            currentIndex: _selectedPage,
            onTap: (int index) {
              setState(() {
                _selectedPage = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  activeIcon:
                      Icon(Icons.home, color: Color.fromRGBO(191, 162, 102, 1)),
                  icon: Icon(
                    Icons.home,
                    color: Color.fromRGBO(133, 133, 133, 1),
                  ),
                  title: Text('HOME',
                      style: TextStyle(
                          color: Color.fromRGBO(191, 162, 102, 1),
                          fontFamily: 'Poppins',
                          letterSpacing: 1,
                          fontSize: 14))),
              BottomNavigationBarItem(
                  activeIcon: Icon(Icons.favorite_border,
                      color: Color.fromRGBO(191, 162, 102, 1)),
                  icon: Icon(Icons.favorite_border,
                      color: Color.fromRGBO(133, 133, 133, 1)),
                  title: Text('FAVORITES',
                      style: TextStyle(
                          color: Color.fromRGBO(191, 162, 102, 1),
                          fontFamily: 'Poppins',
                          letterSpacing: 1,
                          fontSize: 14))),
              BottomNavigationBarItem(
                  activeIcon: Icon(Icons.person,
                      color: Color.fromRGBO(191, 162, 102, 1)),
                  icon: Icon(Icons.person,
                      color: Color.fromRGBO(133, 133, 133, 1)),
                  title: Text('PROFILE',
                      style: TextStyle(
                          color: Color.fromRGBO(191, 162, 102, 1),
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          letterSpacing: 1)))
            ]),
      ),
    );
  }
}

class AppDrawer extends StatefulWidget {
  final String email;
  final String username;
  final String image;
  AppDrawer(this.email,this.username,this.image);
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: Container(
        color: Color.fromRGBO(41,41,41,1),
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(47,47,47,1)
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(widget.image),
              ),
              accountName: Text(widget.username,style:TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18
              )), 
              accountEmail: Text(widget.email,style:TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w100,
              ))
            ),
            ListTile(
              onTap: (){
                signOut();
              },
              trailing: Icon(Icons.exit_to_app,color: Colors.white,),
              title: Text('Logout',style:TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              fontSize: 18
            ))) 
         ],
        ),
      ),
    );
  }
  void signOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _googleSignIn.signOut();
    await _auth.signOut();
    prefs.setString('username', null);
    prefs.setString('token', null);
    prefs.setString('email', null);
    prefs.setString('imageurl', null);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>MyApp()));
  }
}
