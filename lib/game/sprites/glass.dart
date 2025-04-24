import 'package:flame/components.dart';
import 'item.dart';

class Glass extends Item {
  Glass({required super.position, required super.size});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('glass.png'); // Load glass sprite
  }
}
