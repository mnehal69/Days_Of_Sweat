import 'package:flutter/material.dart';
import 'hex_color.dart';

class ResusableCode {
  //check if the parameter color is hex code or Colors properties and return it.
  //----------------Example----------------------
  //|                                           |
  //|   colorcheck("#3b5998");                  |
  //|   colorcheck(Colors.red);                 |
  //|-------------------------------------------|
  dynamic colorcheck(color) {
    if (color is Color) {
      return color;
    } else {
      return HexColor(color);
    }
  }

  double percentageToNumber(BuildContext context, String val, bool height) {
    double no = double.parse(val.substring(0, val.length - 1));
    if (height) {
      return ((no / 100) * MediaQuery.of(context).size.height);
    } else {
      return ((no / 100) * MediaQuery.of(context).size.width);
    }
  }
}
