import 'package:demo/game/sprites/trash_bins/recycle_bin.dart';
import 'package:flame/components.dart';

class OrganicBin extends RecycleBin {
  OrganicBin({required Vector2 position})
    : super(
        position: position,
        size: Vector2(40, 49),
        spritePath: 'trash_bins/organic_bin.png',
      );
}
