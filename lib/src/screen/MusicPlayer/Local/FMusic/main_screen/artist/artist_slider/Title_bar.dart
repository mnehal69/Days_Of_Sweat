import 'package:days_of_sweat/redux/actions/player_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/FMusic/main_screen/playlist/PlayListBox.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FTitleBar extends StatelessWidget {
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(
            top: code.percentageToNumber(context, "4%", true),
            left: code.percentageToNumber(context, "5%", false),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => StoreProvider.of<MainState>(context)
                    .dispatch(ScreenAction(selected: 1)),
                child: TitleText(
                  title: "Artist",
                  isSelected: state.selected == 1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("type:${state.type}");
                  print("playlist:${state.playList.length}");
                  StoreProvider.of<MainState>(context).dispatch(RefreshPlayList(
                    list: List.generate(
                      state.playList.length,
                      (index) {
                        return PlayListBox(
                          position: index,
                        );
                      },
                    ),
                  ));

                  StoreProvider.of<MainState>(context)
                      .dispatch(ScreenAction(selected: 2));
                },
                child: TitleText(
                  title: "Playlist",
                  isSelected: state.selected == 2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  StoreProvider.of<MainState>(context)
                      .dispatch(ScreenAction(selected: 3));
                  StoreProvider.of<MainState>(context).dispatch(
                    ScrollBar(shown: false, isAlbum: false),
                  );
                },
                child: TitleText(
                  title: "Music",
                  isSelected: state.selected == 3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TitleText extends StatelessWidget {
  final bool isSelected;
  final String title;
  final ResusableCode code = ResusableCode();
  TitleText({this.isSelected, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: code.percentageToNumber(context, "3%", false),
          ),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: this.isSelected ? Colors.white : HexColor("#615E5E"),
              fontFamily: "Roboto-Light",
              fontSize: code.percentageToNumber(context, "4%", true),
            ),
          ),
        ),
      ],
    );
  }
}
