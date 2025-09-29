import 'dart:math';
import 'history_service.dart';
import 'hangman_utils.dart';

class GameModel {
  static const List<String> _words = ['FLUTTER', 'DART', 'MOVIL', 'APRENDIZAJE', 'JUEGO'];

  String _currentWord = '';
  List<String> _guessedLetters = [];
  Set<String> _usedLetters = <String>{};
  int _errors = 0;
  int _sessionGames = 0;
  bool _gameOver = false;
  String _message = '';

  String get currentWord => _currentWord;
  List<String> get guessedLetters => _guessedLetters;
  Set<String> get usedLetters => _usedLetters;
  int get errors => _errors;
  int get sessionGames => _sessionGames;
  bool get gameOver => _gameOver;
  String get message => _message;
  int get correctGuesses => _guessedLetters.where((l) => l.isNotEmpty).length;
  int get wrongGuesses => _usedLetters.length - correctGuesses;

  void startNewGame() {
    _currentWord = _words[Random().nextInt(_words.length)];
    _guessedLetters = List.generate(_currentWord.length, (index) => '');
    _usedLetters.clear();
    _errors = 0;
    _gameOver = false;
    _message = '';
    _sessionGames++;
    print('Nueva partida. Palabra: $_currentWord');
  }

  void guessLetter(String letter) {
    if (_usedLetters.contains(letter) || _gameOver) return;

    _usedLetters.add(letter);

    if (_currentWord.contains(letter)) {
      for (int i = 0; i < _currentWord.length; i++) {
        if (_currentWord[i] == letter) {
          _guessedLetters[i] = letter;
        }
      }
      if (!_guessedLetters.contains('') && !_gameOver) {
        _gameOver = true;
        _message = '¡Ganaste! La palabra era: $_currentWord';
        HistoryService.incrementWins();
      }
    } else {
      _errors++;
      if (_errors >= 6) {
        _gameOver = true;
        _message = '¡Perdiste! La palabra era: $_currentWord';
        HistoryService.incrementLosses();
      }
    }
    
  }

  String getHangmanDrawing() {
    return HangmanUtils.getDrawing(_errors);
  }
}