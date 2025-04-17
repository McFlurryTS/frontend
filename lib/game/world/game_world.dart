import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:demo/game/sprites/player_character.dart';
import 'package:demo/game/sprites/item.dart';

class GameWorld extends World {
  late Player player;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    for (int i = 0; i < 10; i++) {
      add(Item(position: Vector2.random() * 64.0, size: Vector2(48, 48)));
    }

    player = Player();
    add(player);

    player.position = Vector2(100, 100);
  }
}
