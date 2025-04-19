// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      category: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      image: fields[4] as String,
      url: fields[5] as String,
      country: fields[6] as String,
      active: fields[7] as bool,
      updatedAt: fields[8] as DateTime,
      price: fields[9] as double,
      allergens: (fields[10] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.country)
      ..writeByte(7)
      ..write(obj.active)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.allergens);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
