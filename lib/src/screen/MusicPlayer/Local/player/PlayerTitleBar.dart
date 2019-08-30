import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/FMusic/main_screen/artist/artist_playlist/BackButton.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:marquee_flutter/marquee_flutter.dart';

class PlayerTitleBar extends StatelessWidget {
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: code.percentageToNumber(context, "100%", false),
      height: code.percentageToNumber(context, "10%", true),
      // color: Colors.green,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: code.percentageToNumber(context, "2%", false),
            child: MusicBackButton(
              circle: true,
            ),
          ),
          Center(
            child: PlayerText(),
          ),
        ],
      ),
    );
  }
}

class PlayerText extends StatelessWidget {
  final code = ResusableCode();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: code.percentageToNumber(context, "60%", false),
              height: code.percentageToNumber(context, "5%", true),
              alignment: Alignment.center,
              child: state.currentTitle.length > 25
                  ? MarqueeWidget(
                      text: state.currentTitle,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: code.percentageToNumber(context, "3%", true),
                      ),
                      scrollAxis: Axis.horizontal,
                    )
                  : Text(
                      state.currentTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: code.percentageToNumber(context, "3%", true),
                      ),
                    ),
            ),
            Text(
              state.currentArtist,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto-Light',
                fontWeight: FontWeight.w400,
                fontSize: code.percentageToNumber(context, "3%", true),
              ),
            ),
            Container(
              height: code.percentageToNumber(context, "0.5%", true),
              width: code.percentageToNumber(context, "10%", false),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  code.percentageToNumber(context, "2%", false),
                ),
                color: HexColor("#DC153C"),
              ),
            )
          ],
        );
      },
    );
  }
}
