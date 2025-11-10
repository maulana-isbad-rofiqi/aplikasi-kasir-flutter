// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

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
      harga: fields[1] as double,
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
      harga: fields[2] as double,
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

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 5;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      nama: fields[0] as String,
      jumlah: fields[1] as int,
      harga: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.jumlah)
      ..writeByte(2)
      ..write(obj.harga);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      items: (fields[1] as List).cast<Item>(),
      totalHarga: fields[2] as double,
      metodePembayaran: fields[3] as String,
      tanggal: fields[4] as DateTime,
      uangBayar: fields[5] as double?,
      kembalian: fields[6] as double?,
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
