import 'dart:io';

import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'BackButton.dart';
import 'Button.dart';


class FlexibleAppBar extends StatelessWidget {
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: state.appbarshown ? 1.0 : 1.0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: code.percentageToNumber(context, "90%", false),
            height: code.percentageToNumber(context, "50%", true),
            margin: EdgeInsets.only(
              left: code.percentageToNumber(context, "5%", false),
              right: code.percentageToNumber(context, "5%", false),
              top: code.percentageToNumber(
                  context, state.appbarshown ? "10%" : "5%", true),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    //color: Colors.red,
                    borderRadius: new BorderRadius.circular(
                      code.percentageToNumber(context, "5%", true),
                    ),
                    image: new DecorationImage(
                      // image:
                      image: state.artistList[state.currentAlbumIndex][3] !=
                              null
                          ? FileImage(
                              new File.fromUri(
                                Uri.parse(state
                                    .artistList[state.currentAlbumIndex][3]),
                              ),
                            )
                          : AssetImage(
                              "resources/no_coverM.png",
                            ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(
                  //   right: code.percentageToNumber(context, "5%", false),
                  // ),
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(
                      code.percentageToNumber(context, "5%", true),
                    ),
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
                Container(
                  margin: EdgeInsets.only(
                    top: code.percentageToNumber(context, "2%", true),
                    left: code.percentageToNumber(context, "5%", false),
                  ),
                  child: MusicBackButton(),
                ),
                Positioned(
                  left: 0,
                  bottom: code.percentageToNumber(context, "0%", true),
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: code.percentageToNumber(context, "2%", true),
                      left: code.percentageToNumber(context, "5%", false),
                    ),
                    child: BottomPictureSheet(),
                  ),
                ),
              ],
            ),
          ),
          // ),
        );
      },
    );
  }
}

class BottomPictureSheet extends StatelessWidget {
  final code = ResusableCode();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Album from",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Lato",
                fontWeight: FontWeight.bold,
                fontSize: code.percentageToNumber(context, "3%", true),
              ),
            ),
            Text(
              state.artistList[state.currentAlbumIndex][0],
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Lato",
                fontWeight: FontWeight.bold,
                fontSize: code.percentageToNumber(context, "5%", true),
              ),
            ),
            Container(
              //color: Colors.green,
              width: code.percentageToNumber(context, "80%", false),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => code.playingFromintial(
                        context: context, state: state, isAlbum: true),
                    child: Container(
                      width: code.percentageToNumber(context, "30%", false),
                      height: code.percentageToNumber(context, "7%", true),
                      decoration: BoxDecoration(
                        color: HexColor("#DC153C"),
                        borderRadius: BorderRadius.circular(
                          code.percentageToNumber(context, "1%", true),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Play",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Lato",
                              fontSize:
                                  code.percentageToNumber(context, "5%", false),
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.play,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => code.random(
                        context: context, state: state, isAlbum: true),
                    child: ArtistButton(
                      icon: Icons.shuffle,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
