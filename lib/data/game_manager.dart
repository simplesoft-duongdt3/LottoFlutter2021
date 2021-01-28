import 'package:loto2021/data/setting.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'game.dart';

part 'game_manager.g.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs
@HiveType(typeId: 0)
class GameSaveInfo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  bool finish;

  @HiveField(2)
  List<int> gotNumbers;

  GameSaveInfo(this.id, this.finish, this.gotNumbers);
}

@HiveType(typeId: 1)
class SettingSaveInfo extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  bool autoPlay;

  @HiveField(2)
  int autoPlayDelaySeconds;

  @HiveField(3)
  String voice;

  SettingSaveInfo(
      this.id, this.autoPlay, this.autoPlayDelaySeconds, this.voice);
}

class GameManager {
  Game startNewGame() {
    return Game(DateTime.now().millisecondsSinceEpoch.toString(), []);
  }

  Game loadCacheGame() {
    var games = Hive.box<GameSaveInfo>('games');

    if (games.isNotEmpty) {
      var game = games.getAt(games.length - 1);
      if (!game.finish) {
        Game cachedGame = Game(game.id, game.gotNumbers);
        return cachedGame;
      }
    }

    return null;
  }

  Future<void> saveGameToCache(Game game) async {
    var games = Hive.box<GameSaveInfo>('games');
    games.put(game.id, GameSaveInfo(game.id, false, game.gotNumbers));
  }

  Future<void> finishGameToCache(Game game) async {
    var games = Hive.box<GameSaveInfo>('games');
    games.put(game.id, GameSaveInfo(game.id, true, game.gotNumbers));
  }

  void saveSetting(Setting setting) {
    var settings = Hive.box<SettingSaveInfo>('settings');
    settings.put(
        "setting",
        SettingSaveInfo("setting", setting.autoPlay,
            setting.autoPlayDelaySeconds, setting.voice));
  }

  Setting getCurrentSetting() {
    var settings = Hive.box<SettingSaveInfo>('settings');
    if (settings.isNotEmpty) {
      var settingCached = settings.values.last;

      return Setting(settingCached.autoPlay, settingCached.autoPlayDelaySeconds,
          settingCached.voice);
    }

    return Setting(false, 3, "male");
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GameSaveInfoAdapter());
    Hive.registerAdapter(SettingSaveInfoAdapter());
    await Hive.openBox<GameSaveInfo>("games");
    await Hive.openBox<SettingSaveInfo>("settings");
  }
}
