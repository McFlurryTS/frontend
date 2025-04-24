import 'package:McDonalds/game/sprites/player_character.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:McDonalds/game/world/game_world.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:McDonalds/game/ui/score_text.dart';

class BurgerGame extends FlameGame with HasCollisionDetection {
  late GameWorld gameWorld;
  late Player player;
  int score = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await Flame.device.setOrientation(DeviceOrientation.portraitUp);

    gameWorld = GameWorld();
    await add(gameWorld);
    await gameWorld.loaded;

    player = Player();
    add(player);
    player.position = Vector2(256, 256);
    gameWorld.add(player);

    camera = CameraComponent(world: gameWorld)
      ..viewfinder.anchor = Anchor.center;
    camera.follow(player);

    final joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 15,
        paint: Paint()..color = const Color(0x77CCCCCC),
      ),
      background: CircleComponent(
        radius: 50,
        paint: Paint()..color = const Color.fromARGB(119, 188, 183, 183),
        priority: 10,
      ),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );
    camera.viewport.add(joystick);

    final button = HudButtonComponent(
      button: CircleComponent(
        radius: 50,
        paint: Paint()..color = const Color.fromARGB(119, 188, 183, 183),
      ),
      margin: const EdgeInsets.only(right: 20, bottom: 20),
      onPressed: () {
        player.interactWithClosestItem();
      },
    );
    camera.viewport.add(button);

    player.joystick = joystick;

    final scoreText = ScoreText();
    camera.viewport.add(scoreText);
  }

  void increaseScore() {
    score += 1;
  }
}
