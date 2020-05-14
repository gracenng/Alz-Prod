import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPage createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  File _image; // the image to be viewed
  Future getImageTest(final String source) async {
    //both
    var image;

    if(source == 'camera')
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    else
      image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
  Future<dynamic> cameraOrGallery() async { // ask for the image source - camera or gallery
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Pick a source for the image", style:  GoogleFonts.nunito(
                color: Color(0xFF4e7258),
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
              ) ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Camera',style:  GoogleFonts.nunito(
                    color: Color(0xFF4e7258),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  )),
                  onPressed: () async {
                    await getImageTest('camera');
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton (
                  child: Text('Gallery',style:  GoogleFonts.nunito(
                    color: Color(0xFF4e7258),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  )),
                  onPressed: () async {
                    await getImageTest('gallery');
                    Navigator.of(context).pop();
                  },
                )
              ]
          );
        });
  }
  Future<dynamic> b64Encoding(dynamic image) async {
    return base64.encode(await image.readAsBytes());
  }
  Future<dynamic> addPerson(final String name, final dynamic fileRead) async {
    var client = http.Client();
    try {
      var response = await client.post(
          'https://alzfaceapi.herokuapp.com/add_person',
          body: {'name': name, 'image_stream': fileRead});
      print('Response Status: ${response.statusCode}');
      return 'Response body: ${response.body}';
    } finally {
      client.close();
    }
  }
  @override
  Widget build(BuildContext context) {
    String name;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.lightGreen[900],
                  Colors.lightGreen[800],
                  Colors.lightGreen[500],
                ]
            )
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(70),
              child: Container(),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      //curved edge
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(50, 80, 50, 10),
                          child: Text("Please enter a name",
                            style: GoogleFonts.nunito(
                              color: Color(0xFF4e7258),
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700,
                            ),)
                      ),
                      Container(
                        padding: EdgeInsets.all(32),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF4e7258)),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              )
                          ),
                          onChanged: (text) {
                            name = text; //store name here
                            print(name);
                          },
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(30,10,30,10),
                            color: Color(0xFF4e7258),
                            elevation: 16.0,
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                          onPressed: () async {
                            _image = null; // pick a new image every time the button is clicked

                            await cameraOrGallery(); // load the gallery to pick an image

                            if (_image != null) {
                              // if image exists, encode it and send it off
                              dynamic b64ImageEncoding = await b64Encoding(_image);
                              dynamic response = await addPerson( name, b64ImageEncoding );

                              print(response);

                              AlertDialog(title: Text('Test'));
                            }
                          },
                            child: Text("Take picture",style:  GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700,
                            ),)
                        ),
                      )
                    ],
                  )
              )
            )
          ]
        )
      )
    );
  }
}//class
