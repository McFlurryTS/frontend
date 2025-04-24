import 'dart:async';

import 'package:flame/components.dart';

enum HeartIconType { heart, heart_empty }

class HeartIcon extends SpriteGroupComponent<HeartIconType> with HasGameRef {
  HeartIcon({required Vector2 position})
    : super(position: position, size: Vector2(40, 40));

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    sprites = {
      HeartIconType.heart: await gameRef.loadSprite('game_hud/heart.png'),
      HeartIconType.heart_empty: await gameRef.loadSprite(
        'game_hud/heart_empty.png',
      ),
    };

    current = HeartIconType.heart;
  }
}
