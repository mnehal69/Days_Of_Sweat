import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TitleBar extends StatefulWidget {
  final int days;
  final darkMode;
  TitleBar({this.days, this.darkMode});

  @override
  State<StatefulWidget> createState() {
    return TitleBarState();
  }
}

class TitleBarState extends State<TitleBar> {
  final code = ResusableCode();
  final _battery = Battery();
  var _batteryState;
  var _batteryLevel;

  initState() {
    super.initState();
    _battery.batteryLevel.then((level) {
      this.setState(() {
        _batteryLevel = level;
      });
    });

    _battery.onBatteryStateChanged.listen((BatteryState state) {
      _battery.batteryLevel.then((level) {
        this.setState(() {
          _batteryLevel = level;
          _batteryState = state;
        });
      });
    });
  }

  Widget batteryPercentFinder(context) {
    //print("battery state:$_batteryLevel");
    var state = this._batteryState != null;
    final batteryBoxWidth = 20.0;
    final batteryBoxHeight = 10.0;
    final fontsize = 10.0;
    final borderWidth = 2.0;
    final borderColor = Color.fromRGBO(112, 112, 112, 0.6);
    var batteryColor;
    var percentageNumber;
    var batteryHeight = batteryBoxHeight - (borderWidth + borderWidth);
    if (state) {
      percentageNumber =
          (this._batteryLevel / 100) * (batteryBoxWidth - borderWidth) -
              (borderWidth / 2);
      batteryColor = this._batteryLevel <= 20 ? Colors.red : Colors.black;
    } else {
      percentageNumber = (0 / 100) * (batteryBoxWidth - borderWidth);
      batteryColor = 0 <= 20 ? Colors.red : Colors.black;
    }

    return Container(
      margin: EdgeInsets.only(
        top: 5.0,
      ),
      padding: EdgeInsets.only(right: 5.0),
      width: code.percentageToNumber(context, "15%", false),
      height: code.percentageToNumber(context, "5%", true),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Container(
                width: batteryBoxWidth,
                height: batteryBoxHeight,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(2.0),
                  ),
                  border: Border.all(
                    width: borderWidth,
                    color: borderColor,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: borderWidth - 0.5),
                width: percentageNumber,
                height: batteryHeight,
                decoration: new BoxDecoration(
                  color: batteryColor,
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(1.2),
                  ),
                ),
              ),
              Container(
                width: batteryBoxWidth,
                height: batteryBoxHeight,
                child: state
                    ? _batteryState == BatteryState.charging
                        ? Icon(
                            FontAwesomeIcons.bolt,
                            size: batteryBoxHeight - 5,
                            color: Colors.white,
                          )
                        : Container()
                    : Container(),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.only(
                top: code.percentageToNumber(context, "0.5%", true),
              ),
              width: code.percentageToNumber(context, "0.5%", false),
              height: code.percentageToNumber(context, "0.5%", true),
              color: borderColor),
          Container(
            alignment: Alignment.center,
            height: batteryBoxHeight,
            margin: EdgeInsets.only(left: 5),
            child: Text(
              state ? "${this._batteryLevel}%" : "0%",
              style: TextStyle(
                color: widget.darkMode ? Colors.white : Colors.black,
                fontSize: fontsize,
                fontWeight: FontWeight.bold,
                fontFamily: "Lato",
                // shadows: <Shadow>[
                //   Shadow(
                //     offset: Offset(1.0, 1.0),
                //     blurRadius: 3.0,
                //     color: Color.fromARGB(255, 0, 0, 0),
                //   ),
                // ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: code.percentageToNumber(context, "100%", false),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      left: code.percentageToNumber(context, "15%", false),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize:
                              code.percentageToNumber(context, "8%", false),
                        ),
                        children: [
                          TextSpan(
                            text: widget.days.toString(),
                            style: TextStyle(
                              fontFamily: "Lato",
                              color: HexColor("#FF0000"),
                            ),
                          ),
                          TextSpan(
                            text: " Days of Sweat",
                            style: TextStyle(
                              fontFamily: "Plume",
                              color:
                                  widget.darkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                batteryPercentFinder(context)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
