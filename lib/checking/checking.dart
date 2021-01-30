import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CheckingScreen extends StatefulWidget {
  const CheckingScreen({Key key}) : super(key: key);

  @override
  _CheckingScreenState createState() => _CheckingScreenState();
}

class _CheckingScreenState extends State<CheckingScreen> {
  final List<int> _selectedNumbers = [];
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
                Expanded(
                  child: AutoSizeText(
                    "${_selectedNumbers.length} numbers  " +
                        _selectedNumbers.join('  '),
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.rule),
                  iconSize: 48,
                  tooltip: 'Check winner',
                  alignment: Alignment.center,
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: _formChild(context),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_handleCheck()},
        tooltip: 'Check winner',
        child: Icon(Icons.check),
      ),
    );
  }

  List<Widget> _formChild(BuildContext context) {
    List<Widget> items = [];
    items.add(buildItemsRow(1, 10, Colors.grey[50]));
    items.add(SizedBox(
      height: 8,
    ));
    items.add(buildItemsRow(11, 19, Colors.grey[350]));
    items.add(SizedBox(
      height: 8,
    ));
    items.add(buildItemsRow(21, 29, Colors.grey[50]));
    items.add(SizedBox(
      height: 8,
    ));
    items.add(buildItemsRow(31, 39, Colors.grey[350]));
    items.add(SizedBox(
      height: 8,
    ));
    items.add(buildItemsRow(41, 49, Colors.grey[50]));
    items.add(SizedBox(
      height: 8,
    ));
    items.add(buildItemsRow(51, 59, Colors.grey[350]));
    items.add(SizedBox(
      height: 8,
    ));
    items.add(buildItemsRow(61, 69, Colors.grey[50]));
    items.add(SizedBox(
      height: 8,
    ));
    items.add(buildItemsRow(71, 79, Colors.grey[350]));
    items.add(SizedBox(
      height: 8,
    ));
    items.add(buildItemsRow(81, 90, Colors.grey[50]));

    return items;
  }

  Widget buildItemsRow(int from, int to, Color color) {
    List<Widget> items = [];
    for (var i = from; i <= to; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedNumbers.contains(i),
        label: Text(i.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            )),
        elevation: 4,
        labelPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        pressElevation: 5,
        backgroundColor: color,
        selectedColor: Theme.of(context).accentColor,
        onSelected: (bool selected) {
          setState(() {
            if (_selectedNumbers.contains(i)) {
              _selectedNumbers.remove(i);
            } else {
              _selectedNumbers
                  .removeWhere((item) => item >= from && item <= to);
              _selectedNumbers.add(i);
              _selectedNumbers.sort((a, b) => a.compareTo(b));
            }
          });
        },
      );

      items.add(Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: choiceChip,
      ));
    }
    var row1 = Wrap(
      children: items,
    );
    return row1;
  }

  void _handleCheck() {
    if (_selectedNumbers.length != 5) {
      _showDialogInputInvalid();
    } else {
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Are you sure?"),
          content: new Text(
              "You want to check winner with 5 numbers: [${_selectedNumbers.join('  ')}]?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Check winner'),
              textColor: Colors.blueAccent,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(_selectedNumbers);
              },
            ),
            FlatButton(
              child: Text('Close'),
              textColor: Colors.redAccent,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      //Navigator.of(context).pop();
    }
  }

  void _showDialogInputInvalid() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Check winner"),
        content: new Text("You must choice 5 numbers for checking winner."),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            textColor: Colors.redAccent,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
