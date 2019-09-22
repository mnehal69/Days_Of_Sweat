import 'dart:core';
import 'dart:io';

import 'package:days_of_sweat/redux/actions/calender_action.dart';
import 'package:days_of_sweat/redux/actions/player_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/Calender/CalenderCell.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar2 extends StatefulWidget {
  final year;
  final month;
  final day;
  CustomAppBar2({
    this.year,
    this.month,
    this.day,
  });
  @override
  State<StatefulWidget> createState() {
    return CustomAppBar2State();
  }
}

class CustomAppBar2State extends State<CustomAppBar2> {
  PageController monthController;
  PageController yearController;

  final code = ResusableCode();

  @override
  void initState() {
    super.initState();

    monthController =
        PageController(initialPage: widget.month, viewportFraction: 0.75);
    yearController =
        PageController(initialPage: widget.year, viewportFraction: 0.2);
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MainState, MainState>(
        converter: (store) => store.state,
        onInitialBuild: (state) {
          // print("cools:${widget.year}");

          StoreProvider.of<MainState>(context).dispatch(MonthOrYear(
              monthIndex: widget.month,
              year: state.year,
              yearIndex: widget.year));
          code.intializedCalender(
              context: context,
              month: state.monthIndex,
              selectedDay: widget.day,
              state: state,
              year: state.yearIndex);
        },
        builder: (context, state) {
          return Container(
            width: code.percentageToNumber(context, "100%", false),
            height: code.percentageToNumber(context, "15%", true),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  width: code.percentageToNumber(context, "100%", false),
                  height: code.percentageToNumber(context, "6%", true),
                  margin: EdgeInsets.only(
                    bottom: code.percentageToNumber(context, "1%", false),
                  ),
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: this.yearController,
                    itemCount: state.year.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          state.year[index].toString(),
                          style: TextStyle(
                            color: state.yearIndex == index
                                ? Colors.white
                                : Colors.grey,
                            fontFamily: "Lato",
                            fontSize:
                                code.percentageToNumber(context, "4%", true),
                          ),
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      StoreProvider.of<MainState>(context).dispatch(MonthOrYear(
                          yearIndex: index,
                          year: state.year,
                          monthIndex: state.monthIndex));
                      var today =
                          state.year[widget.year] == state.year[index] &&
                              code.monthList[widget.month] ==
                                  code.monthList[state.monthIndex];

                      code.intializedCalender(
                          context: context,
                          month: state.monthIndex,
                          selectedDay: today ? widget.day : -1,
                          state: state,
                          year: state.yearIndex);
                    },
                  ),
                ),
                Container(
                  width: code.percentageToNumber(context, "100%", false),
                  height: code.percentageToNumber(context, "8%", true),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: code.percentageToNumber(context, "80%", false),
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: this.monthController,
                          itemCount: code.monthList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text(
                                code.monthList[index],
                                style: TextStyle(
                                  color: state.monthIndex == index
                                      ? Colors.white
                                      : Colors.grey,
                                  fontFamily: "Lato",
                                  fontSize: 50,
                                ),
                              ),
                            );
                          },
                          onPageChanged: (index) {
                            // print("Month changing: $index");
                            StoreProvider.of<MainState>(context).dispatch(
                                MonthOrYear(
                                    yearIndex: state.yearIndex,
                                    year: state.year,
                                    monthIndex: index));
                            var today = state.year[widget.year] ==
                                    state.year[state.yearIndex] &&
                                code.monthList[widget.month] ==
                                    code.monthList[index];
                            // print("cooled:$same");
                            code.intializedCalender(
                                context: context,
                                month: state.monthIndex,
                                selectedDay: today ? widget.day : -1,
                                state: state,
                                year: state.yearIndex);
                            // StoreProvider.of<MainState>(context).dispatch(
                            //   CalenderList(
                            //     generatedList: List.generate(
                            //       state.calenderlist.length,
                            //       (index) => CalenderCell(
                            //         index: index,
                            //       ),
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                      ),
                      Container(
                        width: code.percentageToNumber(context, "20%", false),
                        child: GestureDetector(
                          onTap: () {
                            StoreProvider.of<MainState>(context).dispatch(
                                ScrollBar(shown: false, isAlbum: false));

                            StoreProvider.of<MainState>(context)
                                .dispatch(NavigateToAction.push('/music'));
                          },
                          child: Icon(
                            FontAwesomeIcons.play,
                            color: Colors.white,
                            size: code.percentageToNumber(context, "5%", true),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
