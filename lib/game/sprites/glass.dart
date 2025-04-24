import 'package:flame/components.dart';
import 'item.dart';

<<<<<<< HEAD:lib/game/sprites/ice_cream.dart
class IceCream extends Item {
  IceCream({required super.position, required super.size});
=======
class Glass extends Item {
  Glass({required Vector2 position, required Vector2 size})
    : super(position: position, size: size);
>>>>>>> 687194d6fdd625c0a2c26e77dd4b34ceb4f2c11f:lib/game/sprites/glass.dart

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('glass.png'); // Load glass sprite
  }
}
