import 'package:flame/components.dart';

class IconOverlay extends SpriteComponent with HasGameRef {
  late String asset;

  IconOverlay({required this.asset})
    : super(position: Vector2(0, 0), size: Vector2(100, 100));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite(asset);
  }
}
