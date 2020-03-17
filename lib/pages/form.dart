import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:image_picker/image_picker.dart';

class addCar extends StatefulWidget {
  @override
  _addCarState createState() => _addCarState();
}

class _addCarState extends State<addCar> {
  final dbref = Firestore.instance;
  bool himgLoaded = false;
  bool simgLoaded = false;
  bool fimgLoaded = false;
  final StorageReference reference = FirebaseStorage.instance.ref();
  String comp;
  String mod;
  String himgUrl;
  String simgUrl;
  List<String> fimgUrl = List<String>();
  int pric;
  var company = TextEditingController();
  var model = TextEditingController();
  var price = TextEditingController();
  var _key = GlobalKey<FormState>();
  File simg;
  File himg;

  @override 
  void dispose(){
    company.dispose();
    model.dispose();
    price.dispose();
    super.dispose();
  }

  Future pickSimg() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        simg = image;
      });
      simgUrl = await getUrl(simg, DateTime.now().millisecondsSinceEpoch.toString(),'simg');
      print(simgUrl);
    }
  }

  Future pickHimg() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        himg = image;
      });
      himgUrl = await getUrl(himg, DateTime.now().millisecondsSinceEpoch.toString(),'himg');
    }
  }

  Future pickMultiImages() async{
    var resultList =  await MultiImagePicker.pickImages(
      maxImages: 10,
      enableCamera: false    
    );
    setState(() {
      fimgUrl = [];
    });
    resultList.forEach((img){
      img.getByteData().then((data){
        final buffer = data.buffer;
        final String filename = DateTime.now().millisecondsSinceEpoch.toString();
        Uint8List uimg = buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
        getUrls(uimg, filename).then((url){
          fimgUrl.add(url);
          print(fimgUrl);
        });
      });
    });
    
  }

  void cloudUpload(String company,String model,String himg, String simg,int price,List<String> imgs){
    dbref.collection("vehicles").add({
      'company':company,
      'model':model,
      'price':price,
      'rating':4,
      'review':200,
      'quantity':10,
      'himg':himg,
      'simg':simg,
      'img':imgs
    }).then((doc){
      doc.updateData({'vid':doc.documentID});
      Navigator.of(context).pop();
    });
  }

  Future<dynamic> getUrls(Uint8List img,String filename) async{
    print("entered mimg");
    final StorageReference sreference = reference.child("vehicles/$filename");
    final StorageUploadTask uploadTask = sreference.putData(img);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    if(himgLoaded && simgLoaded){
      setState(() {
        fimgLoaded = true;
      });
    }
    return url;
  }

  Future<dynamic> getUrl(File imageFile, String filename,String imgName) async{
    
    final StorageReference sreference = reference.child("vehicles/$filename");
    final StorageUploadTask uploadTask = sreference.putData(imageFile.readAsBytesSync());
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    if(imgName == 'simg'){
      setState(() {
        simgLoaded = true;
      });
    }
    else{
      setState(() {
        himgLoaded = true;
      });
    }
    return url;
    
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
          padding: EdgeInsets.only(top:30,left:30,right:30),
          color: Color.fromRGBO(47,47,47,1),
          child: Column(
            children: <Widget>[
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.all(0),
                    alignment: Alignment.centerLeft,
                    icon:Icon(Icons.arrow_back,color: Color.fromRGBO(191,191,191,1),size: 30,),
                    onPressed: (){
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
                    SizedBox(width:30)
                ],
              ),
              Container(
                height: 10700,
                child: Form(
                  key: _key,
                  child: ListView(
                    children: <Widget>[
                      Text(" Company",style:TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontSize:18
                      )),
                      SizedBox(height:5),
                      TextFormField(
                        controller: company,
                        onChanged: (value){
                          setState(() {
                            comp = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Ex: BMW, Audi ...',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w100,
                            color: Color.fromRGBO(160,160,160, 1),
                            letterSpacing: 1
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(71, 71, 71, 1),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            )
                        ),
                      ),
                      SizedBox(height:10),
                      Text(" Model",style:TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontSize:18
                      )),
                      SizedBox(height:5),
                      TextFormField(
                        onChanged: (value){
                          setState(() {
                            mod = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Ex: A4, A6 ...',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w100,
                            color: Color.fromRGBO(160,160,160, 1),
                            letterSpacing: 1
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(71, 71, 71, 1),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            )
                        ),
                        controller: model,
                      ),
                      SizedBox(height:10),
                      Text(" Price",style:TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontSize:18
                      )),
                      SizedBox(height:5),
                      TextFormField(
                        onChanged: (value){
                          pric = int.parse(value);
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Ex: 1.2, 1,5 in Rupees',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w100,
                            color: Color.fromRGBO(160,160,160, 1),
                            letterSpacing: 1
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(71, 71, 71, 1),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            )
                        ),
                        controller: price,
                      ),
                      SizedBox(
                        height: 10
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(" Half Image",style:TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                fontSize:18
                              )),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)
                                ),
                                child: Text("upload",style: TextStyle(
                                  color: Colors.white60,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.8,
                                  fontSize: 17
                                ),),
                                onPressed: (){
                                  pickHimg();
                                },
                                color: Colors.white30,
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(" Small Image",style:TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                fontSize:18
                              )),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)
                                ),
                                child: Text("upload",style: TextStyle(
                                  color: Colors.white60,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.8,
                                  fontSize: 17
                                ),),
                                onPressed: himgLoaded ? () => pickSimg() : null,
                                color: Colors.white30,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height:10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            
                            children: <Widget>[
                              Text(" Full Images",style:TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                fontSize:18
                              )),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)
                                ),
                                child: Text("upload",style: TextStyle(
                                  color: Colors.white60,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.8,
                                  fontSize: 17
                                ),),
                                onPressed: himgLoaded && simgLoaded ? () => pickMultiImages() : null,
                                color: Colors.white30,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height:10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)
                            ),
                            child: Text("Submit",style: TextStyle(
                              color: Colors.white60,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.8,
                              fontSize: 17
                            ),),
                            onPressed: himgLoaded && simgLoaded && fimgLoaded ? () => cloudUpload(comp,mod,himgUrl,simgUrl,pric,fimgUrl) : null,
                            color: Colors.white30,
                          )
                        ],
                      )
                    ]
                  )
                ),
              )
            ],
          ),
      ),
        ),
    );
  }
}