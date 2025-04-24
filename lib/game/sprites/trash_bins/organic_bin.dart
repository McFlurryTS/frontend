import 'package:McDonalds/game/sprites/item.dart';
import 'package:McDonalds/game/sprites/trash_bins/recycle_bin.dart';
import 'package:McDonalds/game/sprites/organic.dart';
import 'package:McDonalds/game/burger_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class OrganicBin extends RecycleBin {
<<<<<<< HEAD
  OrganicBin({required super.position})
    : super(size: Vector2(40, 49), spritePath: 'trash_bins/organic_bin.png');
=======
  OrganicBin({required Vector2 position})
    : super(
        position: position,
        size: Vector2(40, 49),
        spritePath: 'trash_bins/organic_bin.png',
      );

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Organic) {
      other.removeFromParent();
      (gameRef as BurgerGame).increaseScore();
    } else if (other is Item) {
      other.removeFromParent();
      (gameRef as BurgerGame).decreaseHealth();
    }
  }
>>>>>>> 687194d6fdd625c0a2c26e77dd4b34ceb4f2c11f
}
