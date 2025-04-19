import 'package:hive_flutter/hive_flutter.dart';
import 'package:McDonalds/models/survey_model.dart';

class SurveyAdapter extends TypeAdapter<Survey> {
  @override
  final int typeId = 2;

  @override
  Survey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Survey(
      favoriteProducts: (fields[0] as List).cast<String>(),
      favoriteDessert: fields[1] as String,
      preferredGift: fields[2] as String,
      purchaseFor: (fields[3] as List).cast<String>(),
      favoriteFlavors: (fields[4] as List).cast<String>(),
      visitObstacle: fields[5] as String,
      preferredSurprises: (fields[6] as List).cast<String>(),
      preferredSide: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Survey obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.favoriteProducts)
      ..writeByte(1)
      ..write(obj.favoriteDessert)
      ..writeByte(2)
      ..write(obj.preferredGift)
      ..writeByte(3)
      ..write(obj.purchaseFor)
      ..writeByte(4)
      ..write(obj.favoriteFlavors)
      ..writeByte(5)
      ..write(obj.visitObstacle)
      ..writeByte(6)
      ..write(obj.preferredSurprises)
      ..writeByte(7)
      ..write(obj.preferredSide);
  }
}
