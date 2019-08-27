import 'package:days_of_sweat/redux/actions/main_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomButton extends StatelessWidget {
  final code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          width: code.percentageToNumber(context, "98%", false),
          height: code.percentageToNumber(context, "5%", true),
          margin: EdgeInsets.only(
            bottom: code.percentageToNumber(context, "0.5%", true),
            left: code.percentageToNumber(context, "1%", true),
            right: code.percentageToNumber(context, "1%", true),
          ),
          // color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: InkWell(
                  child: Container(
                    // color: Colors.blue,
                    child: Stack(
                      children: <Widget>[
                        Image.asset('resources/no-loop.png'),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width:
                                code.percentageToNumber(context, "4%", false),
                            height:
                                code.percentageToNumber(context, "4%", true),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: false
                                  ? Image.asset('resources/infinity.png')
                                  : Text(
                                      "1",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.volumeUp,
                  color: !state.volumeBarVisible ? Colors.grey : Colors.white,
                ),
                onPressed: () {
                  StoreProvider.of<PlayerState>(context).dispatch(
                      VolumeControl(!state.volumeBarVisible, state.volume));
                },
              )
            ],
          ),
        );
      },
    );
  }
}
