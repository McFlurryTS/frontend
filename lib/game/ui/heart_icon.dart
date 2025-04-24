import 'dart:async';

import 'package:flame/components.dart';

enum HeartState { full, empty }

class HeartIcon extends SpriteGroupComponent<HeartState> with HasGameRef {
  HeartIcon({required Vector2 position, required HeartState state})
    : super(position: position, size: Vector2(40, 40), current: state);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Ensure sprites are loaded before the component is used
    sprites = {
      HeartState.full: await gameRef.loadSprite('game_hud/heart.png'),
      HeartState.empty: await gameRef.loadSprite('game_hud/heart_empty.png'),
    };
  }
}
