import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:days_of_sweat/redux/actions/main_actions.dart';

class FBackBar extends StatelessWidget {
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // StoreProvider.of<PlayerState>(context).dispatch(Expanding(false, true));
        StoreProvider.of<PlayerState>(context).dispatch(NavigateToAction.pop());
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
              // For iOS
              statusBarBrightness: Brightness.dark,
              // For Android M and higher
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white),
        );
      },
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
          left: code.percentageToNumber(context, "8%", false),
        ),
        child: Image.asset(
          'resources/dropdown-left.png',
          scale: 6,
        ),
      ),
    );
  }
}
