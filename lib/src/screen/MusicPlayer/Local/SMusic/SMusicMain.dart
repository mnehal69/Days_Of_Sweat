import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';

import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'SMusicCover.dart';
import 'SPlayer.dart';

class SMusicMain extends StatelessWidget {
  final code = ResusableCode();
  String titleSlicer(String title) {
    if (title.length < 10) {
      return title.substring(0);
    } else {
      return title.substring(0, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: code.percentageToNumber(context, "6%", false),
              ),
              height: code.percentageToNumber(context, "10%", true),
              width: code.percentageToNumber(context, "20%", false),
              // child: Image.asset("resources/Add.png"),
              child: Container(child: SCover()),
//            color: Colors.green,
            ),
            Container(
              height: code.percentageToNumber(context, "10%", true),
              width: code.percentageToNumber(context, "30%", false),
              // color: Colors.blue,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    //color: Colors.pink,
                    padding: EdgeInsets.all(
                        code.percentageToNumber(context, "0.2%", true)),
                    child: Text(
                      titleSlicer(state.currentTitle),
                      style: TextStyle(
                          fontFamily: "Roboto-Bold",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          fontSize:
                              code.percentageToNumber(context, "2.3%", true)),
                    ),
                  ),
                  Text(
                    state.currentArtist,
                    style: TextStyle(
                      fontFamily: "Roboto-Light",
                      color: Colors.white,
                      fontSize: code.percentageToNumber(context, "2.1%", true),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        code.durationfromMilliSeconds(state.currentDuration),
                        style: TextStyle(
                          fontFamily: "Roboto-Light",
                          color: Colors.white,
                          fontSize:
                              code.percentageToNumber(context, "2.1%", true),
                        ),
                      ),
                      Text(
                        "  " +
                            code.durationfromMilliSeconds(state.totalDuration),
                        style: TextStyle(
                          fontFamily: "Roboto-Light",
                          color: Colors.white54,
                          fontSize:
                              code.percentageToNumber(context, "2.1%", true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height: code.percentageToNumber(context, "10%", true),
              width: code.percentageToNumber(context, "41%", false),

              // color: Colors.pink,
              child: Align(
                alignment: Alignment.topCenter,
                child: SPlayer(),
                // child: Container(),
              ),
            ),
          ],
        );
      },
    );
  }
}
