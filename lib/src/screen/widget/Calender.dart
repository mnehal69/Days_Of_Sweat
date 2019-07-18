// import 'package:days_of_sweat/src/screen/widget/Day.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './../widget/new_day.dart';

class Calender extends StatefulWidget {
  final selectedDay, selectedMonth, selectedYear, darkMode;

  Calender(
      {this.selectedDay, this.selectedMonth, this.selectedYear, this.darkMode});

  @override
  State<StatefulWidget> createState() {
    return CalenderState();
  }
}

class CalenderState extends State<Calender> {
  List listOfDays = [];
  var dayList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  var selectedRow = [];
  var finish = [1, 10, 9, 16, 21, 27];

  @override
  void initState() {
    super.initState();
    set_month();
  }

  Future set_month() async {
    var date = new DateTime(widget.selectedYear, widget.selectedMonth, 1);
    var firstDayStart = DateFormat("E").format(date);
    int firstDayIndex = dayList.indexOf(firstDayStart);
    int lastday = 30;
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
          };
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

  buildRows(result, dark) {
    return TableRow(children: [
      Day(
        day: result[0]["day"],
        finish: result[0]["finish"],
        columnSelected: result[0]["columnSelected"],
        heading: result[0]["heading"],
        rowSelected: result[0]["rowSelected"],
        selected: result[0]["selected"],
        weekday: result[0]["weekday"],
        empty: result[0]["empty"],
        darkmode: dark,
      ),
      Day(
        day: result[1]["day"],
        finish: result[1]["finish"],
        columnSelected: result[1]["columnSelected"],
        heading: result[1]["heading"],
        rowSelected: result[1]["rowSelected"],
        selected: result[1]["selected"],
        weekday: result[1]["weekday"],
        empty: result[1]["empty"],
        darkmode: dark,
      ),
      Day(
        day: result[2]["day"],
        finish: result[2]["finish"],
        columnSelected: result[2]["columnSelected"],
        heading: result[2]["heading"],
        rowSelected: result[2]["rowSelected"],
        selected: result[2]["selected"],
        weekday: result[2]["weekday"],
        empty: result[2]["empty"],
        darkmode: dark,
      ),
      Day(
        day: result[3]["day"],
        finish: result[3]["finish"],
        columnSelected: result[3]["columnSelected"],
        heading: result[3]["heading"],
        rowSelected: result[3]["rowSelected"],
        selected: result[3]["selected"],
        weekday: result[3]["weekday"],
        empty: result[3]["empty"],
        darkmode: dark,
      ),
      Day(
        day: result[4]["day"],
        finish: result[4]["finish"],
        columnSelected: result[4]["columnSelected"],
        heading: result[4]["heading"],
        rowSelected: result[4]["rowSelected"],
        selected: result[4]["selected"],
        weekday: result[4]["weekday"],
        empty: result[4]["empty"],
        darkmode: dark,
      ),
      Day(
        day: result[5]["day"],
        finish: result[5]["finish"],
        columnSelected: result[5]["columnSelected"],
        heading: result[5]["heading"],
        rowSelected: result[5]["rowSelected"],
        selected: result[5]["selected"],
        weekday: result[5]["weekday"],
        empty: result[5]["empty"],
        darkmode: dark,
      ),
      Day(
        day: result[6]["day"],
        finish: result[6]["finish"],
        columnSelected: result[6]["columnSelected"],
        heading: result[6]["heading"],
        rowSelected: result[6]["rowSelected"],
        selected: result[6]["selected"],
        empty: result[5]["empty"],
        darkmode: dark,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var dark = widget.darkMode;
    //print("WELCOME\n ${listOfDays[2][1]["day"]}");
    return Table(
      children: List.generate(
          listOfDays.length, (index) => buildRows(listOfDays[index], dark)),
      // TableRow(children: [
      //   Day(day: "01", finish: true),
      //   Day(day: "02"),
      //   Day(day: "03", finish: true, columnSelected: true),
      //   Day(day: "04"),
      //   Day(day: "05"),
      //   Day(day: "06"),
      //   Day(day: "07")
      // ]),
      // TableRow(children: [
      //   Day(day: "S", heading: true),
      //   Day(day: "M", heading: true),
      //   Day(day: "T", columnSelected: true, heading: true),
      //   Day(day: "W", heading: true),
      //   Day(day: "T", heading: true),
      //   Day(day: "F", heading: true),
      //   Day(day: "S", heading: true)
      // ]),
      //],
    );
  }
}
