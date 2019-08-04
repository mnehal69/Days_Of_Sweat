import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/SMusic/SPlayButton.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flare_flutter/flare_actor.dart';

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
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: code.percentageToNumber(context, "13%", false),
              height: code.percentageToNumber(context, "6%", true),
              child: Container(
                // color: Colors.red
                child: Transform.rotate(
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
              child: FlareActor(
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
