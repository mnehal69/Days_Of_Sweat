import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'BackButton.dart';
import 'Button.dart';

class PlayListAppBar extends StatelessWidget {
  final code = ResusableCode();
  bool shown;
  PlayListAppBar({this.shown});
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: this.shown ? 1.0 : 0.0,
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: code.percentageToNumber(context, "4%", true),
                  // color: HexColor("#121218"),
                  color: Color.fromRGBO(18, 18, 24, 0.5),
                ),
                Container(
                  height: code.percentageToNumber(context, "15%", true),
                  child: Row(
                    children: [
                      MusicBackButton(),
                      state.isAlbum
                          ? Container(
                              margin: EdgeInsets.only(
                                left: code.percentageToNumber(
                                    context, "2%", false),
                              ),
                              child: Text(
                                "Album from",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold,
                                  fontSize: code.percentageToNumber(
                                      context, "3%", true),
                                ),
                              ))
                          : Container(),
                      Container(
                        margin: EdgeInsets.only(
                          left: code.percentageToNumber(context, "1%", false),
                          right: code.percentageToNumber(context, "1%", false),
                        ),
                        width: code.percentageToNumber(
                            context, state.isAlbum ? "20%" : "50%", false),
                        // child: Text(
                        //   "Eminem",
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontFamily: "Lato",
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: code.percentageToNumber(context, "5%", true),
                        //   ),
                        // ),
                        child: Container(
                          alignment: Alignment.center,
                          //color: Colors.red,
                          // child: SizedBox(
                          //   width: 200.0,
                          //   height: 140.0,
                          child: AutoSizeText(
                            state.isAlbum
                                ? state.artistList[state.currentAlbumIndex][0]
                                : "Song List",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.bold,
                            ),
                            presetFontSizes: [
                              code.percentageToNumber(context, "10%", true),
                              code.percentageToNumber(context, "5%", true),
                              code.percentageToNumber(context, "4%", true),
                              code.percentageToNumber(context, "3%", true),
                              code.percentageToNumber(context, "2%", true),
                              code.percentageToNumber(context, "1%", true),
                            ],
                            textAlign: TextAlign.center,
                            // maxLines: 1,
                            // minFontSize: code.percentageToNumber(context, "1%", true),
                            // maxFontSize: code.percentageToNumber(context, "5%", true),
                          ),
                          //),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: code.percentageToNumber(context, "2%", false),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => code.playingFromintial(
                                  context: context,
                                  state: state,
                                  isAlbum: state.isAlbum),
                              child: ArtistButton(
                                icon: FontAwesomeIcons.play,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => code.random(
                                  context: context,
                                  state: state,
                                  isAlbum: state.isAlbum),
                              child: ArtistButton(
                                icon: Icons.shuffle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
