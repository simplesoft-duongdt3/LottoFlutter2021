import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  final List<int> numbers;
  const HistoryScreen(this.numbers, {Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
                  icon: Icon(Icons.history),
                  iconSize: 48,
                  tooltip: 'History',
                  alignment: Alignment.center,
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _formChild(context),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_handleCloseClick()},
        tooltip: 'Close',
        child: Icon(Icons.close),
      ),
    );
  }

  Widget _formChild(BuildContext context) {
    return Wrap(
      children: buildItemsRow(widget.numbers),
    );
  }

  List<Widget> buildItemsRow(List<int> numbers) {
    List<int> preverseNumbers = numbers.reversed.toList();
    return preverseNumbers.map((item) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: false,
        label: Text(item.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            )),
        elevation: 4,
        labelPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        pressElevation: 5,
        backgroundColor: Colors.grey[50],
        selectedColor: Theme.of(context).accentColor,
        onSelected: (bool selected) {},
      );
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: choiceChip,
      );
    }).toList();
  }

  void _handleCloseClick() {
    Navigator.of(context).pop();
  }
}
