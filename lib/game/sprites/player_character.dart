import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Player extends SpriteComponent with HasGameRef<FlameGame> {
  JoystickComponent? joystick;
  Player() : super(size: Vector2(64, 64)); // Set the size of the player

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('player.png'); // Load the player sprite
    position = gameRef.size / 2 - size / 2; // Center the player on the screen
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Add player-specific logic here (e.g., movement)

    if (joystick != null) {
      position.add(joystick!.delta * dt * 2); // Move the player based on joystick input
    }
  }
}
