import 'package:days_of_sweat/redux/route_aware_widget.dart';
import 'package:days_of_sweat/src/screen/MainScreen.dart';
import 'package:days_of_sweat/src/screen/PlayerScreen.dart';
import 'package:days_of_sweat/src/screen/widget/FMusic/main_screen/FMusicMain.dart';
import 'package:days_of_sweat/src/screen/widget/FMusic/main_screen/artist/artist_playlist/artist_playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import './../redux/store/main_store.dart';
import 'package:days_of_sweat/redux/reducers/main_reducer.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';

// final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // final store = Store<PlayerState>(playerStateReducer,
  final store = Store<PlayerState>(
      combineReducers<PlayerState>([playerStateReducer]),
      initialState: PlayerState(),
      middleware: [
        NavigationMiddleware(),
      ]);

  MyApp({
    Key key,
  }) : super(key: key);

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
    return new StoreProvider<PlayerState>(
      store: store,
      child: MaterialApp(
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
