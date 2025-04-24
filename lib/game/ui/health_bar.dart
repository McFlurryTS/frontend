import 'package:flame/components.dart';
import 'package:flame/game.dart';
import '../burger_game.dart';
import 'package:McDonalds/game/ui/heart_icon.dart';

class HealthBar extends PositionComponent with HasGameRef<BurgerGame> {
  final List<HeartIcon> hearts = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Initialize the health bar based on the health variable in BurgerGame
    for (int i = 0; i < gameRef.health; i++) {
      final heart = HeartIcon(
        position: Vector2(20 + i * 40, 20),
        state: HeartState.full,
      );
      add(heart); // Add the heart to the game tree first
      hearts.add(heart);
    }

    // Ensure all hearts are loaded after being added to the game tree
    await Future.wait(hearts.map((heart) async => heart.onLoad()));
  }

  void updateHealth(int newHealth) {
    // Update the health bar when the health variable changes
    if (newHealth < 3) {
      hearts[newHealth].current = HeartState.empty;
    } else if (newHealth == 3) {
      for (int i = 0; i < hearts.length; i++) {
        hearts[i].current = HeartState.full;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Sync the health bar with the health variable in BurgerGame
    updateHealth(gameRef.health);
  }
}
