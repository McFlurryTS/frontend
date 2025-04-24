import 'dart:math';
import 'package:flame/components.dart';
import 'item.dart';

class Organic extends Item {
  Organic({required super.position}) : super(size: Vector2(17, 22));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    var rng = Random();
    var type = rng.nextInt(3);
    switch (type) {
      case 0:
        sprite = await gameRef.loadSprite('trash_sprites/banana.png');
        break;
      case 1:
        sprite = await gameRef.loadSprite('trash_sprites/apple.png');
        break;
      case 2:
        sprite = await gameRef.loadSprite('trash_sprites/fish.png');
        break;
      default:
        sprite = await gameRef.loadSprite('trash_sprites/banana.png');
        break;
    }
  }
}
