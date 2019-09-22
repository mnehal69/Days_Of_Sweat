import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:flutter/material.dart';

class Counter {
  final int counter;
  Counter({this.counter});
  MainState counting(MainState prevState, int count) {
    prevState.counter = 0;
    return prevState;
  }
}

class SelectedIndex {
  final int index;
  SelectedIndex({this.index});
  MainState selecting(MainState prevState, int index) {
    int prevIndexSelected = prevState.calenderSelectedIndex;
    if (prevIndexSelected != -1) {
      print("empty:${prevState.calenderlist[index].empty}");

      if (!prevState.calenderlist[index].empty) {
        prevState.calenderlist.forEach((f) => f.setSelected(false));

        prevState.calenderlist[index].setSelected(true);
      }
    }
    prevState.calenderSelectedIndex = index;
    return prevState;
  }
}

class MonthOrYear {
  final int monthIndex;
  final int yearIndex;
  final List year;
  MonthOrYear({this.monthIndex, this.yearIndex, this.year});
  MainState whichMonth(
      MainState prevState, List yearlist, int monthIndex, int yearIndex) {
    prevState.monthIndex = monthIndex;
    prevState.yearIndex = yearIndex;
    prevState.year = yearlist;

    return prevState;
  }
}

class CalenderList {
  final List<Widget> generatedList;
  CalenderList({this.generatedList});
  MainState calender(MainState prevState, List<Widget> list) {
    prevState.generatedCalenderList = list;
    return prevState;
  }
}
