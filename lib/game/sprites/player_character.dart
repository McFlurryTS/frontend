import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:McDonalds/game/sprites/item.dart';

class Player extends SpriteComponent
    with HasGameRef<FlameGame>, CollisionCallbacks {
  JoystickComponent? joystick;
  Item? closestItem;
  double speed = 3;
  double detectionRadius = 64;

  Player() : super(size: Vector2(30, 54));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('player.png');
    size = Vector2(30, 54);
    position = gameRef.size / 2 - size / 2;
    add(RectangleHitbox(size: size));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Add player-specific logic here (e.g., movement)
    if (closestItem != null &&
        position.distanceTo(closestItem!.position) > detectionRadius) {
      closestItem = null;
    }
    if (joystick != null) {
      position.add(
        joystick!.delta * dt * speed,
      ); // Move the player based on joystick input
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Item) {
      double distance = position.distanceTo(other.position);
      if (distance <= detectionRadius) {
        if (closestItem == null ||
            distance < position.distanceTo(closestItem!.position)) {
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
