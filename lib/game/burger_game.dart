import 'package:McDonalds/game/sprites/player_character.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:McDonalds/game/world/game_world.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BurgerGame extends FlameGame with HasCollisionDetection {
  late GameWorld gameWorld;
  late Player player;
  final Function(BuildContext)? onIterationCheck;
  final BuildContext context;

  BurgerGame({required this.context, this.onIterationCheck});

  @override
  Future<void> onLoad() async {
    // Add your game initialization logic here
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
        paint: Paint()..color = const Color(0x77DDDDDD),
      ),
      background: CircleComponent(
        radius: 50,
        paint: Paint()..color = const Color(0x77CCCCCC),
        priority: 10,
      ),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );
    camera.viewport.add(joystick);

    final button = HudButtonComponent(
      button: CircleComponent(
        radius: 50,
        paint: Paint()..color = const Color(0x77DDDDDD),
      ),
      margin: const EdgeInsets.only(right: 20, bottom: 20),
      onPressed: () {
        player.interactWithClosestItem();
      },
    );
    camera.viewport.add(button);

    player.joystick = joystick;
  }

  Future<void> checkIteration() async {
    if (onIterationCheck != null) {
      await onIterationCheck!(context);
    }
  }
}
