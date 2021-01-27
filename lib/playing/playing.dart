import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/playingbloc_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlayingScreen extends StatelessWidget {
  const PlayingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayingblocBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.settings),
                      iconSize: 48,
                      tooltip: 'Settings',
                      alignment: Alignment.center,
                      onPressed: () {
                        //TODO show settings dialog
                      },
                    ),
                  ],
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
              if (state is StartedGameState ||
                  state is PlayingChangeNumberState) {
                return renderFloatingButtonPlayingChangeNumberState(context);
              } else if (state is PlayingEndGameState ||
                  state is RollingPlayingChangeNumberState) {
                return renderFloatingButtonPlayingEndGameState(context);
              } else {
                return renderFloatingButtonInitStart(context);
              }
            },
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      }),
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

  Widget renderFloatingButtonPlayingChangeNumberState(BuildContext context) {
    return FloatingActionButton(
      onPressed: () =>
          {BlocProvider.of<PlayingblocBloc>(context).add(RandomNumberEvent())},
      tooltip: 'Random number',
      child: Icon(Icons.play_arrow_sharp),
    );
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
}
