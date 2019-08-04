import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Day extends StatelessWidget {
  final day;
  final bool finish;
  final selected;
  final rowSelected;
  final columnSelected;
  final heading;
  final code = ResusableCode();
  final size = 14.0;
  final unselectedColor = Colors.cyan;
  final weekday;
  final bool empty;
  final bool darkmode;
  final bool show;

  Day({
    this.darkmode = false,
    this.empty = false,
    this.day = "",
    this.finish = false,
    this.selected = false,
    this.rowSelected = false,
    this.columnSelected = false,
    this.heading = false,
    this.weekday = "",
    this.show = false,
  });

  Color taskDone() {
    if (finish) {
      return Colors.grey[200];
    } else {
      return Colors.transparent;
    }
  }

  Color header() {
    if (heading && columnSelected) {
      return HexColor("#827D7D");
    } else if (heading) {
      return darkmode ? Colors.white : HexColor("BFBFBF");
    } else {
      return Colors.black;
    }
  }

  Map darkMode() {
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

  Widget tape(context) {
    if (this.rowSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                new BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    //color: Colors.transparent,
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    offset: new Offset(12, 5)),
              ],
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(
                bottom: code.percentageToNumber(context, "1.7%", true),
                top: code.percentageToNumber(context, "1.7%", true)),
            margin: EdgeInsets.only(
                top: code.percentageToNumber(context, "1%", true)),
            child: Text(
              day.toString(),
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: size,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ],
      );
    } else if (this.columnSelected) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: heading || empty
                  ? Color.fromRGBO(0, 0, 0, 0.1)
                  : Colors.black26,
              //color: Colors.transparent,
              blurRadius: 3.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        height: code.percentageToNumber(context, "8%", true),
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            left: code.percentageToNumber(context, "2%", false),
            right: code.percentageToNumber(context, "2%", false)),
        child: Text(
          day.toString(),
          style: TextStyle(
            fontFamily: "Roboto-Regular",
            fontSize: size,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            color: header(),
          ),
        ),
      );
    } else {
      return Text("");
    }
  }

  Widget cell() {
    if (this.show) {
      return Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
              image: new AssetImage('resources/delete.png'),
              fit: BoxFit.cover,
            )),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              day.toString(),
              style: TextStyle(
                // color: darkMode()["FontColor"],
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
                fontFamily: "Roboto-Regular",
                fontSize: size,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        day.toString(),
        style: TextStyle(
          color: darkMode()["FontColor"],
          fontFamily: "Roboto-Regular",
          fontSize: size,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("Day:$day + show:$show");
    if (selected) {
      return AnimatedContainer(
        duration: new Duration(milliseconds: 500),
        // color: Colors.teal,
        color: darkMode()["background"],
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Container(
              color: darkMode()["background"],
              margin: EdgeInsets.only(
                left: code.percentageToNumber(context, "1%", false),
                right: code.percentageToNumber(context, "1%", false),
              ),
              height: code.percentageToNumber(context, "7%", true),
            ),
            Container(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              margin: EdgeInsets.only(
                  top: code.percentageToNumber(context, "0%", true)),
              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                      color: darkMode()["SelectedColorShadow"],
                      //color: Colors.transparent,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset: new Offset(0, 0)),
                ],
                // color: darkMode()["SelectedColorBackground"],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    darkMode()["SelectedColorBackgroundBegin"],
                    darkMode()["SelectedColorBackgroundEnd"],
                  ],
                ),
                //color: Colors.transparent,
                borderRadius: new BorderRadius.all(
                  const Radius.circular(5.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      //color: Colors.black,
                      fontFamily: "Roboto-Bold",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  Text(
                    this.weekday,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Roboto-Light",
                      fontSize: size,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: code.percentageToNumber(context, "8%", true),
        //color: Colors.teal,
        color: darkMode()["background"],
        padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
        child: Stack(
          children: [
            Container(
              color: this.show ? Colors.transparent : taskDone(),
              // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              margin:
                  EdgeInsets.all(code.percentageToNumber(context, "1%", false)),
              child: Center(
                child:
                    // child: Text(
                    //   day.toString(),
                    //   style: TextStyle(
                    //     color: darkMode()["FontColor"],
                    //     fontFamily: "Roboto-Regular",
                    //     fontSize: size,
                    //     fontWeight: FontWeight.w500,
                    //     fontStyle: FontStyle.normal,
                    //   ),
                    // ),
                    this.cell(),
              ),
            ),
            tape(context),
          ],
        ),
      );
    }
  }
}
