import 'package:flutter/material.dart';
import './product.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './form.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  final dbRef = Firestore.instance;
  List<Map> vehicles = List();
  @override
  void initState(){
    getVehicles();
    super.initState();
  }

  getVehicles() async{
    var docRef = await dbRef.collection("vehicles").getDocuments();
    docRef.documents.forEach((data){
      vehicles.add({
        'company':data.data['company'],
        'img':data.data['simg'],
        'model':data.data['model'],
        'vid':data.data['vid']
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w100,
                    color: Color.fromRGBO(160,160,160, 1),
                    letterSpacing: 1
                  ),
                  contentPadding: EdgeInsets.only(top:14),
                  filled: true,
                  prefixIcon: Icon(Icons.search,color: Color.fromRGBO(214,214,214,1),),
                  fillColor: Color.fromRGBO(71, 71, 71, 1),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  )
                )
              ),
              suggestionsCallback: (pattern) async{
                return await getSuggestions(pattern);
              }, 
              itemBuilder: (context, suggestion){
                return ListTile(
                  leading: Image.network(suggestion['img'],width: 60,height: 60,),
                  title: Text(suggestion['model'],style: TextStyle(
                                    color: Color.fromRGBO(238,238,238,1),
                                    letterSpacing: 0.5,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800
                                  )),
                  subtitle: Text(suggestion['company'],style: TextStyle(
                                    color: Color.fromRGBO(201,201,201,1),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w100,
                                    fontSize: 14
                                  )),
                                  trailing: Icon(Icons.keyboard_arrow_right,size: 35,color: Color.fromRGBO(214,214,214,1)),
                );
              },  
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                color: Color.fromRGBO(71,71,71,1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ), 
              onSuggestionSelected: (suggestion) {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Product(suggestion['vid'])));
              }
            ),
            SizedBox(
              height: 15
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star_border,
                      size: 30,
                      color: Color.fromRGBO(191, 162, 102, 1),
                    ),
                    Text(
                  "Popular",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25,
                    color: Colors.white,
                    letterSpacing: 2
                  ),
                )
                  ],
                ),
                FlatButton(
                  onPressed: (){
                    
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context)=>addCar()
                    ));
                    //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>FormPage()));
                  }, 
                  child: Text(
                    "+ add",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: Colors.white70,
                      fontSize: 20.0
                    ),
                  )
                )
              ],
            ),
            Container(
              height: 190,
              padding: EdgeInsets.symmetric(vertical:10),
              child: getCars()
            ),
            SizedBox(height:10),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left:2,right:2),
                  child: Icon(
                    IconData(0xe800,fontFamily: 'CustumThumbUp'),
                    size: 22,
                    color: Color.fromRGBO(191, 162, 102, 1),
                  ),
                ),
                Text(
                  "Recommended for you",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25,
                    color: Colors.white,
                    letterSpacing: 2
                  ),
                )
              ],
            ),
            SizedBox(height:10),
            Container(
              height:300,
              child: getList()
            ),
          ],
        )
    );
  }

  Widget getCars(){
    return StreamBuilder<QuerySnapshot>(
      stream: dbRef.collection("vehicles").snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Text("error");
        } else{
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return Text("Loading...");
            default:
              var docRef = snapshot.data.documents;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: docRef.length,
                itemBuilder: (BuildContext context,int index){
                  return GestureDetector(
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Product(docRef[index]['vid'])));
                    },
                    child: Card(
                      
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left:10),
                        width: 111,
                        height: 165,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end:Alignment.bottomLeft,
                            colors: [Color.fromRGBO(89,255,151,0.9),Color.fromRGBO(60,64,56,0.9)]
                          )
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height:20
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Image.network(docRef[index]['himg'],width: 90,height:80),
                              ],
                            ),
                            SizedBox(height:9),
                            Row(
                              children: <Widget>[
                                Text(docRef[index]['model'],style: TextStyle(color: Colors.white,fontFamily: 'Roboto',fontSize: 16),)
                              ],
                            ),
                            SizedBox(height:3),
                            Row(
                              children: <Widget>[
                                Text(docRef[index]['company'],style: TextStyle(color: Colors.white,fontFamily: 'Roboto',fontWeight: FontWeight.w100,fontSize: 11,letterSpacing: 1),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
          }
        }
      },
    );
  }

  Widget getList(){
    return StreamBuilder(
      stream: dbRef.collection("vehicles").snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Text("Error");
        }
        else{
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
              return Text("Loading...");
            default:
              var docRef = snapshot.data.documents;
              return ListView.builder(
                itemCount: docRef.length,
                itemBuilder: (BuildContext context,int index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Product(docRef[index]['vid'])));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      color: Color.fromRGBO(71,71,71,1),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 76,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left:10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    docRef[index]['model'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color.fromRGBO(238,238,238,1),
                                      letterSpacing: 0.5,
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w800
                                    ),
                                  ),
                                  Text(
                                    docRef[index]['company'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color.fromRGBO(201,201,201,1),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w100,
                                      fontSize: 14
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Image.network(docRef[index]['simg']),
                                Icon(Icons.keyboard_arrow_right,size: 35,color: Color.fromRGBO(214,214,214,1),)
                              ],
                            ),
                          ],
                        )
                      )
                    ),
                  );
                }
              );
          }
        }
      }
    );
  }

  Future<List> getSuggestions(String query) async{
    List<Map> matches = List();
    matches.addAll(vehicles);
    matches.retainWhere((s)=>s['company'].toLowerCase().contains(query.toLowerCase()) || s['model'].contains(query));
    return matches;
  }
}