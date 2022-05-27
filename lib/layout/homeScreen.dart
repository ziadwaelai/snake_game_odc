import 'package:flutter/material.dart';
import 'package:odc_game/layout/cubit/cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (cubit.direction != 'up' && details.delta.dy > 0) {
                  cubit.direction = 'down';
                } else if (cubit.direction != 'down' && details.delta.dy < 0) {
                  cubit.direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (cubit.direction != 'left' && details.delta.dx > 0) {
                  cubit.direction = 'right';
                } else if (cubit.direction != 'right' && details.delta.dx < 0) {
                  cubit.direction = 'left';
                }
              },
              child: AspectRatio(
                aspectRatio: cubit.squaresPerRow / (cubit.squaresPerCol + 5),
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cubit.squaresPerRow,
                    ),
                    itemCount: cubit.squaresPerRow * cubit.squaresPerCol,
                    itemBuilder: (BuildContext context, int index) {
                      dynamic color;
                      var x = index % cubit.squaresPerRow;
                      var y = (index / cubit.squaresPerRow).floor();
                      bool isSnakeBody = false;
                      for (var pos in cubit.snake) {
                        if (pos[0] == x && pos[1] == y) {
                          isSnakeBody = true;
                          break;
                        }
                      }

                      if (cubit.snake.first[0] == x &&
                          cubit.snake.first[1] == y) {
                        color = Colors.green;
                      } else if (isSnakeBody) {
                        color = Colors.green[200];
                      } else if (cubit.food[0] == x && cubit.food[1] == y) {
                        color = Colors.red;
                      } else {
                        color = Colors.grey[800];
                      }

                      return Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          cubit.isPlaying ? Colors.red : Colors.blue,
                        ),
                      ),
                      child: Text(
                        cubit.isPlaying ? 'End' : 'Start',
                        style: cubit.fontStyle,
                      ),
                      onPressed: () {
                        setState(() {
                          cubit.speed = 500;
                        });
                        cubit.start(context);
                      }),
                  Text(
                    'Score: ${cubit.snake.length - 2}',
                    style: cubit.fontStyle,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
