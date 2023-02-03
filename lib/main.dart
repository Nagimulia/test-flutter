import 'package:flutter/material.dart';
import 'package:tic_game/ui/theme/color.dart';
import 'package:tic_game/utils/game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0; // to check the draw
  String result = "";
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];

  Game game = Game();

  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Сейчас ${lastValue} ходит".toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 44,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: boardWidth,
              width: boardWidth,
              child: GridView.count(
                  crossAxisCount: Game.boardlenth ~/ 3,
                  padding: EdgeInsets.all(16.0),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  children: List.generate(Game.boardlenth, (index) {
                    return InkWell(
                      onTap: gameOver
                          ? null
                          : () {
                              //when we click we need to add the new value to the board and refrech the screen
                              //we need also to toggle the player
                              //now we need to apply the click only if the field is empty
                              //now let's create a button to repeat the game

                              if (game.board![index] == "") {
                                setState(() {
                                  game.board![index] = lastValue;
                                  turn++;
                                  gameOver = game.winnerCheck(
                                      lastValue, index, scoreboard, 3);

                                  if (gameOver) {
                                    result = "$lastValue is the Winner";
                                  } else if (!gameOver && turn == 9) {
                                    result = "It's a Draw!";
                                    gameOver = true;
                                  }
                                  if (lastValue == "X")
                                    lastValue = "O";
                                  else
                                    lastValue = "X";
                                });
                              }
                            },
                      child: Container(
                        width: Game.blocSize,
                        height: Game.blocSize,
                        decoration: BoxDecoration(
                          color: MainColor.secondaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: Text(
                            game.board![index],
                            style: TextStyle(
                              color: game.board![index] == "X"
                                  ? Colors.blue
                                  : Colors.pink,
                              fontSize: 64.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  //erase the board
                  game.board = Game.initGameBoard();
                  lastValue = "X";
                  gameOver = false;
                  turn = 0;
                  result = "";
                  scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                });
              },
              icon: Icon(Icons.replay),
              label: Text("Ещё одна игра!"),
            ),
          ],
        ));
  }
}
