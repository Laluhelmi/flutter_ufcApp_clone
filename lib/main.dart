import 'dart:typed_data';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String lastCoordinate = "";
  double leftMargin = 0;
  double firstDx = 0;
  int animDuration = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
    print("clicked");
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    print("position update " + update.globalPosition.toString());
    lastCoordinate = update.globalPosition.toString();
    double dx = update.localPosition.dx - firstDx;
    print("hasil dx " + dx.toString());
    if (dx > 0) {
      setState(() {
        leftMargin = dx;
      });
    } else if (dx <= 0) {
      setState(() {
        leftMargin = 0;
      });
    }
  }

  List<String> side_menus = [
    "FIGHT LIBRARY",
    "FIGHT PASS SCHEDULE",
    "SEARCH",
    "FAVORITES",
    "HISTORY"
  ];
  List<String> side_menus2 = [
    "PREFERENCES",
    "FAQ",
    "PRIVASI POLICE",
    "TERM OF SERVICE"
  ];

  List<Widget> menuWidgets() {
    List<Widget> menus = new List();
    side_menus.forEach((menu) {
      menus.add(Padding(
          padding: EdgeInsets.only(left: 15, bottom: 10),
          child: Text(menu,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))));
    });

    side_menus2.forEach((menu) {
      menus.add(Padding(
          padding: EdgeInsets.only(left: 15, bottom: 10),
          child: Text(menu,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Color(0xffd9dbda)))));
    });
    return menus;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Stack(
        children: <Widget>[
          AnimatedPositioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            duration: Duration(milliseconds: 0),
            child: GestureDetector(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      //  mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: menuWidgets(),
                    )),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 2,
                      color: Color(0xfff5faf7),
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffc5c9c7)),
                            ),
                            Text("10.4.0(203)",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffc5c9c7)))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          MoveableStackItem(),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MoveableStackItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState();
  }
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition = 0;
  double yPosition = 0;
  int animDuration = 0;
  bool isDragTrue =
      false; //untuk mengetahui apakah user geser mulai dari pojok kiri
  bool isSwiped = false; // untuk mengetahui apakah drawer sudah
  Color color;
  @override
  void initState() {
    //color = RandomColor().randomColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      onEnd: () {
        animDuration = 0;
      },
      duration: Duration(milliseconds: animDuration),
      top: 0,
      left: xPosition,
      child: GestureDetector(
        onPanStart: (info) {
          if (info.globalPosition.dx < 30 || isSwiped) {
            isDragTrue = true;
            isSwiped = false;
          }
        },
        onPanEnd: (info) {
          if (xPosition <= MediaQuery.of(context).size.width / 2 &&
              isDragTrue) {
            setState(() {
              animDuration = 200;
              xPosition = 0;
            });
          } else if (isDragTrue) {
            setState(() {
              animDuration = 200;
              xPosition = MediaQuery.of(context).size.width / 2;
            });
            isSwiped = true;
          }
          isDragTrue = false;
        },
        onPanUpdate: (tapInfo) {
          if (isDragTrue) {
            double dx = xPosition;
            //  print("delta " + tapInfo.delta.dx.toString());
            dx += tapInfo.delta.dx;
            if (dx <= 0) {
              setState(() {
                //  yPosition += tapInfo.delta.dy;
                xPosition = 0;
              });
            } else if (dx <= (MediaQuery.of(context).size.width / 2) + 10) {
              setState(() {
                //  yPosition += tapInfo.delta.dy;
                xPosition = dx;
              });
            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          child: Stack(
            children: <Widget>[
              Positioned(
                child: AspectRatio(
                  aspectRatio: 8 / 5,
                  child: Container(
                    color: Colors.green,
                    child: Image.asset(
                      'assets/poster/ufc-241.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                  child: Container(
                height: 40,
              ))
            ],
          ),

          // color: Colors.black,
          decoration: leftContainerDecoration(),
        ),
      ),
    );
  }

  //shadow top appbar
  Widget appBarShadow() {
    return Container(
      color: Colors.blue,
    );
  }

  //shadow kiri di container
  BoxDecoration leftContainerDecoration() {
    return BoxDecoration(
      color: Colors.black,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(1.0),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }
}
