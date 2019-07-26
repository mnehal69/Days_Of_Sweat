import 'package:days_of_sweat/src/screen/widget/MusicPlayer/PlayButton.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmallPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SmallPlayerState();
  }
}

class SmallPlayerState extends State<SmallPlayer> {
  var play = false;
  var code = ResusableCode();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Stack(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.play,
              color: Colors.grey[350],
            ),
            Container(
              margin: EdgeInsets.only(left: 15.0),
              child: Icon(
                FontAwesomeIcons.play,
                color: Colors.grey[350],
              ),
            )
          ],
        ),
      ),
      PlayerButton(
        play: play,
      ),
      Container(
        margin: EdgeInsets.only(left: 10.0),
        child: Stack(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.play,
              color: Colors.grey[350],
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Icon(
                FontAwesomeIcons.play,
                color: Colors.grey[350],
              ),
            )
          ],
        ),
      )
    ]
        // color: Colors.deepOrangeAccent,

        );
  }
}
