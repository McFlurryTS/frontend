import 'package:flame/components.dart';
import 'item.dart';

<<<<<<< HEAD:lib/game/sprites/fries.dart
class Fries extends Item {
  Fries({required super.position}) : super(size: Vector2(28, 40));
=======
class Plastic extends Item {
  Plastic({required Vector2 position})
    : super(position: position, size: Vector2(28, 40));
>>>>>>> 687194d6fdd625c0a2c26e77dd4b34ceb4f2c11f:lib/game/sprites/plastic.dart

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('plastic.png'); // Load plastic sprite
  }
}
