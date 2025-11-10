// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_riwayat_stok.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RiwayatStokAdapter extends TypeAdapter<RiwayatStok> {
  @override
  final int typeId = 3;

  @override
  RiwayatStok read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RiwayatStok(
      produkKey: fields[0] as int,
      namaProduk: fields[1] as String,
      jumlah: fields[2] as int,
      keterangan: fields[3] as String,
      tanggal: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RiwayatStok obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.produkKey)
      ..writeByte(1)
      ..write(obj.namaProduk)
      ..writeByte(2)
      ..write(obj.jumlah)
      ..writeByte(3)
      ..write(obj.keterangan)
      ..writeByte(4)
      ..write(obj.tanggal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiwayatStokAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
