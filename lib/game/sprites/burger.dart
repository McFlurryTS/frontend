import 'package:flame/components.dart';
import 'item.dart';

class Burger extends Item {
  Burger({required Vector2 position})
    : super(position: position, size: Vector2(48, 48));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('burger.png'); // Load burger sprite
  }
}
