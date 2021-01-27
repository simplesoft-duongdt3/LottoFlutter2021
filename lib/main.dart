import 'package:flutter/material.dart';
import 'playing/playing.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'data/game_manager.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GameSaveInfoAdapter());
  await Hive.openBox<GameSaveInfo>("games");
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
