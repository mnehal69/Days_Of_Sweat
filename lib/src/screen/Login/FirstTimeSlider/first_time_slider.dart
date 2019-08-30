import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'PageInfoScreen.dart';

class FirstTime extends StatelessWidget {
  final controller = PageController(
    initialPage: 0,
  );
  navigation() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            children: <Widget>[
              PageInfo(
                heading: "Run",
                image: "resources/run.png",
                textColor: Colors.black,
                info:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                backgroundColor: Colors.white,
                imageBgColor: "#531AAF",
                imageContainerHeight: "60%",
              ),
              PageInfo(
                heading: "Track",
                image: "resources/track.png",
                textColor: Colors.white,
                info:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                backgroundColor: "#00B5FF",
                imageBgColor: Colors.transparent,
                imageContainerHeight: "50%",
              ),
              PageInfo(
                heading: "Repeat",
                image: "resources/repeat.png",
                textColor: "#20339C",
                info:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                backgroundColor: Colors.white,
                imageBgColor: Colors.transparent,
                imageContainerHeight: "50%",
                last: true,
                buttonText: "Getting started",
                pressedfunction: this.navigation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
