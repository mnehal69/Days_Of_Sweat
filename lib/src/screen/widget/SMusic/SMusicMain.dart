import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:days_of_sweat/src/screen/widget/SMusic/SMusicCover.dart';
import 'package:days_of_sweat/src/screen/widget/SMusic/SPlayer.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SMusicMain extends StatelessWidget {
  final code = ResusableCode();
  String titleSlicer(String title) {
    if (title.length < 28) {
      return title.substring(0);
    } else {
      return title.substring(0, 28);
    }
  }

  String durationfromMilliSeconds(int mili) {
    // int milliseconds = 205427;
    DateTime total = new DateTime.fromMillisecondsSinceEpoch(mili);
    int minutes = total.minute;
    int second = total.second;
    //print("Minutes:$minutes.$second");
    if (minutes == 0) {
      return "0:00";
    }
    return "$minutes:$second";
  }
  
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: code.percentageToNumber(context, "6%", false),
              ),
              //color: Colors.yellow,
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
                      titleSlicer("Months"),
                      style: TextStyle(
                          fontFamily: "Roboto-Bold",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          fontSize:
                              code.percentageToNumber(context, "2%", true)),
                    ),
                  ),
                  Text(
                    "Calvin Harris",
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
                        durationfromMilliSeconds(state.currentDuration),
                        style: TextStyle(
                          fontFamily: "Roboto-Light",
                          color: Colors.white,
                          fontSize:
                              code.percentageToNumber(context, "2.1%", true),
                        ),
                      ),
                      Text(
                        durationfromMilliSeconds(state.totalDuration),
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
              ),
            ),
          ],
        );
      },
    );
  }
}
