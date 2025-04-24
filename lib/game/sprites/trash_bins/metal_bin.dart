import 'package:McDonalds/game/sprites/trash_bins/recycle_bin.dart';
import 'package:flame/components.dart';

class MetalBin extends RecycleBin {
  MetalBin({required super.position})
    : super(size: Vector2(40, 49), spritePath: 'trash_bins/metal_bin.png');
}
