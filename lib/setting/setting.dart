import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import '../data/setting.dart';
import 'package:loto2021/data/audio_manager.dart';

class SettingScreen extends StatefulWidget {
  final Setting _setting;
  const SettingScreen(this._setting, {Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AudioManager _audioManager = AudioManager();

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _formChild(context),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.of(context).pop()},
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }

  List<Widget> _formChild(BuildContext context) {
    var items = [
      Text("Voice"),
      CustomRadioButton(
        elevation: 0,
        enableButtonWrap: true,
        absoluteZeroSpacing: true,
        unSelectedColor: Theme.of(context).canvasColor,
        buttonLables: [
          'Female',
          'Male',
        ],
        buttonValues: [
          "female",
          "male",
        ],
        buttonTextStyle: ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.black,
            textStyle: TextStyle(fontSize: 16)),
        radioButtonValue: (value) {
          setState(() {
            widget._setting.voice = value;
            _audioManager.playHelloAudio(value);
          });
        },
        selectedColor: Theme.of(context).accentColor,
        defaultSelected: widget._setting.voice,
      ),
      SizedBox(
        height: 16,
      ),
      Text("Auto play"),
      CustomRadioButton(
        elevation: 0,
        enableButtonWrap: true,
        absoluteZeroSpacing: true,
        unSelectedColor: Theme.of(context).canvasColor,
        buttonLables: [
          'Auto',
          'Manual',
        ],
        buttonValues: [
          true,
          false,
        ],
        buttonTextStyle: ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.black,
            textStyle: TextStyle(fontSize: 16)),
        radioButtonValue: (value) {
          setState(() {
            widget._setting.autoPlay = value;
          });
        },
        selectedColor: Theme.of(context).accentColor,
        defaultSelected: widget._setting.autoPlay,
      ),
    ];

    if (widget._setting.autoPlay) {
      var itemsAutoPlayDepend = [
        SizedBox(
          height: 16,
        ),
        Text('Delay auto play ' +
            widget._setting.autoPlayDelaySeconds.toString() +
            " seconds"),
        Slider(
          value: widget._setting.autoPlayDelaySeconds.toDouble(),
          min: 1,
          max: 30,
          divisions: 30,
          label: widget._setting.autoPlayDelaySeconds.toString() + " seconds",
          onChanged: (double value) {
            setState(() {
              widget._setting.autoPlayDelaySeconds = value.toInt();
            });
          },
        )
      ];

      items.addAll(itemsAutoPlayDepend);
    }

    return items;
  }
}
