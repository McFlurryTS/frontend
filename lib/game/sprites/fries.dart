import 'package:flame/components.dart';
import 'item.dart';

class Fries extends Item {
  Fries({required Vector2 position})
    : super(position: position, size: Vector2(28, 40));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('fries.png'); // Load fries sprite
  }
}
