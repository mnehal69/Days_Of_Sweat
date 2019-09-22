import 'package:days_of_sweat/redux/reducers/calender_reducer.dart';
import 'package:days_of_sweat/redux/reducers/player_reducer.dart';
import 'package:days_of_sweat/redux/route_aware_widget.dart';
import 'package:days_of_sweat/src/screen/MainScreen.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
// import 'package:redux/redux.dart';
// import 'package:days_of_sweat/redux/reducers/main_reducer.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

import 'src/screen/MusicPlayer/Local/FMusic/main_screen/FMusicMain.dart';
import 'src/screen/MusicPlayer/Local/FMusic/main_screen/artist/artist_playlist/artist_playlist.dart';
import 'src/screen/MusicPlayer/Local/player/PlayerScreen.dart';

void main() async {
  // var remoteDevtools = RemoteDevToolsMiddleware('192.168.10.3:8000');

  // final store = DevToolsStore<MainState>(
  final store = Store<MainState>(
    combineReducers<MainState>([playerStateReducer, calenderStateReducer]),
    initialState: MainState(),
    middleware: [
      // remoteDevtools,
      NavigationMiddleware(),
    ],
  );
  // remoteDevtools.store = store;
  // await remoteDevtools.connect();
  runApp(new MyApp(store: store));
}

class MyApp extends StatefulWidget {
  final store;
  MyApp({
    Key key,
    this.store,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(store: store);
  }
}

class MyAppState extends State<MyApp> {
  final store;
  MyAppState({
    this.store,
  });

  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          // For iOS
          statusBarBrightness: Brightness.light,
          // For Android M and higher
          statusBarIconBrightness: Brightness.light,
          statusBarColor: HexColor("#1a1b1f")),
    );
  }

  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/playlist':
        return _buildRoute(settings, ArtistPlayList());
      case '/player':
        // return _buildRoute(settings, PlayerScreen());
        return FabRoute(PlayerScreen(), settings: settings);
      case '/music':
        return FabRoute(FMusicMain(), settings: settings);
      default:
        return _buildRoute(settings, MainScreen());
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<MainState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData(
          backgroundColor: HexColor("#1a1b1f"),
          primaryColor: HexColor("#FF0031"),
          accentColor: HexColor("#FF4F8C"),
          fontFamily: "Lato",
        ),
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigatorHolder.navigatorKey,
        onGenerateRoute: _getRoute,
      ),
    );
  }
}

class FabRoute<T> extends MaterialPageRoute<T> {
  FabRoute(Widget widget, {RouteSettings settings})
      : super(
            builder: (_) => RouteAwareWidget(child: widget),
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child);
  }
}
