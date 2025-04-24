import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:McDonalds/game/sprites/item.dart';

enum Score { player, steve, trex }

class Player extends SpriteGroupComponent
    with HasGameRef<FlameGame>, CollisionCallbacks {
  JoystickComponent? joystick;
  Item? closestItem;
  double speed = 5;
  double detectionRadius = 64;

  Player() : super(size: Vector2(30, 54));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprites = {
      Score.player: await gameRef.loadSprite('player.png'),
      Score.steve: await gameRef.loadSprite('steve.png'),
      Score.trex: await gameRef.loadSprite('trex.png'),
    };
    current = Score.player;
    size = Vector2(30, 54);
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

  void setSprite(int score) {
    if (score == 0) {
      current = Score.player;
    } else if (score == 3) {
      current = Score.steve;
    } else if (score == 6) {
      current = Score.trex;
    } else {
      current = Score.player; // Default to player sprite for invalid scores
    }
  }
}
