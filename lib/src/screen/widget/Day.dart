import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';

class Day extends StatelessWidget {
  final day;
  final bool finish;
  final selected;
  final rowSelected;
  final columnSelected;
  final heading;
  final code = ResusableCode();

  Day({
    this.day = "",
    this.finish = false,
    this.selected = false,
    this.rowSelected = false,
    this.columnSelected = false,
    this.heading = false,
  });

  Color taskDone() {
    if (finish) {
      return Colors.grey[100];
    } else {
      return Colors.transparent;
    }
  }

  Color header() {
    if (heading && columnSelected) {
      return HexColor("#827D7D");
    } else if (heading) {
      return HexColor("BFBFBF");
    } else {
      return Colors.black;
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
                    color: Colors.black26,
                    //color: Colors.transparent,
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    offset: new Offset(12, 5)),
              ],
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
                bottom: code.percentageToNumber(context, "3.2%", true),
                top: code.percentageToNumber(context, "0.8%", true)),
            margin: EdgeInsets.only(
                top: code.percentageToNumber(context, "2.5%", true)),
            child: Text(
              day.toString(),
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: 15,
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
              color: Colors.black26,
              //color: Colors.transparent,
              blurRadius: 3.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        height: code.percentageToNumber(context, "10%", true),
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            left: code.percentageToNumber(context, "2%", false),
            right: code.percentageToNumber(context, "2%", false)),
        child: Text(
          day.toString(),
          style: TextStyle(
            fontFamily: "Roboto-Regular",
            fontSize: 15,
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

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return Container(
        // color: Colors.teal,
        color: Colors.transparent,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(
                left: code.percentageToNumber(context, "2%", false),
                right: code.percentageToNumber(context, "2%", false),
              ),
              height: code.percentageToNumber(context, "10%", true),
            ),
            Container(
              padding: EdgeInsets.only(top: 12, bottom: 10),
              margin: EdgeInsets.only(
                  top: code.percentageToNumber(context, "1%", true)),
              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Color.fromRGBO(255, 0, 49, 0.4),
                    //color: Colors.transparent,
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
                color: HexColor("#FF0031"),
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
                    "TUE",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Roboto-Light",
                      fontSize: 15,
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
        height: code.percentageToNumber(context, "10%", true),
        // color: Colors.teal,
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
        child: Stack(
          children: [
            Container(
              color: taskDone(),
              // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              margin: EdgeInsets.all(
                  code.percentageToNumber(context, "1.2%", false)),
              child: Center(
                child: Text(
                  day.toString(),
                  style: TextStyle(
                    color: header(),
                    fontFamily: "Roboto-Regular",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
            tape(context),
          ],
        ),
      );
    }
  }
}
