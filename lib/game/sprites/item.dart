import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';

class Item extends SpriteComponent
    with HasGameRef<FlameGame>, CollisionCallbacks {
  bool isCarried = false;
  PositionComponent? carrier;

  Item({required Vector2 position, required Vector2 size})
    : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox(size: size));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isCarried && carrier != null) {
      position = carrier!.position + Vector2(-10, 20); // Follow the carrier
    }
  }

  void pickUp(PositionComponent newCarrier) {
    isCarried = true;
    carrier = newCarrier;
    position = carrier!.position + Vector2(0, 20);
  }

  void drop() {
    if (isCarried) {
      isCarried = false;
      carrier = null;
    }
  }
}
