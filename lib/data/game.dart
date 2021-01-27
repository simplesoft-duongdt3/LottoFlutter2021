import 'dart:math';

abstract class GameNumberResult {}

class NumberResult extends GameNumberResult {
  final int number;

  NumberResult(this.number);
}

class NotFoundNumberResult extends GameNumberResult {}

class Game {
  int id;
  List gotNumbers = [];
  List numbers = [];

  Game(this.id, this.gotNumbers) {
    for (var i = 1; i <= 10; i++) {
      if (!gotNumbers.contains(i)) {
        numbers.add(i);
      }
    }
  }

  GameNumberResult randomNumber() {
    if (numbers.isNotEmpty) {
      final _random = new Random();
      var gotNumber = numbers[_random.nextInt(numbers.length)];
      gotNumbers.add(gotNumber);
      numbers.remove(gotNumber);
      return NumberResult(gotNumber);
    }
    return NotFoundNumberResult();
  }
}
