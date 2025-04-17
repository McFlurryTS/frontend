import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:demo/game/burger_game.dart';

class GameScreen extends StatelessWidget {
  final TabController tabController; // Recibe el TabController
  final ValueNotifier<int>
  currentIndexNotifier; // Recibe el notificador del índice

  const GameScreen({
    super.key,
    required this.tabController,
    required this.currentIndexNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GameWidget(
          game: BurgerGame(), // Embed the FlameGame here
        ),
      ),
    );
  }
}
