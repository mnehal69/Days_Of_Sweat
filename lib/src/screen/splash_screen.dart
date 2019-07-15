import 'package:flutter/material.dart';
import './widget/login_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:days_of_sweat/src/screen/firstTimeSlider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String type = "logins";
  String logoImage = "resources/with_shadow.gif";
  bool visible = false;
  final size = 13.0;
  Animation<RelativeRect> animation;
  AnimationController animationController;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Not Authorized";
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listofBiometrics;
    try {
      listofBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _availableBiometricTypes = listofBiometrics;
      print("list:${listofBiometrics.toString()}");
    });
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to login in your app",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized) {
        _authorizedOrNot = "Authorized";
      } else {
        _authorizedOrNot = "Not Authorized";
      }
    });
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
      if (canCheckBiometric) {
        _authorizeNow();
      } else {
        Fluttertoast.showToast(msg: "No Fingerprint Sensor in this device");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = RelativeRectTween(
            begin: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
            end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 300.0))
        .animate(animationController);

    animation.addListener(() {
      setState(() {
        if (animation.value.bottom == 300.0) {
          logoImage = "resources/s1.png";
          visible = true;
        } else {
          // print(animation.value.bottom);
        }
      });
    });

    // animation.addStatusListener((status) => print(status));
    animationController.forward(); //that's make animation move forward
  }

  loginOrSignInWithFacebook() {
    Fluttertoast.showToast(msg: "FACEBOOK BUTTON CLICKED");
  }

  loginOrSignInWithGoogle() {
    Fluttertoast.showToast(msg: "Google BUTTON CLICKED");
  }

  // void fingerprintbottomsheet() {
  //    showModalBottomSheet(
  //      context: context,
  //      builder: (builder) {
  //        return new Container(
  //          height: 285,
  //          color: HexColor("#2b343b"),
  //          child: Column(
  //            children: <Widget>[
  //              Container(
  //                margin: EdgeInsets.only(top: 20.0),
  //                child: Text(
  //                  "Fingeprint Authentication",
  //                  style: TextStyle(color: Colors.white, fontSize: 30.0),
  //                ),
  //              ),
  //              Container(
  //                margin: EdgeInsets.only(top: 10.0),
  //                child: Text(
  //                  "Scan Your Verfied Finger on your Fingerprint Sensor",
  //                  style: TextStyle(color: Colors.white, fontSize: 15.0),
  //                ),
  //              ),
  //              Container(
  //                margin: EdgeInsets.only(top: 0.0),
  //                alignment: Alignment.bottomCenter,
  //                height: 200,
  //                child: Image.asset("resources/fingeprint.gif"),
  //              ),
  //            ],
  //          ),
  //        );
  //      },
  //    );
  // }

  Widget logo() {
    // if (type.compareTo("login") == 0) {
    //   return Container(
    //     margin: EdgeInsets.only(top: 50.0),
    //     child: Image.asset(image_uri),
    //   );
    // } else {
    return PositionedTransition(
      rect: animation,
      child: Image.asset(logoImage),
    );
    //}
  }

  Widget button() {
    // if (type.compareTo("login") == 0) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.only(bottom: 40.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 70.0,
              width: 70.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                    color: Colors.black87,
                    style: BorderStyle.solid,
                    width: 4.0),
              ),
              padding: EdgeInsets.fromLTRB(2.0, 0.0, 8.0, 20.0),
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 50.0),
              child: IconButton(
                icon: new Icon(
                  FontAwesomeIcons.fingerprint,
                  size: 40.0,
                ),
                onPressed: this._checkBiometric,
                color: Colors.black54,
              ),
            ),
            SocialButton(
              type: "facebook",
              elevation: 10.0,
              clickedElevation: 20.0,
              bgcolor: "#3b5998",
              textColor: Colors.white,
              clickedfunction: this.loginOrSignInWithFacebook,
            ),
            SocialButton(
              type: "google",
              elevation: 10.0,
              clickedElevation: 20.0,
              bgcolor: "#d34836",
              clickedfunction: this.loginOrSignInWithGoogle,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
    // } else {
    //   return Text("");
    // }
  }

  // Color background_color(type) {
  //   if (type.compareTo("login") == 0) {
  //     return Colors.black12;
  //   } else {
  //     return Colors.transparent;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
              image: new AssetImage('resources/portrait_v1.jpg'),
              fit: BoxFit.cover,
            )),
          ),
          logo(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                color: visible ? Colors.black12 : Colors.transparent,
                height: 370.0,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      button(),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Verdana',
                              color: Color.fromRGBO(255, 255, 255, 100),
                              fontSize: size,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "By "),
                              TextSpan(
                                text: "Yes Fam",
                                style: TextStyle(
                                  fontFamily: 'San-Serif',
                                  color: Color.fromRGBO(255, 212, 0, 100),
                                  fontSize: size,
                                ),
                              ),
                              TextSpan(text: ", For "),
                              TextSpan(
                                text: "Yes Fam",
                                style: TextStyle(
                                  fontFamily: 'San-Serif',
                                  color: Color.fromRGBO(255, 212, 0, 100),
                                  fontSize: size,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
