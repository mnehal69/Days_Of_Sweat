import 'package:days_of_sweat/redux/actions/calender_action.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';

MainState calenderStateReducer(MainState prevState, dynamic action) {
  if (action is Counter) {
    return action.counting(prevState, action.counter);
  }
  if (action is SelectedIndex) {
    return action.selecting(prevState, action.index);
  }
  if (action is MonthOrYear) {
    return action.whichMonth(
        prevState, action.year, action.monthIndex, action.yearIndex);
  }
  if (action is CalenderList) {
    return action.calender(prevState, action.generatedList);
  }
  return prevState;
}
