import 'package:flutter/material.dart';
import 'playing/playing.dart';
import 'data/game_manager.dart';
import 'package:screen/screen.dart';

void main() async {
  await GameManager.init();
  await Screen.keepOn(true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lotto 2021',
      theme: ThemeData(
        fontFamily: 'JerseyM54',
        primarySwatch: Colors.blue,
      ),
      home: PlayingScreen(),
    );
  }
}
