part of 'playingbloc_bloc.dart';

@immutable
abstract class PlayingblocEvent {}

class DectectUnfinishGameEvent extends PlayingblocEvent {}

class StartNewGameEvent extends PlayingblocEvent {}

class ContinueUnfinishGameEvent extends PlayingblocEvent {}

class FinishGameEvent extends PlayingblocEvent {}

class RandomNumberEvent extends PlayingblocEvent {}

class ShowHistoryEvent extends PlayingblocEvent {}

class PauseAutoPlay extends PlayingblocEvent {}

class UpdateSettingEvent extends PlayingblocEvent {
  final bool autoPlay;
  final int delayAutoPlaySeconds;

  UpdateSettingEvent(this.autoPlay, this.delayAutoPlaySeconds);
}
