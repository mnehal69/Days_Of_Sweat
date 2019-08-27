import 'dart:async';

import 'package:days_of_sweat/redux/actions/main_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:media_notification/media_notification.dart';

class FPlayButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FPlayButtonState();
  }
}

class FPlayButtonState extends State<FPlayButton> {
  final code = ResusableCode();
  Timer timer;
  @override
  void dispose() {
    super.dispose();
  }

  void playbutton(PlayerState state) async {
    StoreProvider.of<PlayerState>(context).dispatch(
      AudioPlaying(!state.playing, state.currentDuration),
    );

    if (state.playing) {
      state.advancedPlayer.resume();

      try {
        await MediaNotification.show(
          title: state.currentTitle,
          author: state.currentArtist,
          play: state.playing,
          albumArt: state.currentAlbum,
        );
      } on PlatformException {}
    } else {
      state.advancedPlayer.pause().catchError((onError) {
        print("SOMTHING WRONG:$onError");
        state.advancedPlayer.release();
      });
      try {
        await MediaNotification.hide();
      } on PlatformException {}
    }
    MediaNotification.setListener('play', () {
      state.advancedPlayer.resume();
      StoreProvider.of<PlayerState>(context).dispatch(
        AudioPlaying(true, state.currentDuration),
      );
    });
    MediaNotification.setListener('pause', () {
      state.advancedPlayer.pause();
      StoreProvider.of<PlayerState>(context).dispatch(
        AudioPlaying(false, state.currentDuration),
      );
    });
    MediaNotification.setListener('prev', () {
      StoreProvider.of<PlayerState>(context).dispatch(
        Player(isAlbum: state.isAlbum, index: state.index - 1),
      );
      state.controller.animateToPage(state.index - 1,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
    });
    MediaNotification.setListener('next', () {
      StoreProvider.of<PlayerState>(context).dispatch(
        Player(isAlbum: state.isAlbum, index: state.index + 1),
      );
      state.controller.animateToPage(state.index + 1,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
    });

    MediaNotification.setListener('closing', () {
      MediaNotification.hide();
      state.advancedPlayer.stop();
      StoreProvider.of<PlayerState>(context)
          .dispatch(AudioPlaying(false, state.currentDuration));
      //print("COOL BITCH");
    });
  }

  Widget play(context, PlayerState state) {
    return GestureDetector(
      onTap: () {
        this.playbutton(state);
      },
      child: Container(
        width: code.percentageToNumber(context, "15%", false),
        height: code.percentageToNumber(context, "10%", true),
        decoration: BoxDecoration(
          color: HexColor("#DC153C"),
          borderRadius: BorderRadius.circular(
            code.percentageToNumber(context, "2%", true),
          ),
        ),
        child: Icon(
          FontAwesomeIcons.play,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget pause(context, PlayerState state) {
    return GestureDetector(
      onTap: () {
        this.playbutton(state);
      },
      child: Container(
        width: code.percentageToNumber(context, "17%", false),
        height: code.percentageToNumber(context, "17%", true),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: new Border.all(
            color: HexColor("#DC153C"),
            style: BorderStyle.solid,
            width: code.percentageToNumber(context, "0.5%", true),
          ),
        ),
        child: Icon(
          FontAwesomeIcons.pause,
          color: Colors.black,
          size: code.percentageToNumber(context, "6%", false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return state.playing ? pause(context, state) : play(context, state);
        });
  }
}
