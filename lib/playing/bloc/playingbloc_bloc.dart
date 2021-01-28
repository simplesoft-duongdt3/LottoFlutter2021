import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:loto2021/data/game.dart';
import 'package:loto2021/data/setting.dart';
import 'package:loto2021/data/game_manager.dart';
import 'package:loto2021/data/audio_manager.dart';

part 'playingbloc_event.dart';
part 'playingbloc_state.dart';

class _AutoRandomNumberEvent extends PlayingblocEvent {}

class _HandleRandomNumberEvent extends PlayingblocEvent {}

class PlayingblocBloc extends Bloc<PlayingblocEvent, PlayingblocState> {
  GameManager _gameManager = GameManager();
  Setting _setting;
  Game _game;
  AudioManager _audioManager = AudioManager();
  bool _isPauseGame = false;
  StreamSubscription _jobAutoRandom;
  StreamSubscription _jobRandom;

  PlayingblocBloc() : super(PlayingInitState()) {
    _setting = _gameManager.getCurrentSetting();
  }

  Setting getSetting() {
    return _setting;
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

      if (_game == null) {
        _game = _gameManager.startNewGame();
      }
      _gameManager.saveGameToCache(_game);
      yield StartedGameState();
    } else if (event is PauseAutoPlay) {
      _isPauseGame = true;
      if (_jobAutoRandom != null) {
        _jobAutoRandom.cancel();
      }
      yield PausedAutoPlayState();
    } else if (event is _HandleRandomNumberEvent) {
      var result = _game.randomNumber();
      if (result is NumberResult) {
        _gameManager.saveGameToCache(_game);
        var autoPlay = _setting.autoPlay;

        _audioManager.playAudio(result.number, _setting.voice);
        yield PlayingChangeNumberState(
            result.number, autoPlay && !_isPauseGame);

        if (autoPlay) {
          add(_AutoRandomNumberEvent());
        }
      } else {
        _gameManager.finishGameToCache(_game);
        yield PlayingEndGameState();
      }
    } else if (event is FinishGameEvent) {
      _gameManager.finishGameToCache(_game);
      yield PlayingInitState();
    } else if (event is RandomNumberEvent) {
      _isPauseGame = false;
      yield* handleRandomNumberEvent();
    } else if (event is _AutoRandomNumberEvent) {
      var autoPlayDelaySeconds = _setting.autoPlayDelaySeconds;
      if (_jobAutoRandom != null) {
        _jobAutoRandom.cancel();
      }
      _jobAutoRandom = Future.delayed(Duration(seconds: autoPlayDelaySeconds))
          .asStream()
          .listen((_) {
        add(RandomNumberEvent());
      });
    } else if (event is UpdateSettingEvent) {
      _setting.autoPlay = event.autoPlay;
      _setting.autoPlayDelaySeconds = event.delayAutoPlaySeconds;
    }
  }

  Stream<PlayingblocState> handleRandomNumberEvent() async* {
    if (_game.isNothingToRoll()) {
      _gameManager.finishGameToCache(_game);
      yield PlayingEndGameState();
    } else {
      yield RollingPlayingChangeNumberState();
      if (_jobRandom != null) {
        _jobRandom.cancel();
      }
      _jobRandom = Future.delayed(Duration(seconds: 3)).asStream().listen((_) {
        if (!_isPauseGame) {
          add(_HandleRandomNumberEvent());
        }
      });
    }
  }

  void saveSetting() {
    _gameManager.saveSetting(_setting);
  }

  bool checkWinner(List<int> numbers) {
    return numbers.every((item) {
      return _game.gotNumbers.contains(item);
    });
  }
}
