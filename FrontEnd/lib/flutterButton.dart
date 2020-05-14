import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class Button extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RaiseButton();
  }
}

// https://pub.dev/packages/image_picker#-example-tab-
class RaiseButton extends State<Button> {
  File _image; // the image to be viewed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Column(children: [
          Padding(
            padding: const EdgeInsets.all(80.0),
            child: RaisedButton(
                child: Text("Add Person"),
                color: Colors.orange,
                splashColor: Colors.deepOrange,
                onPressed: () async {
                  _image = null; // pick a new image every time the button is clicked

                  await cameraOrGallery(); // load the gallery to pick an image

                  if (_image != null) {
                    // if image exists, encode it and send it off
                    dynamic b64ImageEncoding = await b64Encoding(_image);
                    dynamic response = await addPerson( "Random Person", b64ImageEncoding );

                    print(response);

                    AlertDialog(title: Text('Test'));
                  }
                }),
          ),
          RaisedButton(
            child: Text("Identify Person"),
            color: Colors.red,
            splashColor: Colors.redAccent,
            onPressed: () async {
              _image = null; // pick a new image every time the button is clicked
              await cameraOrGallery(); // load the gallery to pick an image
              if (_image != null) {
                // if image exists, encode it and send it off
                dynamic b64ImageEncoding = await b64Encoding(_image);

                dynamic response = await identifyPerson(b64ImageEncoding);

                await buildDialogAboveScreen("The Person being Identified", response);
              }
            },
          ),
          Center(
              child:
              _image == null ? Text("No Image Selected") : Image.file(_image))
        ]
        )
    );
  }

  Future<dynamic> buildDialogAboveScreen(
      final String title, dynamic textOutput) async {
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

   Future<dynamic> cameraOrGallery() async { // ask for the image source - camera or gallery
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Pick a source for the image"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Camera'),
                  onPressed: () async {
                    await getImageTest('camera');
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Gallery'),
                  onPressed: () async {
                    await getImageTest('gallery');
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  Future getImageTest(final String source) async {
    //both
    var image;

    if (source == 'camera')
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    else
      image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  // get the documents directory of the phone
  //not needed
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    return directory.path;
  }

  // get a file in the documents directory
  //not needed
  Future<dynamic> localFile(final String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName').readAsBytes();
  }

  //both
  Future<dynamic> b64Encoding(dynamic image) async {
    return base64.encode(await image.readAsBytes());
  }

  // add the person into the db list
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

  // identify the person in the photo
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
}
