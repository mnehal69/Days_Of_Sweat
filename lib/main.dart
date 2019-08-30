import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';
import './src/app.dart';
import 'package:days_of_sweat/redux/reducers/main_reducer.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

void main() async {
  // var remoteDevtools = RemoteDevToolsMiddleware('192.168.10.4:8000');
  // await remoteDevtools.connect();
  // final store = DevToolsStore<PlayerState>(
    final store = Store<PlayerState>(
    combineReducers<PlayerState>([playerStateReducer]),
    initialState: PlayerState(),
    middleware: [
      // remoteDevtools,
      NavigationMiddleware(),
    ],
  );

  // remoteDevtools.store = store;
  runApp(MyApp(
    store: store,
  ));
}
