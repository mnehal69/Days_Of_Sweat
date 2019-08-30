import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:days_of_sweat/redux/actions/main_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/Database/Database.dart';
import 'package:days_of_sweat/src/screen/Database/PlayList.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import './widget/title.dart';
import './widget/Appbar.dart';

import './widget/Detail.dart';

import 'Calender/Calender.dart';
import 'MusicPlayer/Local/SMusic/music_player.dart';
import 'MusicPlayer/Local/common/song.dart';
import 'common/ReusableCode.dart';

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
  var dragged = false;
  bool storageAccess = false;
  bool calenderAccess = false;
  int count = 0;
  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    // print("APP LIFECYCLE:$state");
  }

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
      // print("Permission:" + p.toString());
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
      // print("CHECK STORAGE YERS");
      setState(() {
        storageAccess = true;
        calenderAccess = true;
      });
      _getMusicList(context);
    } else {
      Toast.show("Failed to get access", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      setState(() {
        storageAccess = false;
        calenderAccess = false;
      });
      permissionRequired(_getMusicList);
    }
  }

  void initState() {
    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    //FlutterStatusbarcolor.setStatusBarColor(Colors.white);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          // For iOS
          statusBarBrightness: Brightness.dark,
          // For Android M and higher
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white),
    );
    AudioPlayer.logEnabled = true;
    checker();
    WidgetsBinding.instance.addObserver(this);
  }

  static const MusicList = const MethodChannel('MusicList');

  static Future<dynamic> allSongs(List<dynamic> songs) {
    var completer = new Completer();
    //print(songs.runtimeType);
    var mySongs = songs.map((m) => new Song.fromMap(m)).toList();
    //print("ALLSONGS:" + mySongs.toString());
    completer.complete(mySongs);
    return completer.future;
  }

  void testing() async {
    DBProvider.db.addNewPlaylistIndex(
        new PlayListModel(id: 0, songID: 249, type: 'Favourite'));
    DBProvider.db
        .addNewPlaylistIndex(new PlayListModel(id: 1, songID: 253, type: 'My'));
    DBProvider.db
        .addNewPlaylistIndex(new PlayListModel(id: 2, songID: 250, type: 'My'));
    DBProvider.db.addNewPlaylistIndex(
        new PlayListModel(id: 3, songID: 252, type: 'Sad'));
  }

  // void creatingPlaylist(dynamic context, List<Song> songs) async {
  //   // testing();
  //   DBProvider.db.printTable();
  //   List<String> type = await DBProvider.db.getType();
  //   List<List<PlayListModel>> playModelList = [];
  //   List<List<Song>> playlistAlbum = [];
  //   // print("type:$type");
  //   if (type.length > 0) {
  //     //more than type
  //     for (int i = 0; i < type.length; i++) {
  //       playModelList.add(await DBProvider.db.getPlayList(
  //           type[i])); //get all playlistmodel of that specific type
  //       // list in which all song of that specific type will be
  //       List<Song> playlist = [];

  //       for (int j = 0; j < playModelList[i].length; j++) {
  //         int id = playModelList[i][j].songID;
  //         if (contain(id, songs)[0]) {
  //           playlist.add(contain(id, songs)[1]);
  //         }
  //       }
  //       playlistAlbum.add(playlist);
  //     }
  //     // print("PlaylistScreen:${playlistAlbum.toString()}");
  //   }
  //   StoreProvider.of<PlayerState>(context).dispatch(PlayListSection(
  //       type: type, playList: playlistAlbum, playModelList: playModelList));
  // }

  // dynamic contain(int id, List<Song> song) {
  //   for (int i = 0; i < song.length; i++) {
  //     if (id == song[i].id) {
  //       return [true, song[i]];
  //     }
  //   }
  //   return [false];
  // }

  Future<dynamic> _getMusicList(dynamic context) async {
    List<Song> _songs;

    // print("GETMUSICLIST:$storageAccess && $calenderAccess");
    if (storageAccess) {
      try {
        _songs = await allSongs(await MusicList.invokeMethod('getMusicList'));
        // print("SONGS:${_songs.toString()}");
        StoreProvider.of<PlayerState>(context).dispatch(
          SongList(_songs, -1),
        );
        code.creatingPlaylist(context, _songs);
        _getArtistList(context, _songs);

        // print("music Length: ${_songs.length}");
      } on PlatformException catch (e) {
        print("Failed to get music List ${e.message}");
      }
    } else {
      Toast.show("Storage Permission Not Accesible", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<dynamic> _getArtistList(dynamic context, List<Song> song) async {
    List<List<Song>> _artistList =
        []; //Seperation of songs from songList in order specified in artistDone
    List<String> artistDone = []; //Name of artist
    List<List<String>> artistShowList = []; //Album Display
    String artistName;
    for (int i = 0; i < song.length; i++) {
      artistName = song[i].artist;
      //print(artistName);
      if (!artistDone.contains(artistName) || artistDone.isEmpty) {
        List<Song> artist = [];
        List<String> info = [];
        int duration = 0;
        for (int j = 0; j < song.length; j++) {
          //print(
          //    "Song[$j]:${song[j].artist} == $artistName === ${song[j].artist.compareTo(artistName) == 0}");
          if (song[j].artist.compareTo(artistName) == 0) {
            artist.add(song[j]);
            duration = duration + song[j].duration;
          }
        }
        info.add(artist[0].artist);
        info.add(artist.length.toString());
        info.add(duration.toString());
        info.add(artist[0].albumArt);
        artistShowList.add(info);
        _artistList.add(artist);
        artistDone.add(artistName);
      }
    }
    // print(artistShowList.toString());
    //print(artistDone.toString());
    // print(_artistList[0].toString());

    StoreProvider.of<PlayerState>(context).dispatch(
      // Artist(artistShowList, _artistList, 1),
      ArtistAlbum(artistShowList, _artistList, 0),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      key: _scaffoldKey,
      // bottomSheet: Container(),
      body: new StoreConnector<PlayerState, PlayerState>(
        converter: (store) => store.state,
        onInit: (store) {},
        builder: (context, state) {
          return Material(
            child: Container(
              color: darkMode ? Colors.black : Colors.white,
              // child: Container(
              margin: EdgeInsets.only(
                top: code.percentageToNumber(context, "5%", true),
              ),
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
                      opacity: state.volumeBarVisible ? 1.0 : 0.0,
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
                  /** Bottom Music Player */
                  state.index != -1
                      ? Container(
                          alignment: Alignment.bottomRight,
                          child: MusicPlayer(),
                        )
                      : Container(
                          alignment: Alignment.bottomCenter,
                          //color: Colors.green,
                          child: GestureDetector(
                            onVerticalDragStart: (detail) {
                              StoreProvider.of<PlayerState>(context).dispatch(
                                  ScrollBar(shown: false, isAlbum: false));

                              StoreProvider.of<PlayerState>(context)
                                  .dispatch(NavigateToAction.push('/music'));
                            },
                            child: Container(
                              width: code.percentageToNumber(
                                  context, "100%", false),
                              height:
                                  code.percentageToNumber(context, "15%", true),
                              //color: Colors.red,
                              // alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                bottom: code.percentageToNumber(
                                    context, "2%", true),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: code.percentageToNumber(
                                        context, "50%", false),
                                    height: code.percentageToNumber(
                                        context, "10%", true),
                                    //color: Colors.yellow,
                                    child: FlareActor(
                                      'resources/dropdown3.flr',
                                      alignment: Alignment.center,
                                      animation: "loop",
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Text(
                                    "Swipe up for music",
                                    style: TextStyle(
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.bold,
                                      fontSize: code.percentageToNumber(
                                          context, "2.5%", true),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
