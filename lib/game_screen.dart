import 'package:flutter/material.dart';
import 'game_model.dart';
import 'history_service.dart';
import 'hangman_utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameModel _game;
  int _totalWins = 0;
  int _totalLosses = 0;

  @override
  void initState() {
    super.initState();
    _game = GameModel();
    _loadHistoryAndStart();
  }

  Future<void> _loadHistoryAndStart() async {
    final history = await HistoryService.loadHistory();
    setState(() {
      _totalWins = history['wins']!;
      _totalLosses = history['losses']!;
    });
    _game.startNewGame();
    setState(() {});
  }

  void _onGuessLetter(String letter) {
    _game.guessLetter(letter);
    setState(() {});
  }

  void _startNewGame() {
    _game.startNewGame();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ahorcado - Partida ${_game.sessionGames}'),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ganadas: $_totalWins | Perdidas: $_totalLosses',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  _game.getHangmanDrawing(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: HangmanUtils.buildWordDisplay(_game.guessedLetters),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Errores: ${_game.errors} / 6',
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  if (_game.message.isNotEmpty)
                    Text(
                      _game.message,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _game.message.contains('Ganaste') ? Colors.green : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  Text(
                    'Letras correctas: ${_game.correctGuesses} | Erróneas: ${_game.wrongGuesses}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: HangmanUtils.buildKeyboard(
                usedLetters: _game.usedLetters,
                gameOver: _game.gameOver,
                currentWord: _game.currentWord,
                onGuess: _onGuessLetter,
              ),
            ),
            ElevatedButton(
              onPressed: _startNewGame,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Nueva Partida', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}