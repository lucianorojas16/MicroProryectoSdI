import 'package:flutter/material.dart';  // Import agregado para widgets como Row, Column, Text, etc.
import 'dart:math';

class HangmanUtils {
  static String getDrawing(int errors) {
    const List<String> drawings = [
      '     ',
      '  O  ',
      '  O  \n /|\\ ',
      '  O  \n /|\\ \n /  ',
      '  O  \n /|\\ \n / \\ ',
      '  O  \n /|\\ \n / \\ \n==== ',
      '  O-- \n /|\\ \n / \\ \n==== ',
    ];
    return drawings[min(errors, 6)];
  }

  static Widget buildWordDisplay(List<String> guessedLetters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: guessedLetters.map((letter) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          letter.isEmpty ? '_' : letter,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      )).toList(),
    );
  }

  static Widget buildKeyboard({
    required Set<String> usedLetters,
    required bool gameOver,
    required String currentWord,
    required Function(String) onGuess,
  }) {
    const List<String> alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
                                   'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
    return Column(
      children: [
        for (int i = 0; i < alphabet.length; i += 7)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: alphabet.skip(i).take(7).map((letter) {
              bool isUsed = usedLetters.contains(letter);
              bool isCorrect = isUsed && currentWord.contains(letter);
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  onPressed: (isUsed || gameOver) ? null : () => onGuess(letter),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCorrect ? Colors.green : (isUsed ? Colors.grey : Colors.blue),
                  ),
                  child: Text(
                    letter,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}