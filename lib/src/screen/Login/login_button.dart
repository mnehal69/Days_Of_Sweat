import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// SocialButton class is the reuseable widget
/// to be used for social media Api login
/// */
class SocialButton extends StatelessWidget {
  final code = ResusableCode();
  final String bgcolor; //Background Color of button
  final String type; //Facebook,Google, Or Custom
  final double elevation; //Default Shadow
  final dynamic textColor; //Text Color
  final double clickedElevation; //Clicked Shadow
  final dynamic clickedfunction; //On Pressed Function
  SocialButton(
      {this.textColor,
      this.bgcolor,
      this.type,
      this.elevation,
      this.clickedElevation,
      this.clickedfunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 50.0,
      margin: EdgeInsets.all(10.0),
      child: RaisedButton.icon(
        shape: new RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.white54, width: 1.0, style: BorderStyle.solid),
            borderRadius: new BorderRadius.circular(20.0)),
        highlightElevation: clickedElevation,
        textColor: code.colorcheck(this.textColor),
        onPressed: this.clickedfunction,
        elevation: this.elevation,
        icon: new Icon(
          typecheck(type)[0],
          size: 25.0,
        ),
        label: Text(
          typecheck(type)[1],
          style: TextStyle(fontSize: 12.0),
        ),
        color: code.colorcheck(this.bgcolor),
      ),
    );
  }

  //return an array of text and icon for button
  dynamic typecheck(String type) {
    if (type.toLowerCase().contains("facebook")) {
      return [FontAwesomeIcons.facebookF, "Sign in With Facebook"];
    } else if (type.toLowerCase().contains("google")) {
      return [FontAwesomeIcons.google, "Sign in With Google"];
    } else if (type.isEmpty) {
      return [FontAwesomeIcons.qrcode, "Null"];
    } else {
      return [FontAwesomeIcons.question, type];
    }
  }
}
