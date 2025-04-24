import 'package:flame/components.dart';
import 'item.dart';

class Plastic extends Item {
  Plastic({required Vector2 position})
    : super(position: position, size: Vector2(28, 40));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('plastic.png'); // Load plastic sprite
  }
}
