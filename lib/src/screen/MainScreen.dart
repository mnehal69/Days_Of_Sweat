import 'package:audioplayers/audioplayers.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './widget/title.dart';
import './widget/Appbar.dart';
import './widget/Calender.dart';
import './widget/Detail.dart';
import './widget/music_player.dart';
import 'package:volume/volume.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  final size = 30.0;
  var currentDate = new DateTime.now();
  var darkMode = false;
  var code = ResusableCode();

  String volumeText(int volume) {
    if (volume >= 0 && volume <= 100) {
      return "${volume.toString()}%";
    } else {
      if (volume < 0) {
        return "0%";
      } else {
        return "100%";
      }
    }
  }

  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    AudioPlayer.logEnabled = false;
    return Scaffold(
//      key: _scaffoldKey,
      // bottomSheet: Container(),
      body: new StoreConnector<PlayerState, PlayerState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Material(
            child: Container(
              color: darkMode ? Colors.black : Colors.white,
              // child: Container(
              //   margin: EdgeInsets.only(top: 5.0),
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
                  //VOLUME  CONTROLLER
                  Positioned(
                    top: code.percentageToNumber(context, "30%", true),
                    left: code.percentageToNumber(context, "30%", false),
                    right: code.percentageToNumber(context, "30%", false),
                    bottom: code.percentageToNumber(context, "30%", true),
                    child: AnimatedOpacity(
                      opacity: state.volumeBar ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        width: code.percentageToNumber(context, "100%", false),
                        height: code.percentageToNumber(context, "100%", true),
                        alignment: Alignment.center,
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Icon(
                              state.volume == 0
                                  ? FontAwesomeIcons.volumeOff
                                  : state.volume < 61 && state.volume > 0
                                      ? FontAwesomeIcons.volumeDown
                                      : FontAwesomeIcons.volumeUp,
                              size:
                                  code.percentageToNumber(context, "10%", true),
                            ),
                            Text(
                              volumeText(state.volume),
                              style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: "Roboto-Bold",
                                  fontSize: code.percentageToNumber(
                                      context, "5%", true)),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: MusicPlayer(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
