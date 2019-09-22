import 'dart:async';
import 'dart:math';

import 'package:days_of_sweat/redux/actions/calender_action.dart';
import 'package:days_of_sweat/redux/actions/player_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/Calender/CalenderCell.dart';
import 'package:days_of_sweat/src/screen/Calender/DayModel.dart';
import 'package:days_of_sweat/src/screen/Database/Database.dart';
import 'package:days_of_sweat/src/screen/Database/PlayList.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/common/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:intl/intl.dart';
import 'package:media_notification/media_notification.dart';
import 'package:permission_handler/permission_handler.dart';
import 'hex_color.dart';

class ResusableCode {
  //check if the parameter color is hex code or Colors properties and return it.
  //----------------Example----------------------
  //|                                           |
  //|   colorcheck("#3b5998");                  |
  //|   colorcheck(Colors.red);                 |
  //|-------------------------------------------|
  bool permission = false;
  Timer timer;
  var dayList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  var monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  dynamic colorcheck(color) {
    if (color is Color) {
      return color;
    } else {
      return HexColor(color);
    }
  }

  String durationfromMilliSeconds(int mili) {
    // int milliseconds = 205427;
    DateTime total = new DateTime.fromMillisecondsSinceEpoch(mili);
    int minutes = total.minute;
    int second = total.second;
    //print("Minutes:$minutes.$second");
    if (second < 10) {
      //print("TOTAL:${second}");
      return "$minutes:0$second";
    }
    return "$minutes:$second";
  }

