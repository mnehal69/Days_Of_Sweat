import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TitleBar extends StatefulWidget {
  final int days;
  TitleBar({this.days});

  @override
  State<StatefulWidget> createState() {
    return TitleBarState();
  }
}

class TitleBarState extends State<TitleBar> {
  final code = ResusableCode();
  final battery = Battery();
  var _batteryState;
  var _batteryLevel;

  Widget batteryPercentFinder(int percentage) {
    final batteryBoxWidth = 30.0;
    final batteryBoxHeight = 15.0;
    final borderWidth = 2.0;
    final borderColor = HexColor("#707070");
    var percentageNumber = (percentage / 100) * batteryBoxWidth;
    var batteryHeight = batteryBoxHeight - (borderWidth + borderWidth);
    var batteryColor = percentage < 20
        ? Colors.red
        : percentage > 20 && percentage < 70
            ? HexColor("#E2E900")
            : Colors.green;

    return Container(
      margin: EdgeInsets.only(right: 5.0),
      child: Row(
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
                  )),
              Container(
                margin: EdgeInsets.only(left: borderWidth),
                color: batteryColor,
                width: percentageNumber,
                height: batteryHeight,
              ),
              Container(
                width: batteryBoxWidth,
                child: Icon(
                  FontAwesomeIcons.bolt,
                  size: batteryHeight,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              percentage.toString() + "%",
              style: TextStyle(
                color: batteryColor,
                fontSize: batteryBoxHeight + 4,
                fontWeight: FontWeight.bold,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                batteryPercentFinder(60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
