import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loto2021/setting/setting.dart';
import 'package:loto2021/checking/checking.dart';
import 'bloc/playingbloc_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlayingScreen extends StatelessWidget {
  const PlayingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayingblocBloc()..add(DectectUnfinishGameEvent()),
      child: Builder(builder: (context) {
        return BlocListener<PlayingblocBloc, PlayingblocState>(
            listener: (context, state) {
              if (state is DetectUnfinishGameState) {
                if (state.isHaveUnfinishGame) {
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            title: new Text("Detected a unfinish game"),
                            content: new Text(
                                "Do you want to resume unfinish game?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Start new game'),
                                textColor: Colors.blueAccent,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  BlocProvider.of<PlayingblocBloc>(context)
                                      .add(StartNewGameEvent());
                                },
                              ),
                              FlatButton(
                                child: Text('Resume unfinish game'),
                                textColor: Colors.redAccent,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  BlocProvider.of<PlayingblocBloc>(context)
                                      .add(ContinueUnfinishGameEvent());
                                },
                              )
                            ],
                          ));
                }
              }
            },
            child: renderBodyScreen(context));
      }),
    );
  }

  Scaffold renderBodyScreen(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            BlocBuilder<PlayingblocBloc, PlayingblocState>(
              builder: (context, state) {
                List<Widget> items = _buildWidgetsFromSettings(context);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: items,
                );
              },
            ),
            Expanded(
              child: Center(
                child: BlocBuilder<PlayingblocBloc, PlayingblocState>(
                  builder: (context, state) {
                    if (state is PlayingChangeNumberState) {
                      return renderPlayingChangeNumberState(state, context);
                    } else if (state is RollingPlayingChangeNumberState) {
                      return renderRollingPlayingChangeNumberState(context);
                    } else if (state is PlayingEndGameState) {
                      return renderPlayingEndGameState(context);
                    } else if (state is StartedGameState) {
                      return renderStartedGameState(context);
                    } else if (state is PausedAutoPlayState) {
                      return renderPausedAutoPlayState(context);
                    } else {
                      return renderInitStart(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<PlayingblocBloc, PlayingblocState>(
        builder: (context, state) {
          if (state is StartedGameState) {
            return renderFloatingButtonStartedGameState(context);
          } else if (state is PausedAutoPlayState) {
            return renderFloatingButtonPausedAutoPlayState(context);
          } else if (state is PlayingChangeNumberState) {
            return renderFloatingButtonPlayingChangeNumberState(context, state);
          } else if (state is PlayingEndGameState ||
              state is RollingPlayingChangeNumberState) {
            return renderFloatingButtonPlayingEndGameState(context);
          } else {
            return renderFloatingButtonInitStart(context);
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Column renderInitStart(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AutoSizeText(
          "Press Play button",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
      ],
    );
  }

  Column renderPlayingEndGameState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "End game",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Column renderPlayingChangeNumberState(
      PlayingChangeNumberState state, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "${state.number}",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget renderFloatingButtonInitStart(BuildContext context) {
    return FloatingActionButton(
      onPressed: () =>
          {BlocProvider.of<PlayingblocBloc>(context).add(StartNewGameEvent())},
      tooltip: 'Start new game',
      child: Icon(Icons.play_arrow_sharp),
    );
  }

  Widget renderFloatingButtonPlayingEndGameState(BuildContext context) {
    return SizedBox(
      height: 0,
      width: 0,
    );
  }

  Widget renderFloatingButtonPlayingChangeNumberState(
      BuildContext context, PlayingChangeNumberState state) {
    if (state.isAutoPlay) {
      return FloatingActionButton(
        onPressed: () =>
            {BlocProvider.of<PlayingblocBloc>(context).add(PauseAutoPlay())},
        tooltip: 'Pause auto play',
        child: Icon(Icons.pause),
      );
    } else {
      return renderCanPlayButton(context);
    }
  }

  Widget renderStartedGameState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Let's go!",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget renderRollingPlayingChangeNumberState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitSquareCircle(
          color: Colors.indigoAccent,
          size: 80.0,
        ),
      ],
    );
  }

  FloatingActionButton renderFloatingButtonStartedGameState(
      BuildContext context) {
    return renderCanPlayButton(context);
  }

  FloatingActionButton renderCanPlayButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () =>
          {BlocProvider.of<PlayingblocBloc>(context).add(RandomNumberEvent())},
      tooltip: 'Random number',
      child: Icon(Icons.play_arrow_sharp),
    );
  }

  FloatingActionButton renderFloatingButtonPausedAutoPlayState(
      BuildContext context) {
    return renderCanPlayButton(context);
  }

  Widget renderPausedAutoPlayState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AutoSizeText(
          "Paused",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ],
    );
  }

  List<Widget> _buildWidgetsFromSettings(BuildContext context) {
    List<Widget> items = [];
    var setting = BlocProvider.of<PlayingblocBloc>(context).getSetting();

    String settingText = "";
    if (setting.voice == "female") {
      settingText += "Female voice";
    } else {
      settingText += "Male voice";
    }

    if (setting.autoPlay) {
      settingText += " Auto play ${setting.autoPlayDelaySeconds} seconds";
    }

    items.add(Expanded(
      child: AutoSizeText(
        settingText,
        style: Theme.of(context).textTheme.headline4,
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    ));
    items.add(IconButton(
      icon: Icon(Icons.settings),
      iconSize: 48,
      tooltip: 'Settings',
      alignment: Alignment.center,
      onPressed: () async {
        await _handleClickSetting(context);
      },
    ));

    return items;
  }

  Future _handleClickSetting(BuildContext context) async {
    var setting = BlocProvider.of<PlayingblocBloc>(context).getSetting();
    BlocProvider.of<PlayingblocBloc>(context).add(PauseAutoPlay());
    List<int> result = await Navigator.push(
      context,
      //MaterialPageRoute(builder: (context) => SettingScreen(setting)),
      MaterialPageRoute(builder: (context) => CheckingScreen()),
    );
    BlocProvider.of<PlayingblocBloc>(context).saveSetting();

    if (result != null) {
      var checkWinner =
          BlocProvider.of<PlayingblocBloc>(context).checkWinner(result);

      if (checkWinner) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("You win!"),
                  content: new Text("You are winner!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Start new game'),
                      textColor: Colors.blueAccent,
                      onPressed: () {
                        Navigator.of(context).pop();
                        BlocProvider.of<PlayingblocBloc>(context)
                            .add(StartNewGameEvent());
                      },
                    ),
                    FlatButton(
                      child: Text('Resume unfinish game'),
                      textColor: Colors.redAccent,
                      onPressed: () {
                        Navigator.of(context).pop();
                        BlocProvider.of<PlayingblocBloc>(context)
                            .add(ContinueUnfinishGameEvent());
                      },
                    )
                  ],
                ));
      }
    }
  }
}
