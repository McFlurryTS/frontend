import 'package:McDonalds/game/sprites/trash_bins/recycle_bin.dart';
import 'package:flame/components.dart';

class GlassBin extends RecycleBin {
  GlassBin({required super.position})
    : super(size: Vector2(40, 49), spritePath: 'trash_bins/glass_bin.png');
}
