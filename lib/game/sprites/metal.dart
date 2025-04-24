import 'dart:ui';

import 'package:flame/components.dart';
import 'dart:math';
import 'item.dart';

class Metal extends Item {
  Metal({required super.position})
    : super(size: Vector2(20, 32));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    var rng = Random();
    var type = rng.nextInt(3);
    switch (type) {
      case 0:
        sprite = await gameRef.loadSprite('trash_sprites/tuna_can.png');
        break;
      case 1:
        sprite = await gameRef.loadSprite('trash_sprites/bent_can.png');
        break;
      case 2:
        sprite = await gameRef.loadSprite('trash_sprites/soda_can.png');
        break;
      default:
        sprite = await gameRef.loadSprite('trash_sprites/tuna_can.png');
        break;
    }
  }
}
