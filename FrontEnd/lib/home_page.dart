import 'package:alz/add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'add_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scan.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Container myTiles (IconData icon, String heading){
    return Container(
      child: RaisedButton(
        color: Colors.white,
        elevation: 16.0,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
        },
          child: Center(
          child:Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //text
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(heading,
                        style:  GoogleFonts.nunito(
                          color: Color(0xFF4e7258),
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    //icon
                    Material(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(
                          icon,
                          size: 50,
                          color: Color(0xFF4e7258),
                        )
                      )
                    )
                  ],
                )
              ],
            )
          )
        )
      )
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 80.0),
          children: <Widget>[
            myTiles(Icons.account_circle, "Contacts"),
            Container(
              child: RaisedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AddPage()
                    ),
                    );
                  },
                  color: Colors.white,
                  elevation: 16.0,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),

                  child: Center(
                      child:Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //text
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("Add",
                                      style:  GoogleFonts.nunito(
                                        color: Color(0xFF4e7258),
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  //icon
                                  Material(
                                      borderRadius: BorderRadius.circular(24.0),
                                      color: Colors.white,
                                      child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Icon(
                                            Icons.person_add,
                                            size: 50,
                                            color: Color(0xFF4e7258),
                                          )
                                      )
                                  )
                                ],
                              )
                            ],
                          )
                      )
                  )
              )
          ),

            Container(
                child: RaisedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => ScanPage()
                        ),
                      );
                    },
                    color: Colors.white,
                    elevation: 16.0,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),

                    child: Center(
                        child:Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    //text
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text("Scan",
                                        style:  GoogleFonts.nunito(
                                          color: Color(0xFF4e7258),
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    //icon
                                    Material(
                                        borderRadius: BorderRadius.circular(24.0),
                                        color: Colors.white,
                                        child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Icon(
                                              Icons.face,
                                              size: 50,
                                              color: Color(0xFF4e7258),
                                            )
                                        )
                                    )
                                  ],
                                )
                              ],
                            )
                        )
                    )
                )
            ),

            myTiles(Icons.assignment_ind, "Quiz"),
            myTiles(Icons.map, "Map"),

          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 200.0),
            StaggeredTile.extent(1, 200.0),
            StaggeredTile.extent(1, 200.0),
            StaggeredTile.extent(1, 200.0),
            StaggeredTile.extent(1, 200.0),
          ],
        )
    );
  }
}