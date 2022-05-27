import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:odc_game/layout/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odc_game/shered/cacheHelper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  var snake = [
    [0, 1],
    [0, 0]
  ];
  var speed = 550;
  var food = [0, 2];
  var direction = 'up';
  var isPlaying = false;
  final int squaresPerRow = 20;
  final int squaresPerCol = 40;
  final fontStyle = const TextStyle(color: Colors.white, fontSize: 20);
  final randomGen = Random();

  void endGame(context) {
    isPlaying = false;
    if (snake.length - 2 > CacheHelper.getData(key: "score")) {
      CacheHelper.saveData(key: "score", value: snake.length - 2);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Score: ${snake.length - 2}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Highest Score : ${CacheHelper.getData(key: "score")}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    emit(EndGameState());
  }

  bool checkGameOver() {
    if (!isPlaying ||
        snake.first[1] < 0 ||
        snake.first[1] >= squaresPerCol ||
        snake.first[0] < 0 ||
        snake.first[0] > squaresPerRow) {
      emit(GameOverSate());
      return true;
    }

    for (var i = 1; i < snake.length; ++i) {
      if (snake[i][0] == snake.first[0] && snake[i][1] == snake.first[1]) {
        emit(SnakeBodyState());
        return true;
      }
    }

    return false;
  }

  void createFood(context) {
    incSpeed(context);
    food = [randomGen.nextInt(squaresPerRow), randomGen.nextInt(squaresPerCol)];
    emit(CreateFoodState());
  }

  void moveSnake(context) {
    emit(StartSnakeState());
    switch (direction) {
      case 'up':
        snake.insert(0, [snake.first[0], snake.first[1] - 1]);
        emit(MoveUpSnakeState());
        break;

      case 'down':
        snake.insert(0, [snake.first[0], snake.first[1] + 1]);
        emit(MoveDownSnakeState());

        break;

      case 'left':
        snake.insert(0, [snake.first[0] - 1, snake.first[1]]);
        emit(MoveLeftSnakeState());

        break;

      case 'right':
        snake.insert(0, [snake.first[0] + 1, snake.first[1]]);
        emit(MoveRightSnakeState());
        break;
    }

    if (snake.first[0] != food[0] || snake.first[1] != food[1]) {
      snake.removeLast();
      emit(SnakeBodyState());
    } else {
      createFood(context);
    }
  }

  void incSpeed(context) {
    emit(IncSpeedState());
    emit(StartSnakeState());
    emit(SnakeBodyState());
    if (speed >= 20) {
      speed -= 20;
    }
    Timer.periodic(Duration(milliseconds: speed), (Timer timer) {
      moveSnake(context);
    });
  }

  void start(context) {
    if (isPlaying) {
      isPlaying = false;
    } else {
      startGame(context);
    }
    emit(StartState());
  }

  void startGame(context) {
    emit(StartSnakeState());
    snake = [
      [(squaresPerRow / 2).floor(), (squaresPerCol / 2).floor()]
    ];

    snake.add([snake.first[0], snake.first[1] + 1]);

    createFood(context);
    isPlaying = true;
    Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      emit(StartSnakeState());
      emit(StartState());
      moveSnake(context);
      if (checkGameOver()) {
        timer.cancel();
        endGame(
          context,
        );
      }
    });
  }
}
