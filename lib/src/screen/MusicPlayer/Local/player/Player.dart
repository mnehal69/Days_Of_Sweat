import 'package:days_of_sweat/redux/actions/main_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'FPlayButton.dart';

class PlayerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlayerWidgetState();
  }
}

class PlayerWidgetState extends State<PlayerWidget> {
  final code = ResusableCode();
  bool slide = false;
  @override
  void dispose() {
    super.dispose();
  }

  Widget playBtnWidget(PlayerState state) {
    return Container(
      // color: Colors.grey,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: code.percentageToNumber(context, "50%", false),
            // color: Colors.teal,
            child: Row(
              children: <Widget>[
                Container(
                  width: code.percentageToNumber(context, "15%", false),
                  height: code.percentageToNumber(context, "6%", true),
                  child: Container(
                    // color: Colors.red
                    child: Transform.rotate(
                      angle: 22 / 7,
                      child: FlareActor(
                        'resources/btn.flr',
                        alignment: Alignment.center,
                        animation: state.prevbuttonPress ? "next" : "start",
                        // animation: "next",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                FPlayButton(),
                Container(
                  width: code.percentageToNumber(context, "15%", false),
                  height: code.percentageToNumber(context, "6%", true),
                  child: Container(
                    // color: Colors.red
                    child: Transform.rotate(
                      angle: 0,
                      child: FlareActor(
                        'resources/btn.flr',
                        alignment: Alignment.center,
                        animation: state.prevbuttonPress ? "next" : "start",
                        // animation: "next",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget slider(PlayerState state) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                this.slide = true;
              });
            },
            child: Container(
              // color: Colors.grey,
              margin: EdgeInsets.all(0),

              padding: EdgeInsets.only(
                  left: code.percentageToNumber(context, "3%", false),
                  right: code.percentageToNumber(context, "5%", false)),
              child: FlutterSlider(
                values: [
                  (((state.currentDuration / state.totalDuration) * 100)),
                ],
                jump: true,
                onDragCompleted: (drag, ds, d) {
                  setState(() {
                    slide = false;
                  });
                },
                max: 100,
                min: 0,
                step: 1,
                tooltip: FlutterSliderTooltip(
                  disabled: true,
                ),
                // visibleTouchArea: true,
                handlerHeight: code.percentageToNumber(context, "1.5%", true),
                handlerWidth: code.percentageToNumber(context, "1.5%", true),
                // touchSize: 5,
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  activeTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor("#DC153C"),
                  ),
                  activeTrackBarHeight:
                      code.percentageToNumber(context, "2.5%", false),
                  inactiveTrackBarHeight:
                      code.percentageToNumber(context, "2.5%", false),
                ),
                handler: FlutterSliderHandler(
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor("#DC153C"),
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(40.0),
                          topRight: const Radius.circular(40.0)),
                    ),
                  ),
                ),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  double current = (lowerValue * state.totalDuration) / 100;
                  // StoreProvider.of<PlayerState>(context).dispatch(Audioplayer(
                  //     state.local, current.floor(), state.totalDuration));
                  StoreProvider.of<PlayerState>(context).dispatch(
                    AudioPlaying(state.playing, current.floor()),
                  );
                  state.advancedPlayer
                      .seek(Duration(milliseconds: current.floor()));
                },
              ),
              // ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: code.percentageToNumber(context, "3%", false),
              right: code.percentageToNumber(context, "3%", false),
              top: code.percentageToNumber(context, "2%", true),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  code.durationfromMilliSeconds(state.currentDuration),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Lato",
                    fontSize: code.percentageToNumber(context, "5%", false),
                  ),
                ),
                Text(
                  code.durationfromMilliSeconds(state.totalDuration),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Lato",
                    fontSize: code.percentageToNumber(context, "5%", false),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          width: code.percentageToNumber(context, "99%", false),
          height: code.percentageToNumber(context, "25%", true),
          margin: EdgeInsets.only(
            top: code.percentageToNumber(context, "3%", true),
          ),
          padding: EdgeInsets.only(
            top: code.percentageToNumber(context, "5%", true),
          ),
          // color: Colors.teal,
          child: Column(
            children: <Widget>[
              state.playing ? slider(state) : Container(),
              // slider(state),
              Container(
                // color: Colors.red,
                height: code.percentageToNumber(context, "10%", true),
                child: playBtnWidget(state),
                // child: Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}
