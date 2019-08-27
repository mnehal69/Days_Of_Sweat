import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';

class FTitleBar extends StatelessWidget {
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: code.percentageToNumber(context, "4%", true),
        left: code.percentageToNumber(context, "5%", false),
      ),
      child: Row(
        children: [
          TitleText(
            title: "Artist",
            isSelected: true,
          ),
          TitleText(
            title: "Playlist",
            isSelected: false,
          ),
          TitleText(
            title: "Music",
            isSelected: false,
          ),
        ],
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final bool isSelected;
  final String title;
  final ResusableCode code = ResusableCode();
  TitleText({this.isSelected, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: code.percentageToNumber(context, "3%", false),
          ),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: this.isSelected ? Colors.white : HexColor("#615E5E"),
              fontFamily: "Roboto-Light",
              fontSize: code.percentageToNumber(context, "4%", true),
            ),
          ),
        ),
      ],
    );
  }
}
