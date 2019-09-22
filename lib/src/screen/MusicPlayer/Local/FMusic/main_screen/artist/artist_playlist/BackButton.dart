import 'package:days_of_sweat/redux/actions/player_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/FMusic/main_screen/playlist/PlayListBox.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';

class MusicBackButton extends StatelessWidget {
  final code = ResusableCode();
  final bool circle;
  MusicBackButton({this.circle = false});
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state.index > -1) {
              StoreProvider.of<MainState>(context).dispatch(
                RefreshPlayList(
                  list: List.generate(
                    state.playList.length,
                    (index) {
                      return PlayListBox(
                        position: index,
                      );
                    },
                  ),
                ),
              );

              StoreProvider.of<MainState>(context)
                  .dispatch(Dispose(dispose: true));
            }
            StoreProvider.of<MainState>(context)
                .dispatch(NavigateToAction.pop());
            // StoreProvider.of<MainState>(context).dispatch(action)
          },
          child: Container(
            margin: EdgeInsets.only(
              left: code.percentageToNumber(context, "2%", false),
            ),
            width: code.percentageToNumber(context, "13%", false),
            height: code.percentageToNumber(context, "10%", true),
            // color: HexColor("#DC153C"),
            decoration: !this.circle
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: HexColor("#BE1234"),
                    shape: BoxShape.rectangle,
                  )
                : BoxDecoration(
                    color: HexColor("#BE1234"),
                    shape: BoxShape.circle,
                  ),
            child: Image.asset(
              'resources/dropdown-left.png',
              scale: 6,
            ),
          ),
        );
      },
    );
  }
}
