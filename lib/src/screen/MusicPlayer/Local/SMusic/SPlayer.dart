import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flare_flutter/flare_actor.dart';

import 'SPlayButton.dart';

class SPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SPlayerState();
  }
}

class SPlayerState extends State<SPlayer> {
  // var play = false;
  var code = ResusableCode();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: code.percentageToNumber(context, "13%", false),
              height: code.percentageToNumber(context, "6%", true),
              child: Container(
                // color: Colors.red,
                child: state.playing
                    ? GestureDetector(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                            top: code.percentageToNumber(context, "1%", true),
                            left: code.percentageToNumber(context, "2%", false),
                          ),
                          child: Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: code.percentageToNumber(context, "8%", false),
                          ),
                        ),
                        onTap: () => code.prevNextBtn(context, state, 1),
                      )
                    : Transform.rotate(
                        angle: 22 / 7,
                        child: FlareActor(
                          'resources/btn.flr',
                          alignment: Alignment.center,
                          animation: state.prevbuttonPress ? "next" : "start",
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            SPlayButton(),
            Container(
              width: code.percentageToNumber(context, "13%", false),
              height: code.percentageToNumber(context, "6%", true),
              child: state.playing
                  ? GestureDetector(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                          top: code.percentageToNumber(context, "0.8%", true),
                          left: code.percentageToNumber(context, "2%", false),
                        ),
                        child: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: code.percentageToNumber(context, "8%", false),
                        ),
                      ),
                      onTap: () => code.prevNextBtn(context, state, 1),
                    )
                  : FlareActor(
                      'resources/btn.flr',
                      alignment: Alignment.center,
                      animation: state.nextbuttonPress ? "next" : "start",
                      fit: BoxFit.cover,
                    ),
            ),
          ],
        );
      },
    );
  }
}
