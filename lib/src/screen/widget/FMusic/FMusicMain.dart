import 'package:days_of_sweat/redux/actions/main_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FMusicMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FMusicMainState();
  }
}

class FMusicMainState extends State<FMusicMain> {
  var dragged = false;
  var code = ResusableCode();
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          //color: Colors.blueGrey,
          margin: EdgeInsets.only(
              top: code.percentageToNumber(context, "3%", true)),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        StoreProvider.of<PlayerState>(context)
                            .dispatch(Expanding(false, true));
                        setState(() {
                          dragged = true;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: code.percentageToNumber(context, "5%", false),
                        ),
                        child: Image.asset(
                          "resources/dropdown-down-arrow2.png",
                          scale: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        );
      },
    );
  }
}

// AnimatedOpacity(
//               duration: Duration(seconds: 10),
//               opacity: state.expand ? 1.0 : 0.0,
//               child: ListView.builder(
//                 itemBuilder: (context, position) {
//                   return Card(
//                     child: Text(state.songlist[position].title),
//                   );
//                 },
//                 itemCount: state.songlist.length,
//               ),
//             );
