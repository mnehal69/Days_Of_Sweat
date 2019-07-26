import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';

class SmallCover extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SmallCoverState();
  }
}

class SmallCoverState extends State<SmallCover>
    with SingleTickerProviderStateMixin {
  final code = ResusableCode();
  var play = false;
  AnimationController rotationController;

  @override
  void initState() {
    rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  void isplaying() {
    if (play) {
      rotationController.repeat();
    } else {
      rotationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    isplaying();
    return AnimatedBuilder(
      animation: rotationController,
      builder: (context, child) {
        return Container(
          //color: Colors.orange,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              //HALF CD
              // Container(
              //   margin: EdgeInsets.only(
              //       left: code.percentageToNumber(context, "13.5%", false)),
              //   width: code.percentageToNumber(context, "6.5%", false),
              //   height: code.percentageToNumber(context, "7%", true),
              //   child: Image.asset("resources/cd.png"),
              // ),
              //FULL CD

              Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(
                    left: code.percentageToNumber(context, "5%", false)),
                width: code.percentageToNumber(context, "14%", false),
                height: code.percentageToNumber(context, "10%", true),
                child: Transform.rotate(
                  angle: rotationController.value * 2.0 * (22 / 7),
                  child: Image.asset("resources/vcd.png"),
                ),
              ),

              Container(
                width: code.percentageToNumber(context, "15%", false),
                height: code.percentageToNumber(context, "11%", true),
                // color: Colors.teal,
                child: Image.asset(
                  "resources/demo.png",
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