  void mediaNotification(context, MainState state) {
    MediaNotification.setListener('play', () {
      state.advancedPlayer.resume();
      StoreProvider.of<MainState>(context).dispatch(
        AudioPlaying(true, state.currentDuration),
      );
    });
    MediaNotification.setListener('pause', () {
      state.advancedPlayer.pause();
      StoreProvider.of<MainState>(context).dispatch(
        AudioPlaying(false, state.currentDuration),
      );
    });
    MediaNotification.setListener('prev', () {
      StoreProvider.of<MainState>(context).dispatch(
        Player(isAlbum: state.isAlbum, index: state.index - 1),
      );
      state.controller.animateToPage(state.index - 1,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
    });
    MediaNotification.setListener('next', () {
      StoreProvider.of<MainState>(context).dispatch(
        Player(isAlbum: state.isAlbum, index: state.index + 1),
      );
      state.controller.animateToPage(state.index + 1,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
    });

    MediaNotification.setListener('closing', () {
      MediaNotification.hide();
      state.advancedPlayer.stop();
      StoreProvider.of<MainState>(context)
          .dispatch(AudioPlaying(false, state.currentDuration));
      //print("COOL BITCH");
    });
  }

  void playingFromintial(
      {context, MainState state, bool isAlbum, dynamic list = 0}) async {
    StoreProvider.of<MainState>(context)
        .dispatch(Player(index: 0, isAlbum: isAlbum, list: list));
    state.advancedPlayer.onAudioPositionChanged.listen((duration) {
      StoreProvider.of<MainState>(context)
          .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
    });
    state.advancedPlayer.onPlayerCompletion.listen((onData) {
      StoreProvider.of<MainState>(context).dispatch(
          Player(isAlbum: state.isAlbum, index: state.index, list: list));
    });

    StoreProvider.of<MainState>(context).dispatch(NavigateToAction('/player'));
  }

  void random({context, MainState state, bool isAlbum}) {
    var randomNo = new Random().nextInt(state.length);
    // print("Random No:$randomNo");
    StoreProvider.of<MainState>(context)
        .dispatch(Player(index: randomNo, isAlbum: isAlbum));
    // this.showNotification(state);
    state.advancedPlayer.onAudioPositionChanged.listen((duration) {
      StoreProvider.of<MainState>(context)
          .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
    });
    state.advancedPlayer.onPlayerCompletion.listen((onData) {
      var randomNo = new Random().nextInt(state.length);
      StoreProvider.of<MainState>(context).dispatch(Player(
        isAlbum: state.isAlbum,
        index: randomNo,
      ));
    });
    StoreProvider.of<MainState>(context).dispatch(NavigateToAction('/player'));
  }

  void playingFromPosition(
      context, MainState state, int position, bool isAlbum) {
    StoreProvider.of<MainState>(context)
        .dispatch(Player(index: position, isAlbum: isAlbum));

    state.advancedPlayer.onAudioPositionChanged.listen((duration) {
      StoreProvider.of<MainState>(context)
          .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
    });
    state.advancedPlayer.onPlayerCompletion.listen((onData) {
      StoreProvider.of<MainState>(context)
          .dispatch(Player(isAlbum: state.isAlbum, index: state.index));
    });

    StoreProvider.of<MainState>(context).dispatch(NavigateToAction('/player'));
  }

  void storage_checker(dynamic context) async {
    return await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then((onValue) {
      print(onValue);
      if (onValue == PermissionStatus.unknown ||
          onValue == PermissionStatus.denied) {
        PermissionHandler()
            .requestPermissions([PermissionGroup.storage]).then((p) {
          print(p.toString());
          permission = true;
        });
      }
      if (onValue == PermissionStatus.granted) {
        //StoreProvider.of<MainState>(context).dispatch(Permission(true));
        permission = true;
      }
    });
  }

  void playbutton(context, MainState state) async {
    StoreProvider.of<MainState>(context).dispatch(
      AudioPlaying(!state.playing, state.currentDuration),
    );

    if (state.playing) {
      state.advancedPlayer.resume();
      state.advancedPlayer.seek(Duration(milliseconds: state.currentDuration));
    } else {
      state.advancedPlayer.pause().catchError((onError) {
        print("SOMTHING WRONG:$onError");
        state.advancedPlayer.release();
      });
    }
  }

  void prevNextBtn(context, MainState state, int btn) {
    if (btn == -1) {
      StoreProvider.of<MainState>(context)
          .dispatch(Player(index: state.index - 1, isAlbum: state.isAlbum));
    } else {
      StoreProvider.of<MainState>(context)
          .dispatch(Player(index: state.index + 1, isAlbum: state.isAlbum));
    }

    state.advancedPlayer.onAudioPositionChanged.listen((duration) {
      StoreProvider.of<MainState>(context)
          .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
    });
    state.advancedPlayer.onPlayerCompletion.listen((onData) {
      StoreProvider.of<MainState>(context)
          .dispatch(Player(isAlbum: state.isAlbum, index: state.index + 1));
    });
  }

  void creatingPlaylist(dynamic context, List<Song> songs) async {
    // testing();
    DBProvider.db.printTable();
    List<String> type = await DBProvider.db.getType();
    List<List<PlayListModel>> playModelList = [];
    List<List<Song>> playlistAlbum = [];
    // print("type:$type");
    if (type.length > 0) {
      //more than type
      for (int i = 0; i < type.length; i++) {
        playModelList.add(await DBProvider.db.getPlayList(
            type[i])); //get all playlistmodel of that specific type
        // list in which all song of that specific type will be
        List<Song> playlist = [];

        for (int j = 0; j < playModelList[i].length; j++) {
          int id = playModelList[i][j].songID;
          if (contain(id, songs)[0]) {
            playlist.add(contain(id, songs)[1]);
          }
        }
        playlistAlbum.add(playlist);
      }
      // print("PlaylistScreen:${playlistAlbum.toString()}");
    }
    StoreProvider.of<MainState>(context).dispatch(PlayListSection(
        type: type, playList: playlistAlbum, playModelList: playModelList));
  }

  dynamic contain(int id, List<Song> song) {
    for (int i = 0; i < song.length; i++) {
      if (id == song[i].id) {
        return [true, song[i]];
      }
    }
    return [false];
  }

  Iterable<int> get positiveIntegers sync* {
    int i = 2000;
    while (true) yield i++;
  }

  void intializedCalender(
      {BuildContext context,
      MainState state,
      int year,
      int month,
      int selectedDay}) {
    state.calenderlist.removeRange(0, state.calenderlist.length);
    // print("YEAR:${state.year[year]} MONTH:$month DAY:$selectedDay");
    //fIRST DAY INDEX
    var firstdate = new DateTime(state.year[year], month + 1, 1);
    // print("FIRST:$firstdate");

    // print("CHECK:${DateFormat("E").format(firstdate)}");
    var firstDayIndex = dayList.indexOf(DateFormat("E").format(firstdate));
    // print("FirstDayIndex:$firstDayIndex");
    // print(" FIRSTDAY:${firstdate.day}");
    //Last day as it can be 28,30,31
    int lastDayOfMonth = DateTime(state.year[year], month + 2, 0).day;
    // print(" LASTDAY:$lastDayOfMonth");
    int daycounter = 1;
    int counter = 0;
    for (int row = 0; row < 7; row++) {
      for (int column = 0; column < 7; column++) {
        if (row == 0 && column < firstDayIndex ||
            row == 5 && daycounter > lastDayOfMonth && column != 0) {
          // print("day:$daycounter");
          state.calenderlist.add(
            DayModel(
              columnIndex: column,
              rowIndex: row,
            ),
          );
        } else if (row == 5 && daycounter > lastDayOfMonth && column == 0) {
          break;
        } else if (row == 6) {
          state.calenderlist.add(
            DayModel(
              day: dayList[column].substring(0, 1),
              heading: true,
              columnIndex: column,
              rowIndex: row,
            ),
          );
        } else {
          if (selectedDay == daycounter &&
              state.year[state.yearIndex] == year &&
              state.year[state.monthIndex] == month) {
            StoreProvider.of<MainState>(context)
                .dispatch(SelectedIndex(index: counter));
          }
          // print("day Counter:$daycounter");
          if (daycounter > lastDayOfMonth) {
            state.calenderlist.add(
              DayModel(
                columnIndex: column,
                rowIndex: row,
              ),
            );
          } else {
            state.calenderlist.add(
              DayModel(
                columnIndex: column,
                rowIndex: row,
                empty: false,
                day: daycounter.toString(),
                finish: state.finish.contains(daycounter) ? true : false,
                selected: selectedDay == daycounter ? true : false,
                show: state.finish.contains(daycounter) ? true : false,
              ),
            );
          }
          daycounter++;
        }
        counter++;
      }
    }
    //
    StoreProvider.of<MainState>(context).dispatch(
      CalenderList(
        generatedList: List.generate(
          state.calenderlist.length,
          (index) => CalenderCell(
            index: index,
            row: state.calenderlist[index].rowIndex,
            column: state.calenderlist[index].columnIndex,
          ),
        ),
      ),
    );
    //
  }

  double percentageToNumber(BuildContext context, String val, bool height) {
    //height: percentageToNumber(context, "10%", true), [this is going to adjust 10% with respect to height]
    //width: percentageToNumber(context, "30%", false), [this is going to adjust 30% with respect to width ]
    // you can use with margin,padding,width,height or anything which required some double number.
    //
    //Example::
    //Container(
    //       height: code.percentageToNumber(context, "10%", true),
    //       width: code.percentageToNumber(context, "30%", false),
    //       child: Text("data"),
    //       color: Colors.deepOrangeAccent,
    //     ),

    double no = double.parse(val.substring(0, val.length - 1));
    if (height) {
      return ((no / 100) * MediaQuery.of(context).size.height);
    } else {
      return ((no / 100) * MediaQuery.of(context).size.width);
    }
  }

  getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    var random;
    for (var i = 0; i < 6; i++) {
      random = Random().nextInt(16);
      color += letters[random];
    }
    return color;
  }
}
