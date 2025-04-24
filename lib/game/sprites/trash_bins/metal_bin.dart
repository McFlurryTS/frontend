import 'package:McDonalds/game/burger_game.dart';
import 'package:McDonalds/game/sprites/item.dart';
import 'package:McDonalds/game/sprites/metal.dart';
import 'package:McDonalds/game/sprites/trash_bins/recycle_bin.dart';
import 'package:flame/components.dart';

class MetalBin extends RecycleBin {
  MetalBin({required Vector2 position})
    : super(
        position: position,
        size: Vector2(40, 49),
        spritePath: 'trash_bins/metal_bin.png',
      );

  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Metal) {
      other.removeFromParent();
      (gameRef as BurgerGame).increaseScore();
    }
    else if (other is Item) {
      other.removeFromParent();
      (gameRef as BurgerGame).decreaseHealth();
    }
  }
}
