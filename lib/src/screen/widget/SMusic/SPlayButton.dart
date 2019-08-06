import 'dart:async';
import 'dart:io';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import './../../../../redux/actions/main_actions.dart';
// import 'package:youtube_extractor/youtube_extractor.dart';
import 'package:volume/volume.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:media_notification/media_notification.dart';

class SPlayButton extends StatefulWidget {
  // var play;
  // PlayerButton({this.play});
  @override
  State<StatefulWidget> createState() {
    return SPlayButtonState();
  }
}

class SPlayButtonState extends State<SPlayButton> {
  // var play;
  var code = ResusableCode();
  var percent = 0.0;
  double skewX = 0;
  double skewY = 0;
  double topMargin = 0;
  double bottomMargin = 0;
  double leftMargin = 0;
  double rightMargin = 0;
  var dragging = false;
  // PlayerButtonState({this.play});
  Timer timer;
  int maxVol, currentVol;

  void initState() {
    super.initState();
    updateVolumes();
  }

  updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    setState(() {});
  }

  setVol(int i) async {
    await Volume.setVol(i);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  playbutton(PlayerState state) async {
    //print("object CALLED");
    //print("playbutton calling: ${!state.playing}");
    StoreProvider.of<PlayerState>(context).dispatch(Player(!state.playing));
    if (state.playing) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => loopRun(state));
    } else {
      timer?.cancel();
    }

    AudioPlayer.logEnabled = false;
    if (state.playing) {
      state.advancedPlayer.play(state.songlist[state.index].uri, isLocal: true);
      //print("Music:" + state.songlist[state.index].albumArt);
      try {
        await MediaNotification.show(
            title: state.songlist[state.index].title,
            author: state.songlist[state.index].artist,
            play: true,
            albumArt: state.songlist[state.index].albumArt);
      } on PlatformException {}
    } else {
      state.advancedPlayer.pause().catchError((onError) {
        print("ERROR:$onError");
        state.advancedPlayer.release();
      });
      try {
        await MediaNotification.hide();
      } on PlatformException {}
    }
    MediaNotification.setListener('play', () {
      state.advancedPlayer.resume();
    });
    MediaNotification.setListener('pause', () {
      state.advancedPlayer.pause();
    });
    MediaNotification.setListener('prev', () {
      StoreProvider.of<PlayerState>(context)
          .dispatch(Music(state.songlist, state.index - 1, !state.playing));
      playbutton(state);
    });
    MediaNotification.setListener('next', () {
      StoreProvider.of<PlayerState>(context)
          .dispatch(Music(state.songlist, state.index + 1, !state.playing));
      playbutton(state);
    });

    MediaNotification.setListener('closing', () {
      MediaNotification.hide();
      state.advancedPlayer.stop();
      StoreProvider.of<PlayerState>(context)
          .dispatch(Music(state.songlist, state.index, !state.playing));
      //print("COOL BITCH");
    });

    state.advancedPlayer.onPlayerCompletion.listen((event) {
      //print("Play:${state.playing}+Index:${state.index + 1}");

      StoreProvider.of<PlayerState>(context)
          .dispatch(Music(state.songlist, state.index + 1, !state.playing));
      //StoreProvider.of<PlayerState>(context)
      // .dispatch(Audioplayer(state.local, 0, 0));
      timer?.cancel();
      playbutton(state);
    });
  }

  loopRun(PlayerState state) {
    state.advancedPlayer.onAudioPositionChanged.listen((Duration d) {
      StoreProvider.of<PlayerState>(context).dispatch(
          Audioplayer(state.local, d.inMilliseconds, state.totalDuration));
    });
  }

  Map darkMode(bool darkmode) {
    if (darkmode) {
      return {
        "background": Colors.transparent,
        "FontColor": Colors.white,
        "SelectedColorBackgroundEnd": HexColor("#B100FF"),
        "SelectedColorBackgroundBegin": HexColor("#10DEFF"),
        "SelectedColorShadow": Color.fromRGBO(177, 0, 255, 1),
      };
    } else {
      return {
        "background": Colors.transparent,
        "FontColor": Colors.black,
        "SelectedColorBackgroundBegin": HexColor("#FF0031"),
        "SelectedColorBackgroundEnd": HexColor("##FF4F8C"),
        "SelectedColorShadow": Color.fromRGBO(255, 0, 49, 0.4),
      };
    }
  }

  volumeUp() {
    print("Volume Up Calling");
  }

  Widget playing(PlayerState state) {
    return CircularPercentIndicator(
      radius: 60,
      lineWidth: 2.0,
      percent: state.currentDuration / state.totalDuration,
      backgroundColor: Colors.white,
      progressColor: HexColor("#FF0031"),
      center: AnimatedContainer(
        duration: Duration(milliseconds: 50),
        width: code.percentageToNumber(context, "7%", true),
        height: code.percentageToNumber(context, "7%", true),
        //margin: EdgeInsets.only(left: 5, right: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            new BoxShadow(
                color: Colors.black,
                //color: Colors.transparent,
                blurRadius: 5.0,
                spreadRadius: 2.0,
                offset: new Offset(0, 0)),
          ],
        ),
        child: Center(
          child: Icon(
            FontAwesomeIcons.pause,
            color: HexColor("#FF0031"),
            size: code.percentageToNumber(context, "3%", true),
          ),
        ),
      ),
    );
  }

  Widget pause(PlayerState state) {
    percent = 0.0;
    return AnimatedContainer(
      duration: Duration(milliseconds: 50),
      width: code.percentageToNumber(context, "7%", true),
      height: code.percentageToNumber(context, "7%", true),
      //margin: EdgeInsets.only(left: 5, right: 0),
      decoration: BoxDecoration(
        color: HexColor("#FF0031"),
        shape: BoxShape.circle,
        boxShadow: [
          new BoxShadow(
              color: Colors.black,
              //color: Colors.transparent,
              blurRadius: 5.0,
              spreadRadius: 2.0,
              offset: new Offset(0, 0)),
        ],
      ),
      child: Center(
        child: Icon(
          FontAwesomeIcons.play,
          color: Colors.grey[350],
          size: code.percentageToNumber(context, "3%", true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return !state.playing
            ? AnimatedContainer(
                duration: Duration(milliseconds: 100),
                transform: Matrix4.skew(skewX, skewY),

                //color: Colors.red,
                height: code.percentageToNumber(context, "12%", true),
                margin: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin,
                    bottomMargin), //bottom:20 upar volume kay leye
                child: GestureDetector(
                  onTap: () => this.playbutton(state),
                  onHorizontalDragEnd: (details) {
                    StoreProvider.of<PlayerState>(context)
                        .dispatch(SongChooser(false, false));
                    setState(() {
                      skewX = 0;
                      leftMargin = 0;
                      rightMargin = 0;
                      dragging = false;
                    });
                  },
                  onHorizontalDragUpdate: (details) {
                    if (!dragging) {
                      state.advancedPlayer.release();
                      if (details.delta.dx > 0) {
                        print("Dragging in +X direction");
                        setState(() {
                          skewX = -0.2;
                          leftMargin = 10;
                          dragging = true;
                        });
                        StoreProvider.of<PlayerState>(context)
                            .dispatch(SongChooser(true, false));
                        StoreProvider.of<PlayerState>(context).dispatch(Music(
                            state.songlist, state.index + 1, state.playing));
                        // playbutton(state);
                      } else {
                        print("Dragging in -X direction");
                        setState(() {
                          skewX = 0.2;
                          rightMargin = 10;
                          dragging = true;
                        });
                        StoreProvider.of<PlayerState>(context)
                            .dispatch(SongChooser(false, true));
                        StoreProvider.of<PlayerState>(context).dispatch(Music(
                            state.songlist, state.index - 1, state.playing));
                        // playbutton(state);
                      }
                    }
                  },
                  onVerticalDragStart: (e) => print(e),
                  onVerticalDragCancel: () => print("Dragged Cancel"),
                  onVerticalDragEnd: (details) {
                    print("Dragged End");
                    StoreProvider.of<PlayerState>(context)
                        .dispatch(VolumeC(false, state.volume));
                    setState(() {
                      bottomMargin = 0;
                      skewY = 0;
                      topMargin = 0;
                      skewX = 0;
                    });
                  },
                  //onVerticalDragDown: (e) => print(e),
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      bottomMargin = 0;
                      skewY = 0;
                      topMargin = 0;
                      skewX = 0;
                    });
                    if (details.delta.dy > 0) {
                      print("Dragging in +Y direction"); //vOLUME dOWN
                      setState(
                        () {
                          skewY = 0;
                          topMargin = 25;
                        },
                      );
                      StoreProvider.of<PlayerState>(context)
                          .dispatch(VolumeC(true, state.volume - 1));
                      setVol((((state.volume - 1) / 100) * 15).toInt());
                    } else {
                      print("Dragging in -Y direction"); //Volume UP
                      setState(() {
                        skewY = 0;
                        bottomMargin = 25;
                      });

                      StoreProvider.of<PlayerState>(context)
                          .dispatch(VolumeC(true, state.volume + 1));
                      setVol((((state.volume + 1) / 100) * 15).toInt());
                    }
                  },

                  child: pause(state),
                ),
              )
            : GestureDetector(
                onTap: () => this.playbutton(state),
                child: playing(state),
              );
      },
    );
  }
}
