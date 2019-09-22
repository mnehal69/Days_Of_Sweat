import 'dart:io';
import 'dart:math';

import 'package:days_of_sweat/redux/actions/player_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/Database/Database.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/common/song.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PlayListBox extends StatefulWidget {
  final position;
  PlayListBox({this.position});
  @override
  State<StatefulWidget> createState() {
    return PlayListBoxState(position: position);
  }
}

class PlayListBoxState extends State<PlayListBox> {
  final code = ResusableCode();
  final position;
  final random = Random();
  bool press = false;
  PlayListBoxState({this.position});

  void randomIndex(MainState state) {
    List<String> uri = [];
    List<Song> album = state.playList[position];
    List<String> albumList = [];
    List<String> artist = [];
    var no;
    var uriString;
    for (int i = 0; i < 4; i++) {
      no = random.nextInt(album.length);
      uriString = album[no].albumArt;
      albumList.add(album[no].album);
      artist.add(album[no].artist);
      uri.add(uriString);
    }
    state.playListAlbumArtList.add(uri);
  }

  Widget image(MainState state, int index) {
    if (state.playListAlbumArtList[position][index] == null || position == -1) {
      return Image.asset(
        "resources/no_coverM.png",
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        new File.fromUri(
          Uri.parse(state.playListAlbumArtList[position][index]),
        ),
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      onInit: (store) {
        randomIndex(store.state);
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (!press) {
              if (position == 0) {
                state.playList[position].shuffle();
                state.playList[position].shuffle();
              }
              code.playingFromintial(
                context: context,
                isAlbum: false,
                state: state,
                list: state.playList[position],
              );
              StoreProvider.of<MainState>(context).dispatch(PlayListSection(
                  type: state.type,
                  playList: state.playList,
                  typeindex: position));
            } else {
              setState(() {
                press = false;
              });
            }
          },
          onLongPressStart: (detail) {
            setState(() {
              press = true;
            });
          },
          child: Stack(
            children: [
              Container(
                width: code.percentageToNumber(context, "50%", false),
                height: code.percentageToNumber(context, "35%", true),
                // color: Colors.orange,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      code.percentageToNumber(context, "50%", true)),
                ),
                margin: EdgeInsets.only(
                  left: code.percentageToNumber(context, "5%", false),
                  right: code.percentageToNumber(context, "5%", false),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height:
                                  code.percentageToNumber(context, "10%", true),
                              width: code.percentageToNumber(
                                  context, "20%", false),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    code.percentageToNumber(
                                        context, "1%", true),
                                  ),
                                ),
                                color: Colors.purple,
                              ),
                              child: image(state, 0),
                            ),
                            Container(
                              height:
                                  code.percentageToNumber(context, "10%", true),
                              width: code.percentageToNumber(
                                  context, "20%", false),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    code.percentageToNumber(
                                        context, "1%", true),
                                  ),
                                ),
                                color: Colors.red,
                              ),
                              child: image(state, 1),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height:
                                  code.percentageToNumber(context, "10%", true),
                              width: code.percentageToNumber(
                                  context, "20%", false),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                    code.percentageToNumber(
                                        context, "1%", true),
                                  ),
                                ),
                                color: Colors.white,
                              ),
                              child: image(state, 2),
                            ),
                            Container(
                              height:
                                  code.percentageToNumber(context, "10%", true),
                              width: code.percentageToNumber(
                                  context, "20%", false),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(
                                    code.percentageToNumber(
                                        context, "1%", true),
                                  ),
                                ),
                                color: Colors.pink,
                              ),
                              child: image(state, 3),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: code.percentageToNumber(context, "0.5%", true),
                          ),
                          child: Text(
                            state.type[position],
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Lato",
                                fontSize: code.percentageToNumber(
                                    context, "5%", false),
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: code.percentageToNumber(context, "20%", true),
                      width: code.percentageToNumber(context, "50%", true),
                      // margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.3),
                            Color.fromRGBO(0, 0, 0, 0.3),
                          ],
                        ),
                      ),
                    ),
                    press && position != 0
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                                onTap: () {
                                  if (position != 0) {
                                    DBProvider.db
                                        .deletePlaylist(state.type[position]);
                                    state.playList.removeAt(position);
                                    state.type.removeAt(position);
                                    StoreProvider.of<MainState>(context)
                                        .dispatch(RefreshPlayList(
                                      list: List.generate(
                                        state.playList.length,
                                        (index) {
                                          return PlayListBox(
                                            position: index,
                                          );
                                        },
                                      ),
                                    ));
                                  }
                                },
                                child: Image.asset("resources/close.png")),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
