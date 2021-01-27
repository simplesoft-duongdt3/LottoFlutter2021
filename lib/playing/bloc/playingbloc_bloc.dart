import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:loto2021/data/game.dart';
import 'package:loto2021/data/setting.dart';
import 'package:loto2021/data/game_manager.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
part 'playingbloc_event.dart';
part 'playingbloc_state.dart';

class PlayingblocBloc extends Bloc<PlayingblocEvent, PlayingblocState> {
  PlayingblocBloc() : super(PlayingInitState());
  Setting _setting = Setting(false, 3);
  Game _game;
  GameManager _gameManager = GameManager();

  Setting getSetting() {
    return Setting(_setting.autoPlay, _setting.autoPlayDelaySeconds);
  }

  @override
  Stream<PlayingblocState> mapEventToState(
    PlayingblocEvent event,
  ) async* {
    if (event is DectectUnfinishGameEvent) {
      yield DetectUnfinishGameState(_gameManager.loadCacheGame() != null);
    } else if (event is StartNewGameEvent) {
      _game = _gameManager.startNewGame();
      _gameManager.saveGameToCache(_game);

      yield StartedGameState();
    } else if (event is ContinueUnfinishGameEvent) {
      _game = _gameManager.loadCacheGame();

      if (_game != null) {
        _game = _gameManager.startNewGame();
      }
      _gameManager.saveGameToCache(_game);
      yield StartedGameState();
    } else if (event is FinishGameEvent) {
      _gameManager.finishGameToCache(_game);
      yield PlayingInitState();
    } else if (event is RandomNumberEvent) {
      var result = _game.randomNumber();
      if (result is NumberResult) {
        yield RollingPlayingChangeNumberState();
        await Future.delayed(Duration(seconds: 3));

        _gameManager.saveGameToCache(_game);
        yield PlayingChangeNumberState(result.number);

        await _playAudio(result.number);
      } else if (result is NotFoundNumberResult) {
        _gameManager.finishGameToCache(_game);
        yield PlayingEndGameState();
      }
    } else if (event is UiDoneWithRandomNumberEvent) {
      //TODO auto play
      if (_setting.autoPlay) {
        add(RandomNumberEvent());
      }
    } else if (event is UpdateSettingEvent) {
      _setting.autoPlay = event.autoPlay;
      _setting.autoPlayDelaySeconds = event.delayAutoPlaySeconds;
    }
  }

  Future<void> _playAudio(int number) async {
    final assetsAudioPlayer = AssetsAudioPlayer();

    await assetsAudioPlayer.open(
      Audio("assets/audios/${number}_female.mp3"),
      autoStart: true,
    );
  }
}
