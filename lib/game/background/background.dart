import 'dart:async';

import 'package:flame/components.dart';

class Background extends SpriteComponent with HasGameRef {
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('beach.gif');
    size = Vector2(3072, 1408);
  }
}
