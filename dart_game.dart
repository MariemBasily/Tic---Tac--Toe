import 'dart:io';
import 'dart:math';

// List to represent the Tic-Tac-Toe board.
List<String> values = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
// List of winning combinations represented by indices.
List<String> combinations = [
  '012',
  '036',
  '048',
  '147',
  '246',
  '258',
  '345',
  '678'
];

bool winner = false; // Initially, there is no winner in beginning.
bool isxturn = true; // 'Player X' starts the game.
int movecount = 0; // Count the number of moves made.
Random random = Random(); // Random object to generate computer's move.

// Function to display the current state of the Tic-Tac-Toe board.
void generateBoard() {
  print('     |     |     ');
  print('  ${values[0]}  |  ${values[1]}  |  ${values[2]}  ');
  print('_____|_____|_____');
  print('     |     |     ');
  print('  ${values[3]}  |  ${values[4]}  |  ${values[5]}  ');
  print('_____|_____|_____');
  print('  ${values[6]}  |  ${values[7]}  |  ${values[8]}  ');
  print('     |     |     ');
}

// Function to reset the game state after each round.
void resetGame() {
  values = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]; // Reset board values.
  winner = false; // Reset winner status.
  isxturn = true; // Set the turn to 'Player X' again.
  movecount = 0; // Reset the move counter.
}

// Function to check if a player has a winning combination.
bool check_combination(String combination, String check) {
  List<int> numbers = combination
      .split('')
      .map(int.parse)
      .toList(); // Convert the combination into a list of integers.
  return numbers.every((item) =>
      values[item] ==
      check); // Check if all items in the list are equal to 'check'(X or O).
}

// Function to check if there is a winner in the game.
check_Winner(String player) {
  for (final item in combinations) {
    if (check_combination(item, player)) {
      // Check if a player has a winning combination.
      print("Player $player, you are the winner!");
      winner = true;
      break; // Break out of the loop if a player has a winning combination.
    }
  }
}

// Function to handle player vs player mode.
void playTwoPlayerMode() {
  bool playAgain = true;
  // Loop to repeat the game if the player chooses to play again.
  while (playAgain) {
    resetGame();
    generateBoard(); // Display the initial board.
    while (!winner && movecount < 9) {
      // Continue the game until there's a winner or the move count reaches 9 (all spots are filled).
      print("Player ${isxturn ? 'X' : 'O'}'s turn");
      print("Enter a number between 1 to 9: ");
      String? input = stdin.readLineSync();
      if (input != null && int.tryParse(input) != null) {
        // If the input is not null and can be converted to an integer:
        int number = int.parse(input);
        if (number >=
                1 && // Check if the input is within the valid range (1-9) and the selected spot is not already taken.
            number <= 9 &&
            values[number - 1] != 'X' &&
            values[number - 1] != 'O') {
          values[number - 1] = isxturn
              ? 'X'
              : 'O'; // Update the board with the current player's symbol ('X' or 'O').
          isxturn = !isxturn;
          movecount++; // Increment the move count after a successful move.
          generateBoard(); // Display the updated board.
          check_Winner('X');
          check_Winner('O');
          if (movecount == 9 && !winner) {
            // If the board is full (9 moves) and no winner has been won yet, it's a tie.
            print("It's a tie!");
          }
        } else {
          print(
              "Invalid input, please choose an empty spot."); // Invalid move (spot already taken).
        }
      } else {
        print(
            "Invalid input, please enter a number between 1 and 9."); // Input is not a valid number.
      }
    }
    playAgain = askPlayAgain();
    if (playAgain) resetGame();
  }
}

