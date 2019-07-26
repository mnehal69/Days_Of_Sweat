import 'package:appspector/appspector.dart';
import 'package:flutter/material.dart';
import './src/app.dart';

void runAppSpector() {
  var config = new Config();
  // config.iosApiKey = "Your iOS API_KEY";
  config.androidApiKey =
      "android_ODZkZGU0NjEtMTdlYi00NTNlLWE5MDEtZTNjMDM0MjdlMWFk";
  AppSpectorPlugin.run(config);
}

void main() {
  runAppSpector();
  runApp(App());
}
