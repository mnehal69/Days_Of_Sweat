import 'dart:async';

import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/FMusic/FMusicMain.dart';
import 'package:days_of_sweat/src/screen/widget/SMusic/SMusicMain.dart';
import 'package:days_of_sweat/src/screen/widget/Song/song.dart';
import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import './../../../redux/actions/main_actions.dart';

class MusicPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MusicPlayerState();
  }
}

class MusicPlayerState extends State<MusicPlayer> {
  String imageUrl, title, author;
  var code = ResusableCode();
  var dragged = false;

  //#FF0031
  //#150f1e
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        state.audioCache.fixedPlayer = state.advancedPlayer;
        print("FULLMUSICMAIN:${state.expand} && ${state.dragging}");
        return GestureDetector(
          onVerticalDragUpdate: (detail) {
            StoreProvider.of<PlayerState>(context)
                .dispatch(Expanding(true, false));
            if (!dragged) {
              if (detail.delta.dy < 0) {
                setState(() {
                  dragged = true;
                });
              }
              if (detail.delta.dy > 0) {
                StoreProvider.of<PlayerState>(context)
                    .dispatch(Expanding(false, true));
                setState(() {
                  dragged = true;
                });
              }
            }
          },
          onVerticalDragEnd: (detail) {
            StoreProvider.of<PlayerState>(context)
                .dispatch(Expanding(true, false));
            setState(() {
              dragged = false;
            });
            state.advancedPlayer.onAudioPositionChanged.listen((d) {
              StoreProvider.of<PlayerState>(context).dispatch(Audioplayer(
                  state.local, d.inMilliseconds, state.totalDuration));
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: state.expand
                ? code.percentageToNumber(context, "100%", true)
                : code.percentageToNumber(context, "16%", true),
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: !state.expand
                      ? code.percentageToNumber(context, "16%", true)
                      : 0,
                  width: !state.expand
                      ? code.percentageToNumber(context, "98%", false)
                      : 0,
                  decoration: BoxDecoration(
                    color: HexColor("#FF0031"),
                    boxShadow: [
                      new BoxShadow(
                          color: HexColor("#FF0031"),
                          //color: Colors.transparent,
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                          offset: new Offset(0, 0)),
                    ],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(65.0),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  margin: !state.expand
                      ? EdgeInsets.only(
                          top: code.percentageToNumber(context, "0.5%", true),
                          left: code.percentageToNumber(context, "1%", false),
                        )
                      : EdgeInsets.all(0),
                  height: !state.expand
                      ? code.percentageToNumber(context, "15.5%", true)
                      : code.percentageToNumber(context, "100%", true),
                  width: !state.expand
                      ? code.percentageToNumber(context, "97%", false)
                      : code.percentageToNumber(context, "100%", false),
                  decoration: BoxDecoration(
                    color: HexColor("#150f1e"),
                    //color: Colors.transparent,
                    shape: BoxShape.rectangle,
                    borderRadius: !state.expand
                        ? BorderRadius.only(
                            topLeft: Radius.circular(65.0),
                          )
                        : BorderRadius.zero,
                  ),
                  child: state.songlist.length <= 0
                      ? Container(
                          //color: Colors.red,
                          alignment: Alignment.center,
                          child: Text(
                            "No Music Found",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Lato",
                            ),
                          ),
                        )
                      : state.expand
                          ? FMusicMain()
                          : AnimatedOpacity(
                              duration: Duration(milliseconds: 500),
                              child: SMusicMain(),
                              opacity: state.expand ? 0.0 : 1.0,
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