// Function to handle player vs computer (easy mode that computer randomly picks moves).
void playEasyMode() {
  bool playAgain = true;

  // Loop to repeat the game if the player chooses to play again.
  while (playAgain) {
    generateBoard(); // Display the initial board.

    // Continue the game until there's a winner or the move count reaches 9 (all spots are filled).
    while (!winner && movecount < 9) {
      // If it is the player's (X) turn:
      if (isxturn) {
        print("Player ${isxturn ? 'X' : 'O'}'s turn");
        print("Enter a number between 1 to 9: ");
        String? input = stdin.readLineSync();

        if (input != null && int.tryParse(input) != null) {
          // If the input is not null and can be converted to an integer:
          int number = int.parse(input);

// Check if the input is within the valid range (1-9) and the selected spot is not already taken.
          if (number >= 1 &&
              number <= 9 &&
              values[number - 1] != 'X' &&
              values[number - 1] != 'O') {
            values[number - 1] =
                'X'; // Update the board with the current player's symbol ('X').

            isxturn = false; // Switch the turn to the computer (O).
            movecount++; // Increment the move count after a successful move.

            generateBoard(); // Display the updated board.
            check_Winner('X'); // Check if Player X has won.
          } else {
            print(
                "Invalid input, please choose an empty spot."); // Invalid move (spot already taken).
          }
        } else {
          print(
              "Invalid input, please enter a number between 1 and 9."); // Input is not a valid number.
        }

        // If it's the computer's (O) turn:
      } else {
        print("Computer's turn:");

        // Create a list of available spots on the board (those that are not occupied by 'X' or 'O').
        List<int> availableMoves = [];
        for (int i = 0; i < values.length; i++) {
          if (values[i] != 'X' && values[i] != 'O') {
            availableMoves
                .add(i); // Add the index of the empty spot to the list.
          }
        }

        // If there are available spots:
        if (availableMoves.isNotEmpty) {
          // The computer picks a random spot from the available moves.
          int randomMove =
              availableMoves[random.nextInt(availableMoves.length)];

          // Place 'O' in the chosen spot.
          values[randomMove] = 'O';
          print(
              "Computer choose position ${randomMove + 1}"); // Inform the player of the computer's choice.

          isxturn = true; // Switch the turn back to the player (X).
          movecount++; // Increment the move count after the computer's move.

          generateBoard(); // Display the updated board.
          check_Winner('O'); // Check if the computer (O) has won.
        }
      }

      // If all 9 moves are made and no winner, it's a tie.
      if (movecount == 9 && !winner) {
        print("It's a tie!");
      }
    }

    playAgain = askPlayAgain(); // Ask if the player wants to play again.
    if (playAgain) resetGame(); // If yes, reset the game to start again.
  }
}

// Function to handle player vs computer (hard mode that computer uses minimax algorithm to pick moves).
void playHardMode() {
  bool playAgain =
      true; // Loop to repeat the game if the player chooses to play again.

  while (playAgain) {
    generateBoard(); // Display the initial board.

    while (!winner && movecount < 9) {
      // Continue the game until there's a winner or the move count reaches 9 (all spots are filled).
      if (isxturn) {
        print("Player ${isxturn ? 'X' : 'O'}'s turn");
        print("Enter a number between 1 to 9: ");
        String? input = stdin.readLineSync();
        if (input != null && int.tryParse(input) != null) {
          // If the input is not null and can be converted to an integer:
          int number = int.parse(input);
          if (number >=
                  1 && // Check if the input is within the valid range (1-9) and the selected spot is not already taken.
              number <= 9 &&
              values[number - 1] != 'X' &&
              values[number - 1] != 'O') {
            values[number - 1] = 'X';
            isxturn = false;
            movecount++; // Increment the move count after a successful move.
            generateBoard(); // Display the updated board.
            check_Winner('X');
          } else {
            print("Invalid input, please choose an empty spot.");
          }
        } else {
          print("Invalid input, please enter a number between 1 and 9.");
        }
      } else {
        // Computer turn (Minimax)
        print("Computer's turn:");
        int bestMove = findBestMove(); // Find the best move for the computer.
        if (bestMove != -1) {
          // If a best move is found:
          values[bestMove] = 'O'; // Place 'O' in the chosen spot.
          print("Computer choose position ${bestMove + 1}");
          isxturn = true;
          movecount++; // Increment the move count after the computer's move.
          generateBoard(); // Display the updated board.
          check_Winner('O');
        }
      }

      if (movecount == 9 && !winner) {
        // If all 9 moves are made and no winner, it's a tie.
        print("It's a tie!");
      }
    }

    playAgain = askPlayAgain(); // Ask if the player wants to play again.
    if (playAgain) resetGame(); // If yes, reset the game to start again.
  }
}

