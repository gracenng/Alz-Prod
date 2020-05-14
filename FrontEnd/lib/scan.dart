import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPage createState() => _ScanPage();
}

class _ScanPage extends State<ScanPage> {
  File _image;
  Future<dynamic> buildDialogAboveScreen(final String title, dynamic textOutput) async {
    // make a dialog saying who the user is
    //scan
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
              content: Text(textOutput));
        });
  }
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
  Future<dynamic> b64Encoding(dynamic image) async {
    return base64.encode(await image.readAsBytes());
  }
  Future<dynamic> identifyPerson(final dynamic fileRead) async {
    var client = http.Client();
    try {
      print("Processing!");
      var response = await client.post(
          'https://alzfaceapi.herokuapp.com/identify_person',
          body: {'image_stream': fileRead});
      print('Response Status: ${response.statusCode}');
      return '${response.body}';
    } finally {
      client.close();
    }
  }
  Container tile(String header, String source){
    return Container(
      child: SizedBox(
        width: 380,
        height: 350,
        child: RaisedButton(
          color: Colors.white,
          elevation: 16.0,
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
          child: Text(header,style:  GoogleFonts.nunito(
            color: Color(0xFF4e7258),
            fontSize: 30.0,
            fontWeight: FontWeight.w700,
          )),
          onPressed: () async {
            await getImageTest(source);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF4e7258),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                tile('Camera', 'camera'),
                SizedBox(width: 10, height: 10,), //gap in between
                tile('Gallery', 'gallery'),
              ]
            ),
          ],
        )
      )
    );
  }
}


