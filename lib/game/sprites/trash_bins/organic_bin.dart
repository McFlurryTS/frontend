import 'package:McDonalds/game/sprites/trash_bins/recycle_bin.dart';
import 'package:McDonalds/game/sprites/organic.dart';
import 'package:McDonalds/game/burger_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class OrganicBin extends RecycleBin {
  OrganicBin({required Vector2 position})
    : super(
        position: position,
        size: Vector2(40, 49),
        spritePath: 'trash_bins/organic_bin.png',
      );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Organic) {
      // Handle collision with Organic item
      other.removeFromParent(); // Destroy the Organic item
      (gameRef as BurgerGame).increaseScore(); // Increase the score in the game
    }
  }
}
