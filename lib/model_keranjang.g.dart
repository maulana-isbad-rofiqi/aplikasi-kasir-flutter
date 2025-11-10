// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_keranjang.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KeranjangItemAdapter extends TypeAdapter<KeranjangItem> {
  @override
  final int typeId = 1;

  @override
  KeranjangItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KeranjangItem(
      produkKey: fields[0] as int,
      nama: fields[1] as String,
      harga: fields[2] as int,
      imageUrl: fields[3] as String,
      jumlah: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, KeranjangItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.produkKey)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.harga)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.jumlah);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeranjangItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
