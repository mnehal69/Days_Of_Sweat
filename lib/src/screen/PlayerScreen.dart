import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/player/BottomButton.dart';
import 'package:days_of_sweat/src/screen/widget/player/Player.dart';
import 'package:days_of_sweat/src/screen/widget/player/PlayerImageSlider.dart';
import 'package:days_of_sweat/src/screen/widget/player/PlayerTitleBar.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:days_of_sweat/redux/actions/main_actions.dart';
import 'package:volume/volume.dart';
import 'dart:async';

class PlayerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlayerScreenState();
  }
}

class PlayerScreenState extends State<PlayerScreen> {
  var code = ResusableCode();
  Timer timer;
  Duration timeforTimer = Duration(seconds: 7);
  bool dragging = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        // For iOS
        statusBarBrightness: Brightness.light,
        // For Android M and higher
        statusBarIconBrightness: Brightness.light,
        statusBarColor: HexColor("#1a1b1f"),
      ),
    );
    // initPlatformState();
  }

  Future<void> initPlatformState() async {
    // pass any stream as parameter as per requirement
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
    int currentVol = await Volume.getVol;
    StoreProvider.of<PlayerState>(context)
        .dispatch(VolumeControl(false, currentVol));
  }

  customHandler() {
    return FlutterSliderHandler(
      decoration: BoxDecoration(),
      child: Container(
        height: 15,
        decoration: BoxDecoration(
          color: HexColor("#1A1B1F"),
          border: Border.all(
              color: HexColor("#DC153C"), style: BorderStyle.solid, width: 3),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
                color: HexColor("#DC153C"),
                spreadRadius: 0.05,
                blurRadius: 5,
                offset: Offset(0, 1))
          ],
        ),
      ),
    );
  }

  Widget volumeBar(context, PlayerState state) {
    return FlutterSlider(
      values: [
        (state.volume / 1.0),
      ],
      rtl: true,
      axis: Axis.vertical,
      jump: true,
      onDragCompleted: (drag, ds, d) {
        print("Dragged Value:$ds");
        setState(() {
          dragging = false;
        });
        timer = new Timer(timeforTimer, () {
          if (!dragging) {
            StoreProvider.of<PlayerState>(context)
                .dispatch(VolumeControl(false, state.volume));
          }
        });
      },
      max: 100,
      min: 0,
      step: 1,
      tooltip: FlutterSliderTooltip(
        disabled: true,
      ),
      // visibleTouchArea: true,
      // handlerHeight: code.percentageToNumber(context, "5%", true),
      // handlerWidth: 200,
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
        activeTrackBarHeight: code.percentageToNumber(context, "2%", false),
        inactiveTrackBarHeight: code.percentageToNumber(context, "1%", false),
      ),
      handler: customHandler(),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        setState(() {
          dragging = true;
        });
        // print("VOlume:$lowerValue");
        StoreProvider.of<PlayerState>(context)
            .dispatch(VolumeControl(true, lowerValue.round()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      onInit: (store) {
        StoreProvider.of<PlayerState>(context)
            .dispatch(Dispose(dispose: false));
      },
      onDidChange: (state) {
        if (state.volumeBarVisible) {
          timer = new Timer(timeforTimer, () {
            if (!dragging) {
              StoreProvider.of<PlayerState>(context)
                  .dispatch(VolumeControl(false, state.volume));
            }
          });
        }
      },
      onDispose: (store) {},
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            StoreProvider.of<PlayerState>(context)
                .dispatch(Dispose(dispose: true));
            return new Future(() => true);
          },
          child: Scaffold(
            body: Material(
              child: Container(
                padding: EdgeInsets.only(
                  top: code.percentageToNumber(context, "3%", true),
                ),
                color: HexColor("#1A1B1F"),
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        PlayerTitleBar(),
                        PlayerImageSlider(),
                        PlayerWidget(),
                        BottomButton(),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: code.percentageToNumber(context, "0%", true),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: state.volumeBarVisible ? 1.0 : 0.0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(top: 0, left: 20, right: 20),
                              height:
                                  code.percentageToNumber(context, "65%", true),
                              alignment: Alignment.centerLeft,
                              child: volumeBar(context, state),
                            ),
                            Container(
                              // color: Colors.teal,
                              width: code.percentageToNumber(
                                  context, "10%", false),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: code.percentageToNumber(
                                    context, "5%", false),
                              ),
                              child: Text(
                                state.volume.round().toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Lato",
                                    fontSize: code.percentageToNumber(
                                        context, "3.4%", true),
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
