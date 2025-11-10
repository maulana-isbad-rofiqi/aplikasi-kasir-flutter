// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_transaksi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransaksiAdapter extends TypeAdapter<Transaksi> {
  @override
  final int typeId = 2;

  @override
  Transaksi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaksi(
      id: fields[0] as String,
      items: (fields[1] as List).cast<KeranjangItem>(),
      totalHarga: fields[2] as int,
      metodePembayaran: fields[3] as String,
      tanggal: fields[4] as DateTime,
      uangBayar: fields[5] as int?,
      kembalian: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaksi obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.totalHarga)
      ..writeByte(3)
      ..write(obj.metodePembayaran)
      ..writeByte(4)
      ..write(obj.tanggal)
      ..writeByte(5)
      ..write(obj.uangBayar)
      ..writeByte(6)
      ..write(obj.kembalian);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransaksiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
