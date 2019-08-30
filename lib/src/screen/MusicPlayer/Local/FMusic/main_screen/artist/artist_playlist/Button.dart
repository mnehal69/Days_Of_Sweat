import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ArtistButton extends StatelessWidget {
  final icon;
  ArtistButton({this.icon});
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: code.percentageToNumber(context, "13%", false),
      height: code.percentageToNumber(context, "13%", true),
      margin: EdgeInsets.only(
        left: code.percentageToNumber(context, "2%", false),
      ),
      decoration: BoxDecoration(
        color: HexColor("#DC153C"),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: code.percentageToNumber(context, "3%", true),
      ),
    );
  }
}
