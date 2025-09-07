// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QrCodeModelAdapter extends TypeAdapter<QrCodeModel> {
  @override
  final int typeId = 0;

  @override
  QrCodeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QrCodeModel(
      data: fields[0] as String,
      imagePath: fields[1] as String,
      dateCreated: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QrCodeModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.dateCreated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QrCodeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
