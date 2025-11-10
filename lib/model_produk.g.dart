// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_produk.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProdukAdapter extends TypeAdapter<Produk> {
  @override
  final int typeId = 0;

  @override
  Produk read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Produk(
      nama: fields[0] as String,
      harga: fields[1] as int,
      stok: fields[2] as int,
      imageUrl: fields[3] as String,
      deskripsi: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Produk obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.harga)
      ..writeByte(2)
      ..write(obj.stok)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.deskripsi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdukAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
