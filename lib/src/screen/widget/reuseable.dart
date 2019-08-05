import 'dart:async';

import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/Song/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'hex_color.dart';
import './../../../redux/actions/main_actions.dart';

class ResusableCode {
  //check if the parameter color is hex code or Colors properties and return it.
  //----------------Example----------------------
  //|                                           |
  //|   colorcheck("#3b5998");                  |
  //|   colorcheck(Colors.red);                 |
  //|-------------------------------------------|
  bool permission = false;

  dynamic colorcheck(color) {
    if (color is Color) {
      return color;
    } else {
      return HexColor(color);
    }
  }

  void storage_checker(dynamic context) async {
    return await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then((onValue) {
      print(onValue);
      if (onValue == PermissionStatus.unknown ||
          onValue == PermissionStatus.denied) {
        PermissionHandler()
            .requestPermissions([PermissionGroup.storage]).then((p) {
          print(p.toString());
          permission = true;
        });
      }
      if (onValue == PermissionStatus.granted) {
        //StoreProvider.of<PlayerState>(context).dispatch(Permission(true));
        permission = true;
      }
    });
  }

  double percentageToNumber(BuildContext context, String val, bool height) {
    //height: percentageToNumber(context, "10%", true), [this is going to adjust 10% with respect to height]
    //width: percentageToNumber(context, "30%", false), [this is going to adjust 30% with respect to width ]
    // you can use with margin,padding,width,height or anything which required some double number.
    //
    //Example::
    //Container(
    //       height: code.percentageToNumber(context, "10%", true),
    //       width: code.percentageToNumber(context, "30%", false),
    //       child: Text("data"),
    //       color: Colors.deepOrangeAccent,
    //     ),

    double no = double.parse(val.substring(0, val.length - 1));
    if (height) {
      return ((no / 100) * MediaQuery.of(context).size.height);
    } else {
      return ((no / 100) * MediaQuery.of(context).size.width);
    }
  }
}
