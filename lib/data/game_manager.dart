import 'game.dart';
import 'package:hive/hive.dart';

part 'game_manager.g.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs
@HiveType(typeId: 0)
class GameSaveInfo extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  bool finish;

  @HiveField(2)
  List<int> gotNumbers;

  GameSaveInfo(this.id, this.finish, this.gotNumbers);
}

class GameManager {
  Game startNewGame() {
    return Game(DateTime.now().millisecondsSinceEpoch, []);
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
}
