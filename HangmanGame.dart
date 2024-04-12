import 'dart:math';

class HangmanGame {
 final List<String> wordList;
 final Set<String> lettersGuessed = new Set<String>();
 final Set<String> lettersTried = new Set<String>();
static const int NUM_GUESSES = 6;
List<String> hangmanParts = ['O', '|', '/', '\\', '|', '/'];


 late List<String> wordToGuess; // Utilisation de late
 int wrongGuesses;

HangmanGame(this.wordList) : wrongGuesses = 0;

 void newGame() {
    wordToGuess = [wordList[Random().nextInt(wordList.length)]];
    wrongGuesses = 0;
    lettersGuessed.clear();
    lettersTried.clear(); 
 }

bool guessLetter(String letter) {
 lettersGuessed.add(letter);
 if (wordToGuess.contains(letter)) {
    // Logique pour gérer une bonne supposition
    return true; // Retourne true si la lettre est correcte
 } else {
    wrongGuesses++;
    String hangman = '';
    // Vérifier si le joueur a perdu
    for (int i = 0; i < wrongGuesses; i++) {
        hangman += hangmanParts[i];
      }
      print(hangman);
    if (wrongGuesses >= NUM_GUESSES) {
      print('Vous avez perdu! Le mot était ${wordToGuess}.');
      print('Pendu:');
      
      // Logique pour gérer la défaite, par exemple, terminer le jeu
      return false; // Retourne false si le joueur a perdu
    }
    return false; // Retourne false si la lettre est incorrecte
 }
}


String getCurrentState() {
 String state = '';
 // Convertir la String en une liste de lettres pour pouvoir parcourir chaque lettre
 for (var letter in wordToGuess[0].split('')) {
    if (lettersGuessed.contains(letter)) {
      state += letter;
    } else {
      state += '_';
    }
 }
 return state;
}
 Set<String> getLettersTried() {
    return lettersTried;
 }
}