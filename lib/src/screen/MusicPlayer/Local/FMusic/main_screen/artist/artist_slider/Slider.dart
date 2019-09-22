import 'dart:io';

import 'package:days_of_sweat/redux/actions/player_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';

class FSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FSliderState();
  }
}

class FSliderState extends State<FSlider> {
  String index(int index) {
    if (index >= 0 && index < 10) {
      return "0$index";
    }
    return index.toString();
  }

  String millitoDuration(String duration) {
    int mili = int.parse(duration);
    int second = ((mili / 1000) % 60).round();
    int minutes = (mili / (1000 * 60) % 60).floor();
    int hour = (mili / (1000 * 60 * 60) % 24).round();
    return "$hour ${hour > 1 ? "HOURS" : "HOUR"} $minutes ${minutes > 1 ? "MINUTES" : "MINUTE"}";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      builder: (context, state) {
        //print("Cool" + millitoDuration(4345322.toString()));
        return Container(
          child: Column(
            children: <Widget>[
              Index(
                index: index(state.currentAlbumIndex + 1),
              ),
              ImageSlider(
                index: state.currentAlbumIndex,
              ),
              Description(
                title: state.artistList[state.currentAlbumIndex][0],
                duration: millitoDuration(
                    state.artistList[state.currentAlbumIndex][2]),
                songs: state.artistList[state.currentAlbumIndex][1],
              ),
            ],
          ),
        );
      },
    );
  }
}

class Index extends StatelessWidget {
  final code = ResusableCode();
  final String index;
  Index({this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      //color: Colors.amber,
      margin: EdgeInsets.only(
        left: code.percentageToNumber(context, "10%", false),
        top: code.percentageToNumber(context, "3%", true),
      ),
      child: FDesText(
          title: this.index,
          color: Colors.white,
          fontFamily: "Lato",
          size: 25.0),
    );
  }
}

class ImageSlider extends StatefulWidget {
  final int index;
  ImageSlider({this.index});
  @override
  State<StatefulWidget> createState() {
    return ImageSliderState();
  }
}

class ImageSliderState extends State<ImageSlider> {
  var controller;
  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: widget.index,
      viewportFraction: 0.8,
    );
  }

  final code = ResusableCode();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Container(
            //color: Colors.red,
            width: code.percentageToNumber(context, "95%", false),
            height: code.percentageToNumber(context, "40%", true),
            margin: EdgeInsets.only(
              top: code.percentageToNumber(context, "3%", true),
            ),
            child: PageView.builder(
              controller: controller,
              itemCount: state.artistList.length,
              itemBuilder: (context, index) {
                return imageSlider(index, context, state);
              },
              onPageChanged: (index) {
                StoreProvider.of<MainState>(context).dispatch(
                  ArtistAlbum(state.artistList, state.artistSongList, index),
                );
              },
            ),
          );
        });
  }

  navigate(context) {
    StoreProvider.of<MainState>(context)
        .dispatch(NavigateToAction.push('/playlist'));
  }

  imageSlider(int index, context, MainState state) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return Hero(
            tag: "album$index",
            child: InkWell(
              onTap: () {
                navigate(context);
              },
              child: Stack(
                children: <Widget>[
                  //Center(child:
                  Container(
                    margin: EdgeInsets.only(
                      right: code.percentageToNumber(context, "5%", false),
                    ),
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                        image: state.artistList[index][3] != null
                            ? FileImage(
                                new File.fromUri(
                                  Uri.parse(state.artistList[index][3]),
                                ),
                              )
                            : AssetImage(
                                "resources/no_coverM.png",
                              ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    //   child: state.artistList[index][3] != null
                    //       ? Image.file(
                    //           new File.fromUri(
                    //               Uri.parse(state.artistList[index][3])),
                    //         )
                    //       : Image.asset(
                    //           "resources/no_coverM.png",
                    //           //scale: 0.2,
                    //           fit: BoxFit.fill,
                    //         ),
                  ),
                  //),
                  index != state.currentAlbumIndex
                      ? Container(
                          // height: code.percentageToNumber(context, "30%", true),
                          // width: code.percentageToNumber(context, "100%", true),
                          margin: EdgeInsets.only(
                            right:
                                code.percentageToNumber(context, "5%", false),
                          ),
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
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }
}

class Description extends StatelessWidget {
  final code = ResusableCode();
  final String title, duration;
  final String songs;
  Description({this.title, this.songs, this.duration});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      //color: Colors.amber,
      margin: EdgeInsets.only(
        left: code.percentageToNumber(context, "8%", false),
        top: code.percentageToNumber(context, "3%", true),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FDesText(
            title: this.title,
            color: HexColor("#615E5E"),
            fontFamily: "Roboto-Light",
            size: 35.0,
          ),
          FDesText(
            title: "${this.songs} songs",
            color: Colors.white,
            fontFamily: "Lato",
            size: 25.0,
          ),
          FDesText(
            title: this.duration,
            color: Colors.white,
            fontFamily: "Lato",
            size: 20.0,
          ),
        ],
      ),
    );
  }
}

class FDesText extends StatelessWidget {
  final String fontFamily;
  final String title;
  final color;
  final size;
  final code = ResusableCode();
  FDesText({this.size, this.title, this.fontFamily, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: code.percentageToNumber(context, "1%", true),
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: this.color,
          fontFamily: this.fontFamily,
          fontSize: this.size,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
