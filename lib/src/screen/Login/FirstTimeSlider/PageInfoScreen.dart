import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:flutter/material.dart';

class PageInfo extends StatelessWidget {
  final String heading;
  final String image;
  final String info;
  final code = ResusableCode();
  dynamic imageBgColor;
  dynamic textColor;
  dynamic backgroundColor;
  dynamic headingColor;
  final String imageContainerHeight;
  final bool last;
  final pressedfunction;
  final buttonText;
  PageInfo(
      {this.heading,
      this.image,
      this.info,
      this.imageBgColor,
      this.textColor,
      this.headingColor,
      this.backgroundColor,
      this.imageContainerHeight,
      this.last,
      this.pressedfunction,
      this.buttonText});

  String remaining(String val) {
    String result =
        (100 - (int.parse(val.substring(0, val.length - 1)))).toString() + "%";
    // print("IMAGE:${this.imageContainerHeight}+REMAINING:${result}");
    return result;
  }

  double remainingHeight(BuildContext context, int percent) {
    String textBoxSizePercent = remaining(this.imageContainerHeight);
    // print("TEXTBOX SIZE:${textBoxSizePercent}");

    int totalpercent = int.parse(
        textBoxSizePercent.substring(0, textBoxSizePercent.length - 1));
    double total = (totalpercent / 100) * MediaQuery.of(context).size.height;
    return ((percent / 100) * total);
  }

  Widget button(BuildContext context) {
    if (last == true) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: remainingHeight(context, 20),
        child: RaisedButton(
          onPressed: this.pressedfunction,
          elevation: 10.0,
          highlightElevation: 20.0,
          color: code.colorcheck(this.textColor),
          child: Text(
            this.buttonText,
            style: TextStyle(
                fontSize: code.percentageToNumber(context, "5%", true),
                color: code.colorcheck(this.backgroundColor)),
          ),
        ),
      );
    } else {
      return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: code.colorcheck(this.backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: code.percentageToNumber(
                  context, this.imageContainerHeight, true),
              color: code.colorcheck(this.imageBgColor),
              child: Center(
                child: Container(
                  // color: Colors.yellow,
                  width: code.percentageToNumber(context, "70%", false),
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: new AssetImage(this.image))),
                  // child: Image.asset(this.image),
                ),
              )),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            // color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: code.percentageToNumber(
                context, remaining(this.imageContainerHeight), true),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 0.0),
                    // color: Colors.yellow,
                    height: remainingHeight(context, 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          this.heading,
                          style: TextStyle(
                              color: code.colorcheck(this.headingColor),
                              fontFamily: "Lato",
                              fontSize:
                                  code.percentageToNumber(context, "8%", true)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: code.percentageToNumber(context, "5%", false),
                            top: code.percentageToNumber(context, "1%", true),
                            right:
                                code.percentageToNumber(context, "5%", false),
                          ),
                          child: Text(
                            this.info,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: code.colorcheck(this.textColor),
                              fontFamily: "Poppins",
                              fontSize:
                                  code.percentageToNumber(context, "3%", true),
                            ),
                          ),
                        ),
                      ],
                    )),
                button(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
