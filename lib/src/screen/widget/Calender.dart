// import 'package:days_of_sweat/src/screen/widget/Day.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './../widget/Day.dart';

class Calender extends StatefulWidget {
  final selectedDay, selectedMonth, selectedYear, darkMode, show;

  Calender(
      {this.selectedDay,
      this.selectedMonth,
      this.selectedYear,
      this.darkMode,
      this.show});

  @override
  State<StatefulWidget> createState() {
    return CalenderState(clicked: this.show);
  }
}

class CalenderState extends State<Calender> {
  List listOfDays = [];
  var dayList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  var selectedRow = [];
  var finish = [1, 10, 9, 16, 21, 27];
  var clicked;
  var clickedcounter = 0;
  var changed = false;
  CalenderState({this.clicked});

  @override
  void initState() {
    super.initState();
    set_month();
  }

  Future set_month() async {
    var date = new DateTime(widget.selectedYear, widget.selectedMonth, 1);
    var firstDayStart = DateFormat("E").format(date);
    int firstDayIndex = dayList.indexOf(firstDayStart);
    int lastday =
        new DateTime(widget.selectedYear, widget.selectedMonth + 1, 0).day;
    int daycounter = 1;
    for (int i = 0; i < 6; i++) {
      var columnList = [];
      for (int k = 0; k < 7; k++) {
        //print("$i[$k]");
        // print("$daycounter" + ":$lastday");
        //print("$k/$lastday === ${i == 4 && k < lastday}");
        //print(i == 0 && k < firstDayIndex || i == 4 && daycounter > lastday);
        var rowJson = {};
        if (i == 0 && k < firstDayIndex || i == 4 && daycounter > lastday) {
          rowJson = {
            "day": "",
            "finish": false,
            "selected": false,
            "rowSelected": false,
            "columnSelected": false,
            "heading": false,
            "empty": true,
            "show": false,
          };
        } else if (i == 5) {
          rowJson = {
            "day": dayList[k].substring(0, 1),
            "finish": false,
            "selected": false,
            "rowSelected": false,
            "columnSelected": false,
            "heading": true,
            "weekday": "",
            "empty": false,
            "show": false,
          };
        } else {
          if (widget.selectedDay == daycounter) {
            selectedRow = [i, k];
          }
          rowJson = {
            "day": daycounter,
            "finish": finish.contains(daycounter) ? true : false,
            "selected": widget.selectedDay == daycounter ? true : false,
            "rowSelected": false,
            "columnSelected": false,
            "heading": false,
            "weekday": widget.selectedDay == daycounter ? dayList[k] : "",
            "empty": false,
            "show": clicked && finish.contains(daycounter) ? true : false,
          };
          //print("dayCounter: $daycounter + clicked: $clicked + contain:${finish.contains(daycounter)} =  ${clicked && finish.contains(daycounter)}");
          daycounter++;
        }
        columnList.add(rowJson);
      }
      //print(columnList.toString());
      listOfDays.add(columnList);
      //print("\n ${listOfDays.toString()}");
    }
    for (int i = 0; i < listOfDays.length; i++) {
      if (i == selectedRow[0]) {
        for (int j = 0; j < 7; j++) {
          listOfDays[i][j]["rowSelected"] = true;
        }
      } else {
        listOfDays[i][selectedRow[1]]["columnSelected"] = true;
      }
    }
    //print(listOfDays.toString());
  }

  showDoneDays() {
    for (int i = 0; i < listOfDays.length; i++) {
      for (int j = 0; j < 7; j++) {
        if (finish.contains(listOfDays[i][j]["day"])) {
          listOfDays[i][j]["show"] = this.clicked;
        } else {
          listOfDays[i][j]["show"] = false;
        }
      }
    }
  }

  click(day) {
    // print("Clicking");
    if (finish.contains(day)) {
      if (clickedcounter == 0) {
        setState(() {
          this.clicked = true;
          this.clickedcounter++;
        });
      } else {
        setState(() {
          this.clicked = false;
          this.clickedcounter = 0;
        });
      }
      showDoneDays();
    }
  }
  
  selectedChange(row, column, cellTitle, empty) {
    //print("title:$cellTitle + dayList:${dayList[column].substring(0, 1)}= ${cellTitle.toString().contains(dayList[column].substring(0, 1))}");
    if (!cellTitle.toString().contains(dayList[column].substring(0, 1)) &&
        !empty) {
      for (int i = 0; i < listOfDays.length; i++) {
        for (int j = 0; j < 7; j++) {
          listOfDays[i][j]["selected"] = false;
          listOfDays[i][j]["rowSelected"] = false;
          listOfDays[i][j]["columnSelected"] = false;
          listOfDays[i][j]["weekday"] = "";
        }
      }

      for (int i = 0; i < listOfDays.length; i++) {
        if (i == row) {
          for (int j = 0; j < 7; j++) {
            listOfDays[i][j]["rowSelected"] = true;
          }
        } else {
          listOfDays[i][column]["columnSelected"] = true;
        }
      }
      listOfDays[row][column]["selected"] = true;
      listOfDays[row][column]["weekday"] = dayList[column];
      setState(() {});
    }
  }

  buildTableRows(result, dark, row, column) {
    return InkWell(
        onDoubleTap: () => this.click(result["day"]),
        onTap: () =>
            this.selectedChange(row, column, result["day"], result["empty"]),
        child: Day(
          day: result["day"],
          finish: result["finish"],
          columnSelected: result["columnSelected"],
          heading: result["heading"],
          rowSelected: result["rowSelected"],
          selected: result["selected"],
          weekday: result["weekday"],
          empty: result["empty"],
          darkmode: dark,
          show: result["show"],
        ));
  }

  buildRows(result, dark, rowIndex) {
    return TableRow(
      children: List.generate(result.length,
          (index) => buildTableRows(result[index], dark, rowIndex, index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dark = widget.darkMode;
    return Table(
      children: List.generate(listOfDays.length,
          (index) => buildRows(listOfDays[index], dark, index)),
    );
  }
}
