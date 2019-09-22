import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Day extends StatelessWidget {
  final int index;
  final String day;
  final bool darkmode;
  final code = ResusableCode();
  final size = 16.0;
  final List<String> daylist;
  final color1 = HexColor(ResusableCode().getRandomColor());
  final color2 = HexColor(ResusableCode().getRandomColor());

  Day({this.index = -1, this.day, this.darkmode = false, this.daylist});

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
        "SelectedColorBackgroundEnd": HexColor("#FF4F8C"),
        "SelectedColorShadow": Color.fromRGBO(255, 0, 49, 0.4),
      };
    }
  }

  Color taskDone(MainState state) {
    if (state.calenderlist[index].finish) {
      return Colors.grey[200];
    } else {
      return Colors.transparent;
    }
  }

  Color header(MainState state) {
    if (state.calenderlist[index].heading &&
        state.calenderlist[index].columnSelected) {
      return HexColor("#827D7D");
    } else if (state.calenderlist[index].heading) {
      return darkmode ? Colors.white : HexColor("BFBFBF");
    } else {
      return Colors.black;
    }
  }

  Widget tape(context, MainState state) {
    if (state.calenderlist[index].rowSelected) {
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
    } else if (state.calenderlist[index].columnSelected) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: state.calenderlist[index].heading ||
                      state.calenderlist[index].empty
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
            color: header(state),
          ),
        ),
      );
    } else {
      return Text("");
    }
  }

  Widget cell(context, MainState state) {
    if (state.calenderlist[index].show) {
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
      return Container(
        child: Column(
          children: <Widget>[
            Text(
              day.toString(),
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Roboto-Regular",
                fontSize: size,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
            !state.calenderlist[index].empty &&
                    !state.calenderlist[index].heading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: code.percentageToNumber(context, "1%", false),
                        height: code.percentageToNumber(context, "1%", true),
                        margin: EdgeInsets.only(
                          right:
                              code.percentageToNumber(context, "0.5%", false),
                        ),
                        decoration: BoxDecoration(
                            color: this.color1,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: this.color1,
                                blurRadius: 10,
                                spreadRadius: code.percentageToNumber(
                                    context, "0.2%", false),
                              )
                            ]),
                      ),
                      Container(
                        width: code.percentageToNumber(context, "1%", false),
                        height: code.percentageToNumber(context, "1%", true),
                        decoration: BoxDecoration(
                          color: this.color2,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: this.color2,
                              blurRadius: 10,
                              spreadRadius: code.percentageToNumber(
                                  context, "0.2%", false),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      builder: (context, state) {
        if (state.calenderlist[index].selected) {
          return AnimatedContainer(
            duration: new Duration(milliseconds: 500),
            // color: Colors.teal,
            color: darkMode()["background"],
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  color: darkMode()["background"],
                  margin: EdgeInsets.only(
                    left: code.percentageToNumber(context, "1%", false),
                    right: code.percentageToNumber(context, "1%", false),
                  ),
                  height: code.percentageToNumber(context, "5%", true),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: code.percentageToNumber(context, "1%", true),
                    bottom: code.percentageToNumber(context, "0.5%", true),
                  ),
                  height: code.percentageToNumber(context, "8%", true),
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
                        daylist[state.calenderlist[index].columnIndex],
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
                  color: state.calenderlist[index].show
                      ? Colors.transparent
                      : taskDone(state),
                  // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  margin: EdgeInsets.all(
                      code.percentageToNumber(context, "1%", false)),
                  child: Center(
                    child: this.cell(context, state),
                  ),
                ),
                tape(context, state),
              ],
            ),
          );
        }
      },
    );
  }
}
