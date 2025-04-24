
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';

class RecycleBin extends SpriteComponent
    with HasGameRef<FlameGame>, CollisionCallbacks {
  RecycleBin({
    required Vector2 position,
    required Vector2 size,
    required String spritePath,
  }) : super(position: position, size: size) {
    _spritePath = spritePath;
  }

  late final String _spritePath;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite(_spritePath);
    add(RectangleHitbox(size: size));
  }
}
