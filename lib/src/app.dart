import 'package:days_of_sweat/src/screen/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import './../redux/store/main_store.dart';

class MyApp extends StatelessWidget {
  final Store store;

  MyApp({
    Key key,
    @required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: new StoreProvider<PlayerState>(
          store: store,
          child: MainScreen(),
        ),
      ),
    );
  }
}
