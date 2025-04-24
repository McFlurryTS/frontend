import 'package:McDonalds/game/sprites/trash_bins/recycle_bin.dart';
import 'package:flame/components.dart';

class OrganicBin extends RecycleBin {
  OrganicBin({required super.position})
    : super(size: Vector2(40, 49), spritePath: 'trash_bins/organic_bin.png');
}
