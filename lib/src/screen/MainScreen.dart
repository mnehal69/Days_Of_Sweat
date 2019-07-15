import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widget/title.dart';
import './widget/Appbar.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  final size = 30.0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Material(
      child: Container(
        margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
        child: Column(
          children: <Widget>[
            TitleBar(
              days: 50,
            ),
            CustomAppBar(),
          ],
        ),
      ),
    );
  }
}
