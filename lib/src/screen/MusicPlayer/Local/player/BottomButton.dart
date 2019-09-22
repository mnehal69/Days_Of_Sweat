import 'package:days_of_sweat/redux/actions/player_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/Database/Database.dart';
import 'package:days_of_sweat/src/screen/Database/PlayList.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/common/song.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class BottomButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BottomButtonState();
  }
}

class BottomButtonState extends State<BottomButton> {
  final code = ResusableCode();
  bool likebtnpress = false;
  bool changed;
  Song currentSong;

  void favourite(MainState state) async {
    int index;
    if (state.type.contains("Favourite")) {
      index = state.type.indexOf("Favourite");
    }
    //this.listModified(state);

    if (state.currentfavourite) {
      //
      // DELETE FROM LIST AND DATABASE
      //
      print("1!!!!!!!!");
      StoreProvider.of<MainState>(context).dispatch(Like(like: false));
      DBProvider.db.deletePlaylistIndex(state.currentId, "Favourite");

      // state.type.remove("Favourite");
      print("BEFORE DELETING INDEX:${state.playList[index].toString()}");
      state.playList[index].removeAt(state.index);
      print("AFTER DELETING INDEX:${state.playList[index].toString()}");
      print("PLAYLIST LENGTH :${state.playList.length}");
      if (state.playList[index].length == 0) {
        print("DELETE AT ZERO INDEX:$index");

        state.type.remove("Favourite");
        state.playList.removeAt(index);
        print("PLAYLIST LENGTH AT ZERO:${state.playList.length}");
      }
    } else {
      print("222222222222222");
      // state.favouriteList.add(state.currentPlayingList[state.index].id);
      //
      // ADD TO LIST AND DATABASE
      print(state.playList.length);
      if (state.playList.length <= 1) {
        state.type.add("Favourite");
        int index = state.type.indexOf("Favourite");
        print("fRIST TIME INDEX:$index");
        print("fRIST TIME PLAYLIST LENGTH:${state.playList.length}");
        List<Song> favourite = [currentSong];
        state.playList.add(favourite);
      } else {
        state.playList[index].add(currentSong);
      }
      DBProvider.db.addNewPlaylistIndex(new PlayListModel(
          id: await DBProvider.db.getNewID(),
          songID: state.currentId,
          type: 'Favourite'));

      StoreProvider.of<MainState>(context).dispatch(Like(like: true));
    }
    DBProvider.db.printTable();
    print(" PLAYLIST LENGTH:${state.playList.length}");
    setState(() {
      likebtnpress = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      onWillChange: (state) async {
        if (state.changed) {
          var favourite = await DBProvider.db
              .existsPlaylistIndex(state.currentId, "Favourite");
          if (favourite) {
            StoreProvider.of<MainState>(context).dispatch(Like(like: true));
          } else {
            StoreProvider.of<MainState>(context).dispatch(Like(like: false));
          }
          setState(() {
            currentSong = state.currentPlayingList[state.index];
          });
        }
      },
      builder: (context, state) {
        return Container(
          width: code.percentageToNumber(context, "98%", false),
          height: code.percentageToNumber(context, "5%", true),
          margin: EdgeInsets.only(
            bottom: code.percentageToNumber(context, "0.5%", true),
            left: code.percentageToNumber(context, "1%", true),
            right: code.percentageToNumber(context, "1%", true),
          ),
          // color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: InkWell(
                  child: Container(
                    // color: Colors.blue,
                    child: Stack(
                      children: <Widget>[
                        Image.asset('resources/no-loop.png'),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width:
                                code.percentageToNumber(context, "4%", false),
                            height:
                                code.percentageToNumber(context, "4%", true),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: false
                                  ? Image.asset('resources/infinity.png')
                                  : Text(
                                      "1",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                // color: Colors.teal,
                width: code.percentageToNumber(context, "70%", false),
                height: code.percentageToNumber(context, "20%", false),
                child: GestureDetector(
                  onTap: () => this.favourite(state),
                  child: Container(
                    child: !likebtnpress
                        ? Icon(
                            state.currentfavourite
                                ? EvaIcons.heart
                                : EvaIcons.heartOutline,
                            color: state.currentfavourite
                                ? HexColor("#FF0031")
                                : Colors.grey,
                            size: code.percentageToNumber(context, "5%", true),
                          )
                        : Container(
                            margin: EdgeInsets.only(
                              left:
                                  code.percentageToNumber(context, "5%", false),
                            ),
                            child: FlareActor(
                              'resources/heart_G.flr',
                              alignment: Alignment.center,
                              animation:
                                  state.currentfavourite ? "like" : "unlike",
                              fit: BoxFit.cover,
                              callback: (detail) {
                                setState(() {
                                  likebtnpress = true;
                                });
                              },
                            ),
                          ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.volumeUp,
                  color: !state.volumeBarVisible ? Colors.grey : Colors.white,
                ),
                onPressed: () {
                  StoreProvider.of<MainState>(context).dispatch(
                      VolumeControl(!state.volumeBarVisible, state.volume));
                },
              )
            ],
          ),
        );
      },
    );
  }
}
