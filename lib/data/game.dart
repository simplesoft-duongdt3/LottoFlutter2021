import 'dart:math';

abstract class GameNumberResult {}

class NumberResult extends GameNumberResult {
  final int number;

  NumberResult(this.number);
}

class NotFoundNumberResult extends GameNumberResult {}

class Game {
  String id;
  List<int> gotNumbers = [];
  List<int> _numbers = [];

  Game(String id, List<int> gotNumbers) {
    this.id = id;
    this.gotNumbers.addAll(gotNumbers);
    for (var i = 1; i <= 10; i++) {
      if (!gotNumbers.contains(i)) {
        _numbers.add(i);
      }
    }
  }

  GameNumberResult randomNumber() {
    if (_numbers.isNotEmpty) {
      final _random = new Random();
      var gotNumber = _numbers[_random.nextInt(_numbers.length)];
      gotNumbers.add(gotNumber);
      _numbers.remove(gotNumber);
      return NumberResult(gotNumber);
    }
    return NotFoundNumberResult();
  }

  int getLastNumber() {
    if (gotNumbers.isEmpty) {
      return null;
    }
    return gotNumbers.last;
  }

  bool isNothingToRoll() {
    return _numbers.isEmpty;
  }
}
