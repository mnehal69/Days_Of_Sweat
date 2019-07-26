import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widget/title.dart';
import './widget/Appbar.dart';
import './widget/Calender.dart';
import './widget/Detail.dart';
import './widget/music_player.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  final size = 30.0;

  var currentDate = new DateTime.now();
  var darkMode = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Material(
      child: Container(
        color: darkMode ? Colors.black : Colors.white,
        child: Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    TitleBar(
                      days: 0,
                      darkMode: darkMode,
                    ),
                    CustomAppBar(
                      year: currentDate.year,
                      month: currentDate.month,
                      darkMode: darkMode,
                    ),
                    Calender(
                      selectedDay: currentDate.day,
                      selectedMonth: currentDate.month,
                      selectedYear: currentDate.year,
                      darkMode: darkMode,
                      show: false,
                    ),
                    Detail(),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: MusicPlayer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
