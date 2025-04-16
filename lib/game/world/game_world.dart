import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:demo/game/sprites/player_character.dart';

class GameWorld extends World {
  late Player player;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    add(RectangleComponent(size: Vector2(50, 50)));

    player = Player();
    add(player);

    player.position = Vector2(100, 100);
  }
}
