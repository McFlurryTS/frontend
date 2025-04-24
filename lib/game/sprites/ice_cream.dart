import 'package:flame/components.dart';
import 'item.dart';

class IceCream extends Item {
  IceCream({required super.position, required super.size});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('mcflurry.png'); // Load ice-cream sprite
  }
}
