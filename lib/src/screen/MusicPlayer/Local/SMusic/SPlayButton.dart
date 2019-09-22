import 'dart:async';
import 'package:days_of_sweat/redux/actions/player_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:youtube_extractor/youtube_extractor.dart';

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

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

  Widget playing(MainState state) {
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

  Widget pause(MainState state) {
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
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      onWillChange: (state) {
        // if (!state.playing && state.fullPlayerDispose) {
        //   StoreProvider.of<MainState>(context).dispatch(ChangeSong(btn: 0));
        //   setState(() {
        //     skewX = 0;
        //     leftMargin = 0;
        //     rightMargin = 0;
        //     dragging = false;
        //   });
        // }
      },
      builder: (context, state) {
        return !state.playing
            ? AnimatedContainer(
                duration: Duration(milliseconds: 100),
                transform: Matrix4.skew(skewX, skewY),
                height: code.percentageToNumber(context, "12%", true),
                margin: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin,
                    bottomMargin), //bottom:20 upar volume kay leye
                child: GestureDetector(
                  onTap: () => code.playbutton(context, state),
                  onHorizontalDragEnd: (details) {
                    var isLeft = state.prevbuttonPress;
                    StoreProvider.of<MainState>(context)
                        .dispatch(ChangeSong(btn: 0));
                    setState(() {
                      skewX = 0;
                      leftMargin = 0;
                      rightMargin = 0;
                      dragging = false;
                    });
                    if (isLeft) {
                      code.prevNextBtn(context, state, -1);
                    } else {
                      code.prevNextBtn(context, state, 1);
                    }
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
                        StoreProvider.of<MainState>(context)
                            .dispatch(ChangeSong(btn: 1));
                      } else {
                        print("Dragging in -X direction");
                        setState(() {
                          skewX = 0.2;
                          rightMargin = 10;
                          dragging = true;
                        });
                        StoreProvider.of<MainState>(context)
                            .dispatch(ChangeSong(btn: -1));
                      }
                    }
                  },
                  onVerticalDragStart: (e) => print(e),
                  onVerticalDragCancel: () => print("Dragged Cancel"),
                  onVerticalDragEnd: (details) {
                    print("Dragged End");
                    // StoreProvider.of<MainState>(context)
                    //     .dispatch(VolumeC(false, state.volume));
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
                      // StoreProvider.of<MainState>(context)
                      //     .dispatch(VolumeC(true, state.volume - 1));
                      // setVol((((state.volume - 1) / 100) * 15).toInt());
                    } else {
                      print("Dragging in -Y direction"); //Volume UP
                      setState(() {
                        skewY = 0;
                        bottomMargin = 25;
                      });

                      // StoreProvider.of<MainState>(context)
                      //     .dispatch(VolumeC(true, state.volume + 1));
                      // setVol((((state.volume + 1) / 100) * 15).toInt());
                    }
                  },

                  child: pause(state),
                ),
              )
            : GestureDetector(
                // onTap: () => this.playbutton(state),
                onTap: () => code.playbutton(context, state),
                child: playing(state),
              );
      },
    );
  }
}
