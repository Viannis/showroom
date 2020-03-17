import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product extends StatefulWidget {
  final String vid;
  Product(this.vid);
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final dbRef = Firestore.instance;
  DocumentSnapshot documentSnapshot;
  int value = 0;
  String company = '';
  String model = '';
  int price = 0;
  int review = 0;
  List<NetworkImage> img = [NetworkImage('')];
  @override
  void initState() {
    getDetails();
    super.initState();
  }

  void getDetails() {
    dbRef.collection("vehicles").document(widget.vid).get().then((data) {
      setState(() {
        value = data.data['rating'];
        model = data.data['model'];
        company = data.data['company'];
        price = data.data['price'];
        review = data.data['review'];
        img.removeLast();
        data.data['img'].forEach((image) {
          img.add(NetworkImage(image));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 30, left: 30, right: 30),
        color: Color.fromRGBO(47, 47, 47, 1),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.all(0),
                  alignment: Alignment.centerLeft,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color.fromRGBO(191, 191, 191, 1),
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
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
                    ])
                  ),
                SizedBox(width: 30)
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  company,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2),
                ),
                FlatButton(
                  onPressed: () async{
                    await dbRef.collection("vehicles").document(widget.vid).delete();
                    Navigator.of(context).pop();
                  },
                  child:Row(
                    children: <Widget>[
                      Text("delete",style:TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w300
                      )),
                      Icon(Icons.delete,color: Colors.white54,size: 16,)
                    ],
                  )
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  model,
                  style: TextStyle(
                      color: Color.fromRGBO(202, 202, 202, 1),
                      fontFamily: 'Roboto',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w100),
                ),
                
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 24.0),
                        children: <TextSpan>[
                      TextSpan(text: '₹ '),
                      TextSpan(text: price.toString()),
                      TextSpan(text: ' Cr '),
                      TextSpan(text: '*')
                    ])),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < value ? Icons.star : Icons.star_border,
                        color: Color.fromRGBO(191, 162, 102, 1),
                      );
                    }))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            color: Color.fromRGBO(202, 202, 202, 1),
                            fontFamily: 'Roboto',
                            fontSize: 18),
                        children: <TextSpan>[
                      TextSpan(
                          text: review.toString(),
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: '  Reviews ',
                          style: TextStyle(fontWeight: FontWeight.w100))
                    ]))
              ],
            ),
            SizedBox(height: 30),
            Container(
              height: 200,
              child: Carousel(
                  boxFit: BoxFit.contain,
                  autoplay: false,
                  animationCurve: Curves.fastLinearToSlowEaseIn,
                  animationDuration: Duration(milliseconds: 1000),
                  dotSize: 6.0,
                  dotBgColor: Colors.transparent,
                  dotIncreasedColor: Color.fromRGBO(191, 162, 102, 1),
                  dotPosition: DotPosition.bottomCenter,
                  dotVerticalPadding: 0.0,
                  showIndicator: true,
                  indicatorBgPadding: 7.0,
                  images: img),
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Text(
                  "Technical Information",
                  style: TextStyle(
                      color: Color.fromRGBO(239, 239, 239, 1),
                      fontFamily: 'Poppins',
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1),
                )
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 150,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: EdgeInsets.only(right: 40, bottom: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17.0)),
                      color: Color.fromRGBO(71, 71, 71, 1),
                      child: Container(
                        padding: EdgeInsets.only(top: 30, left: 20),
                        height: 117,
                        width: 179,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  IconData(0xe800, fontFamily: 'transmission'),
                                  size: 32,
                                  color: Color.fromRGBO(191, 162, 102, 1),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                Text("Transmission",
                                    style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 2,
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(191, 162, 102, 1),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
