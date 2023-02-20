// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marvel_characters_db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MarvelCharacterDbModelAdapter
    extends TypeAdapter<MarvelCharacterDbModel> {
  @override
  final int typeId = 1;

  @override
  MarvelCharacterDbModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MarvelCharacterDbModel(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      modified: fields[3] as String,
      thumbnailUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MarvelCharacterDbModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.modified)
      ..writeByte(4)
      ..write(obj.thumbnailUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarvelCharacterDbModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
