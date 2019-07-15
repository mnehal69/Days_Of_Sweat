import 'package:days_of_sweat/src/screen/widget/PageInfoScreen.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './widget/page_indicator/page_view_indicator.dart';

class FirstTimeSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FirstTimeSliderState();
  }
}

class FirstTimeSliderState extends State<FirstTimeSlider> {
  // final controller = PageController(
  //   initialPage: 0,
  // );
  final code = ResusableCode();
  static const length = 3;
  final pageIndexNotifier = ValueNotifier<int>(0);
  bool visible = true;
  navigation() {}
  final val = [
    {
      "headingColor": "#531AAF",
      "heading": "Run",
      "image": "resources/run.png",
      "textColor": Colors.black,
      "info": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
      "backgroundColor": Colors.white,
      "imageBgColor": "#531AAF",
      "imageContainerHeight": "60%",
    },
    {
      "headingColor": Colors.white,
      "heading": "Track",
      "image": "resources/track.png",
      "textColor": Colors.white,
      "info": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
      "backgroundColor": "#00B5FF",
      "imageBgColor": Colors.transparent,
      "imageContainerHeight": "50%",
    },
    {
      "headingColor": "#20339C",
      "heading": "Repeat",
      "image": "resources/repeat.png",
      "textColor": "#20339C",
      "info": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
      "backgroundColor": Colors.white,
      "imageBgColor": Colors.transparent,
      "imageContainerHeight": "50%",
    },
  ];
  Widget pageViewIndicator() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 100),
      opacity: visible ? 1.0 : 0.0,
      child: PageViewIndicator(
        pageIndexNotifier: pageIndexNotifier,
        length: length,
        normalBuilder: (animationController, index) => Circle(
          size: 8.0,
          color: Colors.black26,
        ),
        highlightedBuilder: (animationController, index) => ScaleTransition(
          scale: CurvedAnimation(
            parent: animationController,
            curve: Curves.ease,
          ),
          child: Circle(
            size: 20.0,
            color: code.colorcheck(val[index]["headingColor"]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: FractionalOffset.bottomCenter,
        children: [
          PageView.builder(
            onPageChanged: (index) {
              pageIndexNotifier.value = index;
              if (index == length - 1) {
                setState(() {
                  visible = false;
                });
              } else {
                setState(() {
                  visible = true;
                });
              }
            },
            itemCount: length,
            itemBuilder: (context, index) {
              if (index == length - 1) {
                return PageInfo(
                  headingColor: val[index]["headingColor"],
                  heading: val[index]["heading"],
                  image: val[index]["image"],
                  textColor: val[index]["textColor"],
                  info: val[index]["info"],
                  backgroundColor: val[index]["backgroundColor"],
                  imageBgColor: val[index]["imageBgColor"],
                  imageContainerHeight: val[index]["imageContainerHeight"],
                  last: true,
                  buttonText: "Getting started",
                  pressedfunction: this.navigation,
                );
              } else {
                return PageInfo(
                  headingColor: val[index]["headingColor"],
                  heading: val[index]["heading"],
                  image: val[index]["image"],
                  textColor: val[index]["textColor"],
                  info: val[index]["info"],
                  backgroundColor: val[index]["backgroundColor"],
                  imageBgColor: val[index]["imageBgColor"],
                  imageContainerHeight: val[index]["imageContainerHeight"],
                );
              }
            },
          ),
          pageViewIndicator(),
        ],
      ),
    );
  }
}
