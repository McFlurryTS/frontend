import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:demo/game/sprites/item.dart';

class Player extends SpriteComponent
    with HasGameRef<FlameGame>, CollisionCallbacks {
  JoystickComponent? joystick;
  Item? closestItem;
  Player() : super(size: Vector2(64, 64)); // Set the size of the player

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('player.png');
    size = Vector2(8, 32);
    position = gameRef.size / 2 - size / 2;
    add(RectangleHitbox(size: size));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Add player-specific logic here (e.g., movement)

    if (joystick != null) {
      position.add(
        joystick!.delta * dt * 2,
      ); // Move the player based on joystick input
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Item) {
      const double detectionRadius = 64;
      double closestDistance = double.infinity;
      double distance = position.distanceTo(other.position);
      if (distance <= detectionRadius) {
        if (closestItem == null || distance < position.distanceTo(closestItem!.position)) {
          closestItem = other;
        }
      }
    }
  }

  void interactWithClosestItem() {
    if (closestItem != null) {
      interact(closestItem!);
    }
  }

  void interact(Item item) {
    if (!item.isCarried) {
      item.pickUp(this);
    } else {
      item.drop();
    }
  }
}
