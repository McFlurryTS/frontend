import 'package:flame/components.dart';
import 'item.dart';

class IceCream extends Item {
  IceCream({required Vector2 position, required Vector2 size})
    : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('mcflurry.png'); // Load ice-cream sprite
  }
}