int findBestMove() {
  // Find the best move for the computer.
  int bestValue =
      -1000; // Set to a very low number to ensure that any valid move will be better than this initial value that is initialized by negative number.
  int bestMove =
      -1; // Set to -1 as a default value for the best move found. It will be updated to the index of the best move if one is found.
  for (int i = 0; i < values.length; i++) {
    // Loop through all spots on the board.
    if (values[i] != 'X' && values[i] != 'O') {
      // If the spot is empty.
      values[i] = 'O'; // Make the move
      int moveValue = minimax(0, false); // Call minimax.
      values[i] = '${i + 1}'; // Undo the move.

      if (moveValue > bestValue) {
        // If the move value is better than the current best value.
        bestMove = i; // Store the index of this move.
        bestValue = moveValue; // Update the best value.
      }
    }
  }
  return bestMove; // Return the index of the best move.
}

// Minimax algorithm to find the best move for the computer.
int minimax(int depth, bool isMax) {
  // Computer is O , depth is the number of moves that have been made , ismax is the (true for 'O', the computer; false for 'X', the player).
  if (checkWin('O')) return 10 - depth; // Computer is O.
  if (checkWin('X')) return depth - 10; // Player is X.
  if (isBoardFull()) return 0; // Board is full (No winner its a tie).

  // If it's the maximizer's turn (the computer), try to maximize the score.
  if (isMax) {
    int best = -1000;
    for (int i = 0; i < values.length; i++) {
      if (values[i] != 'X' && values[i] != 'O') {
        values[i] = 'O';
        best = max(
            best,
            minimax(depth + 1,
                false)); //depth + 1: Increments the depth since one move has been made, false: means that it's now the player's turn.
        values[i] = '${i + 1}'; // Undo the move
      }
    }
    return best; // Return the best score.
  } else {
    int best =
        1000; // If it's the minimizer's turn (the player), try to minimize the score.
    for (int i = 0; i < values.length; i++) {
      if (values[i] != 'X' && values[i] != 'O') {
        values[i] = 'X';
        best = min(
            best,
            minimax(depth + 1,
                true)); //depth + 1: Increments the depth since one move has been made, true: means that it's now the computer's turn.
        values[i] = '${i + 1}'; // Undo the move
      }
    }
    return best; // Return the best score.
  }
}

// Check if a player has won
bool checkWin(String player) {
  // Check if a player has won.
  for (final item in combinations) {
    if (check_combination(item, player))
      return true; // Check if a player has a winning combination.
  }
  return false;
}

// Check if the board is full.
bool isBoardFull() {
  return values.every((val) =>
      val == 'X' ||
      val ==
          'O'); // Check if all spots on the board are occupied by 'X' or 'O'.
}

// Function to ask if the players want to play again after a game ends.
bool askPlayAgain() {
  print("Do you want to play again? (y/n)");
  String? answer = stdin.readLineSync();
  return answer != null && answer.toLowerCase() == 'y';
}

void main() {
  while (true) {
    print('Welcome to Tic Tac Toe!\n');
    print('Select a mode:\n');
    print('1. Two-player mode\n');
    print('2. Player vs Computer (Easy)\n');
    print('3. Player vs Computer (Hard)\n');
    print('4. Exit\n');
    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        resetGame();
        playTwoPlayerMode();
        break;
      case '2':
        resetGame();
        print("Player: X\nComputer: O");
        playEasyMode();
        break;
      case '3':
        resetGame();
        print("Player: X\nComputer: O");
        playHardMode();
        break;
      case '4':
        print('Exiting the game. Goodbye!');
        return;
      default:
        print('Invalid choice, please enter 1, 2, 3, or 4.');
    }

    if (!askPlayAgain()) {
      print('Thank you for playing Tic Tac Toe!');
      break;
    }
  }
}
