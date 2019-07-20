import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MusicPlayerState();
  }
}

class MusicPlayerState extends State<MusicPlayer> {
  String imageUrl, title, author;
  var code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      height: code.percentageToNumber(context, "10%", true),
      child: Row(
        children: <Widget>[
          Container(
            height: code.percentageToNumber(context, "10%", true),
            width: code.percentageToNumber(context, "20%", false),
            child: Image.asset("resources/Add.png"),
            color: Colors.green,
          ),
          Container(
              height: code.percentageToNumber(context, "10%", true),
              width: code.percentageToNumber(context, "50%", false),
              color: Colors.blue,
              child: Column(
                children: <Widget>[
                  Text("Title"),
                  Text("Author"),
                ],
              )),
          Container(
            height: code.percentageToNumber(context, "10%", true),
            width: code.percentageToNumber(context, "30%", false),
            child: Text("data"),
            color: Colors.deepOrangeAccent,
          ),
        ],
      ),
    );
  }
}
