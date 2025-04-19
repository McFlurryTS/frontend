import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:demo/game/sprites/burger.dart';
import 'package:demo/game/sprites/fries.dart';
import 'package:demo/game/sprites/soda.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:demo/game/sprites/player_character.dart';

class GameWorld extends World {
  late Player player;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    

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

    player = Player();
    add(player);

    player.position = Vector2(0, 0);
  }
}
