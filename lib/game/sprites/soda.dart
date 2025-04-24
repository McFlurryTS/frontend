import 'package:flame/components.dart';
import 'item.dart';

class Soda extends Item {
  Soda({required super.position}) : super(size: Vector2(52, 96));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('soda.png'); // Load soda sprite
  }
}
