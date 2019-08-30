import 'dart:io';

import 'package:days_of_sweat/redux/actions/main_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PlayerImageSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlayerImageSliderState();
  }
}

class PlayerImageSliderState extends State<PlayerImageSlider> {
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          height: code.percentageToNumber(context, "50%", true),
          width: code.percentageToNumber(context, "100%", false),
          margin: EdgeInsets.only(
            top: code.percentageToNumber(context, "5%", false),
          ),
          // color: Colors.blue,
          child: Center(
              child: ImageSlider(
            index: state.index,
          )),
        );
      },
    );
  }
}

class ImageSlider extends StatefulWidget {
  final index;
  ImageSlider({this.index});
  @override
  State<StatefulWidget> createState() {
    return ImageSliderState();
  }
}

class ImageSliderState extends State<ImageSlider> {
  @override
  void initState() {
    super.initState();
  }

  final code = ResusableCode();
 

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      onInit: (store) {
        StoreProvider.of<PlayerState>(context).dispatch(
          PlayerController(
            controller: PageController(
              initialPage: store.state.index,
              viewportFraction: 0.8,
            ),
          ),
        );
        store.state.advancedPlayer.onPlayerCompletion.listen((onData) {
          // print("Last:${store.state.last}");
          if (store.state.last) {
            store.state.controller.animateToPage(0,
                curve: Curves.ease, duration: Duration(milliseconds: 500));
          } else {
            store.state.controller.animateToPage(store.state.index + 1,
                curve: Curves.ease, duration: Duration(milliseconds: 500));
          }
        });
      },
      builder: (context, state) {
        return Container(
          // color: Colors.red,
          width: code.percentageToNumber(context, "100%", false),
          height: code.percentageToNumber(context, "60%", true),
          margin: EdgeInsets.only(
            top: code.percentageToNumber(context, "0%", true),
          ),
          child: PageView.builder(
            controller: state.controller,
            itemCount: state.currentPlayingList.length,
            itemBuilder: (context, index) {
              return imageSlider(index, context, state);
            },
            onPageChanged: (index) {
              StoreProvider.of<PlayerState>(context).dispatch(Player(
                  index: index,
                  isAlbum: state.isAlbum,
                  list: state.currentPlayingList));
            },
          ),
        );
      },
    );
  }

  // navigate(context) {}
  bool imagePic(PlayerState state, int position) {
    if (state.currentPlayingList[position].albumArt != null) {
      return true;
    }
    return false;
  }

  imageSlider(int index, context, PlayerState state) {
    return AnimatedBuilder(
        animation: state.controller,
        builder: (context, widget) {
          return InkWell(
            onTap: () {
              //navigate(context);
            },
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: code.percentageToNumber(context, "100%", false),
                    height: index != state.index
                        ? code.percentageToNumber(context, "40%", true)
                        : code.percentageToNumber(context, "49%", true),
                    margin: EdgeInsets.only(
                      right: code.percentageToNumber(context, "5%", false),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        index != state.index
                            ? code.percentageToNumber(context, "1%", true)
                            : code.percentageToNumber(context, "3%", true),
                      ),
                      image: new DecorationImage(
                        // image: state.artistList[index][3] != null
                        image: imagePic(state, index)
                            ? FileImage(
                                new File.fromUri(
                                  Uri.parse(
                                      state.currentPlayingList[index].albumArt),
                                ),
                              )
                            : AssetImage(
                                "resources/no_coverM.png",
                                // "resources/nf.jpg",
                              ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: index != state.index
                      ? AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: index != state.index
                              ? code.percentageToNumber(context, "40%", true)
                              : code.percentageToNumber(context, "50%", true),
                          width: code.percentageToNumber(context, "90%", true),
                          margin: EdgeInsets.only(
                            right:
                                code.percentageToNumber(context, "5%", false),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              index != state.index
                                  ? code.percentageToNumber(context, "1%", true)
                                  : code.percentageToNumber(
                                      context, "3%", true),
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
                        )
                      : Container(),
                ),
              ],
            ),
          );
        });
  }
}
