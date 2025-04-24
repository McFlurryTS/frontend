import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:McDonalds/game/burger_game.dart';

class ScoreText extends TextComponent with HasGameRef {
  ScoreText() : super(priority: 20);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(
      20,
      20,
    ); // Position the score text on the top-left corner
    text = 'Puntuación: 0';
    textRenderer = TextPaint(
      style: const TextStyle(fontSize: 24, color: Colors.white),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    text =
        'Puntuación: ${(gameRef as BurgerGame).score}'; // Update the score text
  }
}
