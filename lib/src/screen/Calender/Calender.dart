import 'package:days_of_sweat/redux/store/main_store.dart';

import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Calender extends StatelessWidget {
  final code = ResusableCode();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          width: code.percentageToNumber(context, "90%", false),
          height: code.percentageToNumber(context, "55%", true),
          child: GridView.count(
            crossAxisCount: 7,
            scrollDirection: Axis.vertical,
            children: state.generatedCalenderList,
          ),
        );
      },
    );
  }
}
