import 'dart:async';

import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PlayerButton extends StatefulWidget {
  var play;
  PlayerButton({this.play});
  @override
  State<StatefulWidget> createState() {
    return PlayerButtonState(play: play);
  }
}

class PlayerButtonState extends State<PlayerButton> {
  var play;
  var code = ResusableCode();
  var percent = 0.0;
  PlayerButtonState({this.play});
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => loopRun());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  playbutton() {
    print("playbutton calling");
    if (play) {
      setState(() {
        play = false;
      });
    } else {
      setState(() {
        play = true;
      });
    }
  }

  loopRun() {
    if (play) {
      if (percent > 1) {
        percent = 0.0;
      } else {
        print("percent:$percent");
        setState(() {
          percent = percent + 0.01;
        });
      }
    }
  }

  volumeUp() {
    print("Volume Up Calling");
  }

  Widget playing() {
    return CircularPercentIndicator(
      radius: 60,
      lineWidth: 2.0,
      percent: percent,
      backgroundColor: Colors.white,
      progressColor: HexColor("#FF0031"),
      center: Container(
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
          ),
        ),
      ),
    );
  }

  Widget pause() {
    percent = 0.0;
    return Container(
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.playbutton,
      onVerticalDragStart: (e) => print(e),
      child: this.play ? playing() : pause(),
    );
  }
}
