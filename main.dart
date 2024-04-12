import "dart:io";
import 'dart:convert';
import "HangmanGame.dart";
void main() {
 bool continueGame = true;
 HangmanGame game;

String cheminFichier = 'dictionnaire.txt';

 List<String> wordList;
  try {
    var file = File(cheminFichier);
    if (!file.existsSync()) {
      file.createSync();
      file.writeAsStringSync(jsonEncode([]));
    }
    wordList = List<String>.from(jsonDecode(file.readAsStringSync()));
      game = HangmanGame(wordList);
  } catch (e) {
    print('Erreur lors de la lecture du fichier de dictionnaire. Assurez-vous que le fichier contient une liste de mots en JSON.');
    return;
  }

 while (continueGame) {
    print("1. Jouer");
    print("2. Dictionnaire");
    print("3. Quitter");
    print("Choisissez une option :");
    var option = stdin.readLineSync();
    switch (option) {
      case "1":
        game.newGame();
        while (true) {
          print('Mot à deviner : ${game.getCurrentState()}');
          print('Lettres déjà essayées : ${game.getLettersTried().join(', ')}');
          print('Entrez une lettre :');
          String? letter = stdin.readLineSync();
          bool correct = game.guessLetter(letter!);
          if (correct) {
            print('Bonne lettre!');
          } else {
            print('Mauvaise lettre!');
          }
          if (game.getCurrentState() == game.wordToGuess[0]) {
            print('Vous avez gagné!');
            break;
          } else if (game.wrongGuesses >= 6) {
            print('Vous avez perdu! Le mot était ${game.wordToGuess}.');
            break;
          }
        }
        break;
      case "2":
        Dictionnaire(wordList, cheminFichier);
        break;
      case "3":
        print("Voulez-vous vraiment quitter ? (O/N)");
        String confirmation;
        do {
          confirmation = stdin.readLineSync()!.toLowerCase();
          if (confirmation == "o") {
          print("Casses toi pov'con !");
          continueGame = false;
          } else if (confirmation == "n") {
          print("Vous avez changé d'avis. Continuons le jeu !");
          continueGame = true;
          } else {
          print("Veuillez entrer 'O' pour oui ou 'N' pour non.");
          }
      } while (confirmation != "o" && confirmation != "n");
      break;
      default:
        print("Option invalide. Veuillez réessayer.");
    }
 }
}

void Dictionnaire(List<String> dictionnaire, String cheminFichier) {
  while (true) {
    print('Menu du dictionnaire:');
    print('1) Ajouter');
    print('2) Modifier');
    print('3) Supprimer');
    print('4) Retour');
    stdout.write('Choisissez une option: ');
    String? option = stdin.readLineSync();

    switch (option) {
      case '1':
        ajouterMot(dictionnaire, cheminFichier);
        break;
      case '2':
        modifierMot(dictionnaire, cheminFichier);
        break;
      case '3':
        supprimerMot(dictionnaire, cheminFichier);
        break;
      case '4':
        return;
      default:
        print('Option invalide.');
    }
  }
}

void lireMots(List<String> dictionnaire) {
  if (dictionnaire.isEmpty) {
    print('Le dictionnaire est vide.');
  } else {
    print('Mots dans le dictionnaire:');
    for (String mot in dictionnaire) {
      print(mot);
    }
  }
}

void ajouterMot(List<String> dictionnaire, String cheminFichier) {
  lireMots(dictionnaire);

  stdout.write('Entrez un nouveau mot: ');
  String? mot = stdin.readLineSync();

  if (mot != null && mot.isNotEmpty) {
    dictionnaire.add(mot);

    File(cheminFichier).writeAsStringSync(jsonEncode(dictionnaire));

    print('Mot ajouté.');
  } else {
    print('Mot invalide.'); 
  }
}
void modifierMot(List<String> dictionnaire, String cheminFichier) {
  lireMots(dictionnaire);
  
  stdout.write('Entrez le mot à modifier: ');
  String? ancienMot = stdin.readLineSync();
  
  stdout.write('Entrez le nouveau mot: ');
  String? nouveauMot = stdin.readLineSync();
  
  if (ancienMot != null && ancienMot.isNotEmpty && nouveauMot != null && nouveauMot.isNotEmpty) {
    int index = dictionnaire.indexOf(ancienMot);
    
    if (index != -1) {
      dictionnaire[index] = nouveauMot;
      
      File(cheminFichier).writeAsStringSync(jsonEncode(dictionnaire));
      
      print('Mot modifié.');
    } else {
      print('Mot non trouvé.');
    }
  } else {
    print('Mot invalide.');
  }
}

void supprimerMot(List<String> dictionnaire, String cheminFichier) {
  lireMots(dictionnaire);
  
  stdout.write('Entrez le mot à supprimer: ');
  String? mot = stdin.readLineSync();
  
  if (mot != null && mot.isNotEmpty) {
    if (dictionnaire.remove(mot)) {
      File(cheminFichier).writeAsStringSync(jsonEncode(dictionnaire));      
      print('Mot supprimé.');
    } else {
      print('Mot non trouvé.');
    }
  } else {
    print('Mot invalide.');
  }
}


