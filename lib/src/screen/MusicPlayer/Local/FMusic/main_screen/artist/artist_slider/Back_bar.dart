import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';

class FBackBar extends StatelessWidget {
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        StoreProvider.of<MainState>(context).dispatch(NavigateToAction.pop());
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
