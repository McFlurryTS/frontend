// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_form.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnboardingFormAdapter extends TypeAdapter<OnboardingForm> {
  @override
  final int typeId = 3;

  @override
  OnboardingForm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnboardingForm(
      answers: (fields[0] as Map).cast<String, dynamic>(),
      completedAt: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OnboardingForm obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.answers)
      ..writeByte(1)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingFormAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
