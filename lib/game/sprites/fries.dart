import 'package:flame/components.dart';
import 'item.dart';

class Fries extends Item {
  Fries({required super.position}) : super(size: Vector2(28, 40));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('fries.png'); // Load fries sprite
  }
}
