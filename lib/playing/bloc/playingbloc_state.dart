part of 'playingbloc_bloc.dart';

@immutable
abstract class PlayingblocState {}

class PlayingInitState extends PlayingblocState {}

class StartedGameState extends PlayingblocState {}

class DetectUnfinishGameState extends PlayingblocState {
  final bool isHaveUnfinishGame;

  DetectUnfinishGameState(this.isHaveUnfinishGame);
}

class RollingPlayingChangeNumberState extends PlayingblocState {}

class PausedGameState extends PlayingblocState {

}

class PlayingChangeNumberState extends PlayingblocState {
  final int number;
  final bool isAutoPlay;
  PlayingChangeNumberState(this.number, this.isAutoPlay);
}

class PlayingEndGameState extends PlayingblocState {}
