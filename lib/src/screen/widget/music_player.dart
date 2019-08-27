import 'dart:async';

import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/SMusic/SMusicMain.dart';
import 'package:days_of_sweat/src/screen/widget/Song/song.dart';
import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import './../../../redux/actions/main_actions.dart';
import 'FMusic/main_screen/FMusicMain.dart';

class MusicPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MusicPlayerState();
  }
}

class MusicPlayerState extends State<MusicPlayer> {
  String imageUrl, title, author;
  var code = ResusableCode();
  var counter = 0;
  //#FF0031
  //#150f1e
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      onWillChange: (state) {
        print(
            "First Time: ${state.counter} && Dispose: ${state.fullPlayerDispose}====${state.fullPlayerDispose && state.counter == 0}");
        if (state.fullPlayerDispose && state.counter == 0) {
          state.advancedPlayer.onAudioPositionChanged.listen((duration) {
            StoreProvider.of<PlayerState>(context)
                .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
          });
          state.advancedPlayer.onPlayerCompletion.listen((onData) {
            StoreProvider.of<PlayerState>(context)
                .dispatch(Player(isAlbum: state.isAlbum, index: state.index));
          });
          StoreProvider.of<PlayerState>(context).dispatch(Dispose(
              dispose: state.fullPlayerDispose, counter: state.counter + 1));
        }
      },
      builder: (context, state) {
        state.audioCache.fixedPlayer = state.advancedPlayer;

        // print("FULLMUSICMAIN:${state.expand} && ${state.dragging}");
        return GestureDetector(
          onVerticalDragStart: (detail) {
            StoreProvider.of<PlayerState>(context)
                .dispatch(NavigateToAction.push('/music'));
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: code.percentageToNumber(context, "16%", true),
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: code.percentageToNumber(context, "16%", true),
                  width: code.percentageToNumber(context, "98%", false),
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
                  margin: EdgeInsets.only(
                    top: code.percentageToNumber(context, "0.5%", true),
                    left: code.percentageToNumber(context, "1%", false),
                  ),
                  height: code.percentageToNumber(context, "15.5%", true),
                  width: code.percentageToNumber(context, "97%", false),
                  decoration: BoxDecoration(
                    color: HexColor("#1a1b1f"),
                    //color: Colors.transparent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(65.0),
                    ),
                  ),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    child: SMusicMain(),
                    // child: Container(),
                    opacity: 1.0,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
