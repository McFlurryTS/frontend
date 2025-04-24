import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:McDonalds/game/burger_game.dart';

class GameScreen extends StatelessWidget {
  final TabController tabController;
  final ValueNotifier<int> currentIndexNotifier;

  const GameScreen({
    super.key,
    required this.tabController,
    required this.currentIndexNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: GameWidget(game: BurgerGame(context: context))),
    );
  }
}
