import 'package:days_of_sweat/src/screen/widget/MusicPlayer/SmallMusicCover.dart';
import 'package:days_of_sweat/src/screen/widget/MusicPlayer/SmallPlayer.dart';
import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MusicPlayerState();
  }
}

class MusicPlayerState extends State<MusicPlayer> {
  String imageUrl, title, author;
  var width = 1;
  var code = ResusableCode();
  MusicPlayerState();
  //#FF0031
  //#150f1e
  String titleSlicer(String title) {
    if (title.length < 28) {
      return title.substring(0);
    } else {
      return title.substring(0, 28);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: code.percentageToNumber(context, "16%", true),
          width: code.percentageToNumber(context, "98%", false),
          decoration: BoxDecoration(
            color: HexColor("#FF0031"),
            boxShadow: [
              new BoxShadow(
                  color: HexColor("#FF0031"),
                  //color: Colors.transparent,
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                  offset: new Offset(0, 0)),
            ],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(65.0),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: code.percentageToNumber(context, "0.5%", true),
            left: code.percentageToNumber(context, "1%", false),
          ),
          height: code.percentageToNumber(context, "15.5%", true),
          width: code.percentageToNumber(context, "97%", false),
          decoration: BoxDecoration(
            color: HexColor("#150f1e"),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(65.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  left: code.percentageToNumber(context, "6%", false),
                ),
                // color: Colors.yellow,
                height: code.percentageToNumber(context, "10%", true),
                width: code.percentageToNumber(context, "20%", false),
                // child: Image.asset("resources/Add.png"),
                child: SmallCover(),
//            color: Colors.green,
              ),
              Container(
                  height: code.percentageToNumber(context, "10%", true),
                  width: code.percentageToNumber(context, "30%", false),
                  // color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
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
                          ),
                        ),
                      ),
                      Text(
                        "Calvin Harris",
                        style: TextStyle(
                          fontFamily: "Roboto-Light",
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "0:21",
                            style: TextStyle(
                              fontFamily: "Roboto-Light",
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "3:16",
                            style: TextStyle(
                              fontFamily: "Roboto-Light",
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Container(
                height: code.percentageToNumber(context, "10%", true),
                width: code.percentageToNumber(context, "41%", false),
                // color: Colors.pink,
                child: SmallPlayer(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
