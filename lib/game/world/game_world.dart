import 'dart:async';
import 'dart:math';
import 'package:McDonalds/game/sprites/organic.dart';
import 'package:McDonalds/game/sprites/plastic.dart';
import 'package:McDonalds/game/sprites/metal.dart';
import 'package:McDonalds/game/background/background.dart';
import 'package:McDonalds/game/sprites/trash_bins/glass_bin.dart';
import 'package:McDonalds/game/sprites/trash_bins/metal_bin.dart';
import 'package:McDonalds/game/sprites/trash_bins/organic_bin.dart';
import 'package:McDonalds/game/sprites/trash_bins/plastic_bin.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class GameWorld extends World {
  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    add(Background());

    add(MetalBin(position: Vector2(615, 300)));
    add(PlasticBin(position: Vector2(735, 300)));
    add(GlassBin(position: Vector2(855, 300)));
    add(OrganicBin(position: Vector2(975, 300)));
    final random = Random();
    for (int i = 0; i < 10; i++) {
      add(
        Organic(
          position: Vector2(
            random.nextDouble() * 372,
            random.nextDouble() * 148,
          ),
        ),
      );
      add(
        Metal(
          position: Vector2(
            random.nextDouble() * 372,
            random.nextDouble() * 148,
          ),
        ),
      );
    }
  }
}
