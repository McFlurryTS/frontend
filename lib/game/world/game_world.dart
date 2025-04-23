import 'dart:async';
import 'dart:math';
import 'package:McDonalds/game/sprites/burger.dart';
import 'package:McDonalds/game/sprites/fries.dart';
import 'package:McDonalds/game/sprites/soda.dart';
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
    add(PlasticBin(position: Vector2(1230, 300)));
    add(GlassBin(position: Vector2(1845, 300)));
    add(OrganicBin(position: Vector2(2460, 300)));

    spawnItems();
  }

  void spawnItems() {
    final random = Random();

    add(
      Burger(
        position: Vector2(
          random.nextDouble() * 3072,
          random.nextDouble() * 1408,
        ),
      ),
    );
    add(
      Soda(
        position: Vector2(
          random.nextDouble() * 3072,
          random.nextDouble() * 1408,
        ),
      ),
    );
    add(
      Fries(
        position: Vector2(
          random.nextDouble() * 3072,
          random.nextDouble() * 1408,
        ),
      ),
    );
  }
}
