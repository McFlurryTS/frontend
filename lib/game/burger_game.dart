import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:demo/game/world/game_world.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BurgerGame extends FlameGame {
  late GameWorld gameWorld;

  @override
  Future<void> onLoad() async {
    // Add your game initialization logic here
    super.onLoad();

    await Flame.device.setOrientation(DeviceOrientation.portraitUp);
    
    gameWorld = GameWorld();
    await add(gameWorld);
    await gameWorld.loaded;

    this.camera = CameraComponent(world: gameWorld)
      ..viewfinder.anchor = Anchor.center;
    this.camera.follow(gameWorld.player);

    final joystick = JoystickComponent(
      knob: CircleComponent(radius: 15, paint: Paint()..color = const Color(0x77DDDDDD)),
      background: CircleComponent(radius: 50, paint: Paint()..color = const Color(0x77CCCCCC)),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );
    add(joystick);

    gameWorld.player.joystick = joystick;
  }
}
