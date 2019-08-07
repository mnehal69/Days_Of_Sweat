import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:days_of_sweat/redux/actions/main_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/Song/song.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:media_notification/media_notification.dart';
import 'package:permission_handler/permission_handler.dart';
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

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final size = 30.0;
  var currentDate = new DateTime.now();
  var darkMode = false;
  var code = ResusableCode();
  List<Song> songs = [];
  AppLifecycleState _lastLifecycleState;
  bool storageAccess = false;
  bool calenderAccess = false;
  @override
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

  void permissionRequired(func) {
    PermissionHandler().requestPermissions(
        [PermissionGroup.storage, PermissionGroup.calendar]).then((p) {
      print("Permission:" + p.toString());
      if (p[0] == PermissionStatus.granted &&
          p[1] == PermissionStatus.granted) {
        setState(() {
          storageAccess = true;
          calenderAccess = true;
        });
        func(context);
      } else {
        checker();
      }
    });
  }

  void checker() async {
    PermissionStatus storage = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    PermissionStatus calender = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.calendar);
    if (storage == PermissionStatus.granted &&
        calender == PermissionStatus.granted) {
      //print("CHECK STORAGE YERS");
      setState(() {
        storageAccess = true;
        calenderAccess = true;
      });
      _getMusicList(context);
    } else {
      Fluttertoast.showToast(
          msg: "Failed to get access",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 3);
      setState(() {
        storageAccess = false;
        calenderAccess = false;
      });
      permissionRequired(_getMusicList);
    }
  }

  void initState() {
    super.initState();
    checker();
  }

  static const MusicList = const MethodChannel('MusicList');
  static Future<dynamic> allSongs(List<dynamic> songs) async {
    var completer = new Completer();
    //print(songs.runtimeType);
    var mySongs = songs.map((m) => new Song.fromMap(m)).toList();
    completer.complete(mySongs);
    return completer.future;
  }

  Future<dynamic> _getMusicList(dynamic context) async {
    List<Song> _songs;
    if (storageAccess) {
      try {
        try {
          _songs = await allSongs(await MusicList.invokeMethod('getMusicList'));
          print(_songs.toList());
        } catch (e) {
          print("Failed to get songs: '${e.message}'.");
        }
        //print("music Length: ${_songs.runtimeType}");
      } on PlatformException catch (e) {
        print("Failed to get music List ${e.message}");
      }
    } else {
      Fluttertoast.showToast(
          msg: "Storage Permission Not Accesible",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 3);

      //_getMusicList(context);
    }
    setState(() {
      songs = _songs;
    });
    StoreProvider.of<PlayerState>(context).dispatch(Music(_songs, 0, false));
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    //print("LAST LIFE CYCLE:$_lastLifecycleState");
    //MediaNotification.hide();
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
