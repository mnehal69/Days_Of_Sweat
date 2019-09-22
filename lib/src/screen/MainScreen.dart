import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:days_of_sweat/redux/actions/player_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/Database/Database.dart';
import 'package:days_of_sweat/src/screen/Database/PlayList.dart';
import 'package:days_of_sweat/src/screen/widget/CustomAppBar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:device_calendar/device_calendar.dart';

import 'Calender/Calender.dart';
import 'MusicPlayer/Local/SMusic/music_player.dart';
import 'MusicPlayer/Local/common/song.dart';
import 'common/ReusableCode.dart';
import 'common/hex_color.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          // For iOS
          statusBarBrightness: Brightness.light,
          // For Android M and higher
          statusBarIconBrightness: Brightness.light,
          statusBarColor: HexColor("#1a1b1f")),
    );

    AudioPlayer.logEnabled = false;
    checker();
    WidgetsBinding.instance.addObserver(this);
    // print("COLOR:${code.getRandomColor()}");
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

  Future<dynamic> _getMusicList(dynamic context) async {
    List<Song> _songs;

    // print("GETMUSICLIST:$storageAccess && $calenderAccess");
    if (storageAccess) {
      try {
        _songs = await allSongs(await MusicList.invokeMethod('getMusicList'));
        // print("SONGS:${_songs.toString()}");
        StoreProvider.of<MainState>(context).dispatch(
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

    StoreProvider.of<MainState>(context).dispatch(
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
      body: new StoreConnector<MainState, MainState>(
        converter: (store) => store.state,
        onInit: (store) {
          print("${this.currentDate.toString()}");
        },
        builder: (context, state) {
          return Material(
            child: Container(
              width: code.percentageToNumber(context, "100%", true),
              height: code.percentageToNumber(context, "100%", true),
              color: HexColor("#1a1b1f"),
              margin: EdgeInsets.only(
                top: code.percentageToNumber(context, "3%", true),
              ),
              // child: Stack(
              //   children: [
              child: Container(
                // color: Colors.red,
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    // TitleBar(
                    //   days: 0,
                    //   darkMode: darkMode,
                    // ),
                    CustomAppBar2(
                      year: state.year.indexOf(currentDate.year),
                      month: currentDate.month - 1,
                      day: currentDate.day,
                    ),
                    Calender(),
                    Container(
                      height: code.percentageToNumber(context, "27%", true),
                      margin: EdgeInsets.only(
                        left: code.percentageToNumber(context, "2%", false),
                      ),
                      child: state.index != -1 ? MusicPlayer() : Container(),
                    ),
                    // Detail(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
