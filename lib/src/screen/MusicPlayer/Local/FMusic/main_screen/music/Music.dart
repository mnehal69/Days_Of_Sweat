import 'package:days_of_sweat/redux/actions/main_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/FMusic/main_screen/artist/artist_playlist/PlayListAppBar.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/FMusic/main_screen/artist/artist_slider/App_Bar.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/FMusic/main_screen/artist/artist_slider/Back_bar.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/FMusic/main_screen/artist/artist_slider/Title_bar.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MusicList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MusicListState();
  }
}

class MusicListState extends State<MusicList> {
  final code = ResusableCode();
  ScrollController _controller;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        // For iOS
        statusBarBrightness: Brightness.light,
        // For Android M and higher
        statusBarIconBrightness: Brightness.light,
        statusBarColor: HexColor("#1a1b1f"),
      ),
    );
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    // print("ControllerRightNow:${_controller.offset}");
    // double no = _controller.position.maxScrollExtent -
    //     (0.80 * _controller.position.maxScrollExtent);
    // print("ControllerNo80%:${no}");
    // print(_controller.offset);
    if (_controller.offset >= code.percentageToNumber(context, "15%", true)) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(ScrollBar(shown: true, isAlbum: false));
    } else {
      StoreProvider.of<PlayerState>(context)
          .dispatch(ScrollBar(shown: false, isAlbum: false));
    }
    // if(_controller.offset<=)
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          body: Material(
            child: Container(
              color: HexColor("#1A1B1F"),
              //color: Colors.green,
              // child: Column(
              //   children: <Widget>[
              //PlayListAppBar(),
              //FlexibleAppBar(),
              //],
              child: CustomScrollView(
                controller: _controller,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: HexColor("#1A1B1F"),
                    title: Container(
                      color: Colors.red,
                    ),
                    leading: Container(),
                    flexibleSpace: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        //       // print("CH${constraints.biggest.height}");
                        //       // print("CH${constraints.maxHeight}");

                        return AnimatedOpacity(
                          opacity: state.appbarshown ? 0.0 : 1.0,
                          duration: Duration(microseconds: 50),
                          child: Container(
                            margin: EdgeInsets.only(
                              top: code.percentageToNumber(context, "6%", true),
                            ),
                            child: Column(
                              children: <Widget>[
                                FBackBar(),
                                FAppBar(),
                                FTitleBar(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    expandedHeight:
                        code.percentageToNumber(context, "30%", true),
                    pinned: true,
                    actions: <Widget>[
                      // Container(
                      //   width: code.percentageToNumber(context, "100%", false),
                      //   margin: EdgeInsets.only(
                      //     bottom: code.percentageToNumber(context, "5%", true),
                      //   ),
                      //   child: FBackBar(),
                      // )
                      PlayListAppBar(
                        shown: state.appbarshown,
                      ),
                    ],
                    // bottom: PreferredSize(
                    //   preferredSize: Size(10.0, 10.0),
                    //   child: Container(
                    //       margin: EdgeInsets.only(
                    //         bottom:
                    //             code.percentageToNumber(context, "7%", true),
                    //       ),
                    //       child: FTitleBar()),
                    // ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      width: code.percentageToNumber(context, "90%", false),
                      height: code.percentageToNumber(context, "10%", true),
                      padding: EdgeInsets.only(
                        top: code.percentageToNumber(context, "0%", true),
                        bottom: code.percentageToNumber(context, "5%", true),
                        left: code.percentageToNumber(context, "5%", false),
                        right: code.percentageToNumber(context, "5%", false),
                      ),
                      decoration: BoxDecoration(
                        color: HexColor("#121218"),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            code.percentageToNumber(context, "5%", false),
                          ),
                          topRight: Radius.circular(
                            code.percentageToNumber(context, "5%", false),
                          ),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              top: code.percentageToNumber(context, "2%", true),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Music List',
                              style: TextStyle(
                                color: HexColor("#44454C"),
                                fontFamily: "Roboto-Regular",
                                fontSize: code.percentageToNumber(
                                    context, "2%", true),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverFixedExtentList(
                    itemExtent: code.percentageToNumber(context, "7%", true),
                    delegate: new SliverChildBuilderDelegate((builder, index) {
                      // print("Length:${state.songlist.length}");
                      return Container(
                        color: HexColor("#121218"),
                        child: MusicCard(state: state, position: index),
                      );
                    }, childCount: state.songlist.length),
                  ),
                ],
              ),
            ),
          ),
        );
        //);
      },
    );
  }
}

class MusicCard extends StatelessWidget {
  final PlayerState state;
  final int position;
  final code = ResusableCode();

  String titleText(String text) {
    if (text.length > 25) {
      return text.substring(0, 25) + "...";
    } else {
      return text;
    }
  }

  MusicCard({this.state, this.position});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          code.playingFromPosition(context, state, this.position, false),
      child: position < state.songlist.length
          ? Container(
              // color: Colors.green,
              margin: EdgeInsets.only(
                top: code.percentageToNumber(context, "0%", true),
                bottom: code.percentageToNumber(context, "2%", true),
                left: code.percentageToNumber(context, "5%", false),
                right: code.percentageToNumber(context, "5%", false),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    position > 9 ? position.toString() : "0$position",
                    style: TextStyle(
                      color: HexColor("#656A71"),
                      fontFamily: "Lato",
                      fontSize: code.percentageToNumber(context, "2.5%", true),
                    ),
                  ),
                  Text(
                    titleText(state.songlist[position].title),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold,
                      fontSize: code.percentageToNumber(context, "3%", true),
                    ),
                  ),
                  Text(
                    code.durationfromMilliSeconds(
                        state.songlist[position].duration),
                    style: TextStyle(
                      color: HexColor("#44454C"),
                      fontFamily: "Lato",
                      fontSize: code.percentageToNumber(context, "2%", true),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'resources/skull.png',
                      scale: 4,
                    ),
                    Text(
                      "No More Music To Show",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Lato",
                        fontSize: code.percentageToNumber(context, "3%", true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
