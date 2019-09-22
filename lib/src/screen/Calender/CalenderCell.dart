import 'package:days_of_sweat/redux/actions/calender_action.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'Day.dart';

class CalenderCell extends StatefulWidget {
  int row;
  int column;
  int index;
  CalenderCell({this.index, this.row, this.column});

  @override
  _CalenderCellState createState() => _CalenderCellState();
}

class _CalenderCellState extends State<CalenderCell> {
  changeSelect(context, MainState state, int index) {
    // print(" prevday:${state.calenderlist[state.calenderSelectedIndex].day}");
    StoreProvider.of<MainState>(context).dispatch(SelectedIndex(index: index));
    // print(" day:${state.calenderlist[index].day}");
  }

  @override
  Widget build(BuildContext context) {
    var code = ResusableCode();
    return new StoreConnector<MainState, MainState>(
      converter: (store) => store.state,
      onInit: (store) {
        widget.row = store.state.calenderlist[widget.index].rowIndex;
        widget.column = store.state.calenderlist[widget.index].columnIndex;
      },
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () => this.changeSelect(context, state, widget.index),
          child: Day(
            daylist: code.dayList,
            day: widget.row == 6
                ? code.dayList[widget.column].substring(0, 1)
                : state.calenderlist[widget.index].day,
            index: widget.index,
          ),
        );
      },
    );
  }
}
