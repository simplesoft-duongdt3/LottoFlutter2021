import 'package:flutter/material.dart';
import 'playing/playing.dart';
import 'data/game_manager.dart';

void main() async {
  await GameManager.init();
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
