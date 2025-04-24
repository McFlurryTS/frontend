import 'package:McDonalds/game/sprites/item.dart';
import 'package:McDonalds/game/sprites/trash_bins/recycle_bin.dart';
import 'package:McDonalds/game/sprites/organic.dart';
import 'package:McDonalds/game/burger_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class OrganicBin extends RecycleBin {
  OrganicBin({required super.position})
    : super(
        size: Vector2(40, 49),
        spritePath: 'trash_bins/organic_bin.png',
      );

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
<<<<<<< HEAD
=======
    print('collision with $other');
>>>>>>> ccaa84c68643bde1c4d9e703bb600912ed0dac39
    if (other is Organic) {
      other.removeFromParent();
      (gameRef as BurgerGame).increaseScore();
    } else if (other is Item) {
      other.removeFromParent();
      (gameRef as BurgerGame).decreaseHealth();
    }
  }
}
