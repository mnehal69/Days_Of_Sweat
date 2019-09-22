import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PlayListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlayListWidgetState();
  }
}

class PlayListWidgetState extends State<PlayListWidget> {
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      rebuildOnChange: false,
      builder: (context, state) {
        return Container(
          height: code.percentageToNumber(context, "72%", true),
          width: code.percentageToNumber(context, "100%", false),
          // color: Colors.teal,
          child: GridView.count(            
            crossAxisCount: 2,
            children: state.refreshlist,
          ),
        );
      },
    );
  }
}
