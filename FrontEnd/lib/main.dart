import 'package:alz/add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'home_page.dart';
import 'flutterButton.dart';
import 'add_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static const PrimaryColor = const Color(0xFF4e7258);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alz',

      theme: ThemeData(
        primaryColor: PrimaryColor,
      ),
      home: MyHomePage()
    );
  }
}