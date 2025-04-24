import 'package:McDonalds/game/sprites/player_character.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:McDonalds/game/world/game_world.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:McDonalds/game/ui/score_text.dart';
import 'package:McDonalds/game/ui/health_bar.dart';
import 'package:McDonalds/game/ui/icon_overlay.dart';
import 'package:flame/events.dart';

class BurgerGame extends FlameGame with HasCollisionDetection {
  static final ValueNotifier<bool> showResetButtonNotifier = ValueNotifier(
    false,
  );
  static BurgerGame? instance;

  // Callback para verificar la iteración
  final Future<void> Function(BuildContext)? onIterationCheck;
  // Contexto para el callback
  final BuildContext context;

  BurgerGame({required this.context, this.onIterationCheck}) {
    instance = this;
  }

  late World gameWorld;
  late Player player;
  int score = 0;
  int health = 3;
  late HealthBar healthBar;
  late ButtonComponent? resetButton;
  Vector2 playerPosition = Vector2(512, 512);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await Flame.device.setOrientation(DeviceOrientation.portraitUp);

    gameWorld = GameWorld();
    await add(gameWorld);
    await gameWorld.loaded;

    player = Player();
    add(player);
    player.position = playerPosition;
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
    joystick.add(IconOverlay(asset: 'game_hud/dpad.png'));
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
    button.add(IconOverlay(asset: 'game_hud/grab.png'));
    camera.viewport.add(button);

    player.joystick = joystick;
    healthBar = HealthBar();
    camera.viewport.add(ScoreText());
    camera.viewport.add(healthBar);
  }

  void decreaseHealth() {
    if (health > 0) {
      health -= 1;
      healthBar.updateHealth(health);
    }
    if (health == 0) {
      player.speed = 0;
      showResetButtonNotifier.value = true;
    }
  }

  void reset() async {
    score = 0;
    player.setSprite(0);
    player.speed = 5;
    health = 3;
    healthBar.updateHealth(3);
    showResetButtonNotifier.value = false;
    player.position = playerPosition;
  }

  void increaseScore() {
    score += 1;

    // Map score to valid values for setSprite
    if (score >= 6) {
      player.setSprite(6);
    } else if (score >= 3) {
      player.setSprite(3);
    } else {
      player.setSprite(0);
    }
  }

  Future<void> checkIteration() async {
    if (onIterationCheck != null) {
      await onIterationCheck!(context);
    }
  }
}
