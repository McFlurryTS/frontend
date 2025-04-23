import 'dart:async';
import 'dart:math';
import 'package:demo/game/sprites/burger.dart';
import 'package:demo/game/sprites/fries.dart';
import 'package:demo/game/sprites/soda.dart';
import 'package:demo/game/background/background.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class GameWorld extends World {

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    add(Background());

    add(
      Burger(
        position: Vector2(
          Random().nextDouble() * 320,
          Random().nextDouble() * 320,
        ),
      ),
    );
    add(
      Soda(
        position: Vector2(
          Random().nextDouble() * 320,
          Random().nextDouble() * 320,
        ),
      ),
    );
    add(
      Fries(
        position: Vector2(
          Random().nextDouble() * 320,
          Random().nextDouble() * 320,
        ),
      ),
    );
  }
}
