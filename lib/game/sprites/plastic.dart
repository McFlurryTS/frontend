import 'package:flame/components.dart';
import 'item.dart';

class Plastic extends Item {
  Plastic({required super.position})
    : super(size: Vector2(28, 40));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('plastic.png'); // Load plastic sprite
  }
}
