import 'package:flame/components.dart';
import 'item.dart';

class Glass extends Item {
  Glass({required Vector2 position, required Vector2 size})
    : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('glass.png'); // Load glass sprite
  }
}
