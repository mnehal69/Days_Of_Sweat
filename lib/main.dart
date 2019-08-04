import 'package:days_of_sweat/redux/reducers/main_reducer.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:flutter/material.dart';
import './src/app.dart';
import 'package:redux/redux.dart';
import './redux/reducers/main_reducer.dart';
import './redux/store/main_store.dart';

void main() {
  final store = Store<PlayerState>(
    playerStateReducer,
    initialState: PlayerState(),
  );
  runApp(MyApp(
    store: store,
  ));
}
