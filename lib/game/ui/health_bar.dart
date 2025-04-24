import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../burger_game.dart';
import 'package:McDonalds/game/ui/heart_icon.dart';

class HealthBar extends PositionComponent with HasGameRef<BurgerGame> {
  final List<HeartIcon> hearts = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Initialize the health bar based on the health variable in BurgerGame
    for (int i = 0; i < gameRef.health; i++) {
      final heart = HeartIcon(position: Vector2(20 + i * 40, 20));
      hearts.add(heart);
      add(heart);
    }
  }

  void updateHealth(int newHealth) {
    // Update the health bar when the health variable changes
    while (hearts.length > newHealth) {
      hearts.removeLast().removeFromParent();
    }
    while (hearts.length < newHealth) {
      final heart = HeartIcon(position: Vector2(20 + hearts.length * 40, 20));
      hearts.add(heart);
      add(heart);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Sync the health bar with the health variable in BurgerGame
    updateHealth(gameRef.health);
  }
}
