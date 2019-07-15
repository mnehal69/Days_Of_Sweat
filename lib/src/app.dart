import 'package:days_of_sweat/src/screen/MainScreen.dart';
import 'package:flutter/material.dart';
import './screen/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: MainScreen(),
      ),
    );
  }
}
