import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';

class FAppBar extends StatelessWidget {
  final ResusableCode code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: code.percentageToNumber(context, "3%", true),
        left: code.percentageToNumber(context, "10%", false),
      ),
      child: Row(
        children: [
          TitleText(
            title: "Local",
            isSelected: true,
          ),
          TitleText(
            title: "Online",
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
              color: this.isSelected ? Colors.white : HexColor("#929292"),
              fontFamily: "Lato",
              fontSize: code.percentageToNumber(context, "4%", true),
            ),
          ),
        ),
        this.isSelected
            ? Container(
                width: code.percentageToNumber(context, "25%", false),
                margin: EdgeInsets.only(
                  left: code.percentageToNumber(context, "3%", false),
                ),
                height: code.percentageToNumber(context, "0.8%", true),
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   width: 16.0,
                  //   color: Colors.transparent,
                  // ),
                  borderRadius: new BorderRadius.circular(40.0),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment
                        .centerRight, // 10% of the width, so there are ten blinds.
                    colors: [
                      HexColor("#FF0031"),
                      HexColor("#FF4F8C"),
                    ], // whitish to gray
                    tileMode: TileMode
                        .repeated, // repeats the gradient over the canvas
                  ),
                ),
              )
            : Container(
                width: code.percentageToNumber(context, "25%", false),
                margin: EdgeInsets.only(
                  left: code.percentageToNumber(context, "3%", false),
                ),
                height: code.percentageToNumber(context, "0.8%", true),
              ),
      ],
    );
  }
}
