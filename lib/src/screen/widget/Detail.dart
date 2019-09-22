import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/SMusic/music_player.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Detail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DetailState();
  }
}

class DetailState extends State<Detail> {
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      onInit: (store) {},
      builder: (context, state) {
        return Container(
          width: code.percentageToNumber(context, "100%", false),
          // color: Colors.green,
          height: code.percentageToNumber(context, "30%", true),
          child: Container(
            alignment: Alignment.bottomRight,
            child: Container(),
          ),
        );
      },
    );
  }
}
