class DayModel {
  String day;
  bool selected;
  bool columnSelected;
  bool rowSelected;
  bool empty;
  bool show;
  bool finish;
  bool heading;
  int columnIndex;
  int rowIndex;

  setSelected(bool val) {
    this.selected = val;
  }

  DayModel(
      {this.day = "",
      this.selected = false,
      this.columnSelected = false,
      this.rowSelected = false,
      this.empty = true,
      this.finish = false,
      this.heading = false,
      this.columnIndex = -1,
      this.rowIndex = -1,
      this.show = false});

  @override
  String toString() {
    // return "{\n day: $day, selected: $selected, columnSelected: $columnSelected, rowSelected: $rowSelected,\n empty: $empty, finish: $finish, heading: $heading, columnIndex: $columnIndex, rowIndex:$rowIndex, show:$show}";
    return "{\n day: $day, selected: $selected, columnSelected: $columnSelected, rowSelected: $rowSelected, empty: $empty, columnIndex: $columnIndex, rowIndex:$rowIndex}";
  }
}
