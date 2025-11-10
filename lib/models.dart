import 'package:hive/hive.dart';

part 'models.g.dart'; 

@HiveType(typeId: 0)
class Produk extends HiveObject {
  @HiveField(0)
  String nama;
  @HiveField(1)
  double harga; 
  @HiveField(2)
  int stok;
  @HiveField(3)
  String imageUrl; 
  @HiveField(4)
  String deskripsi;

  Produk({
    required this.nama,
    required this.harga,
    required this.stok,
    required this.imageUrl,
    required this.deskripsi,
  });
}

@HiveType(typeId: 1)
class KeranjangItem extends HiveObject {
  @HiveField(0)
  final int produkKey;
  @HiveField(1)
  final String nama;
  @HiveField(2)
  final double harga;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  int jumlah;

  KeranjangItem({
    required this.produkKey,
    required this.nama,
    required this.harga,
    required this.imageUrl,
    required this.jumlah,
  });
}

@HiveType(typeId: 5) 
class Item extends HiveObject {
  @HiveField(0)
  final String nama;
  @HiveField(1)
  final int jumlah;
  @HiveField(2)
  final double harga; 

  Item({
    required this.nama,
    required this.jumlah,
    required this.harga,
  });
}


@HiveType(typeId: 2)
class Transaksi extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<Item> items;
  @HiveField(2)
  final double totalHarga;
  @HiveField(3)
  final String metodePembayaran;
  @HiveField(4)
  final DateTime tanggal;
  @HiveField(5)
  final double? uangBayar;
  @HiveField(6)
  final double? kembalian;

  Transaksi({
    required this.id,
    required this.items,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.tanggal,
    this.uangBayar,
    this.kembalian,
  });
}

@HiveType(typeId: 3) 
class RiwayatStok extends HiveObject {
  @HiveField(0)
  final int produkKey;
  @HiveField(1)
  final String namaProduk;
  @HiveField(2)
  final int jumlah;
  @HiveField(3)
  final String keterangan;
  @HiveField(4)
  final DateTime tanggal;

  RiwayatStok({
    required this.produkKey,
    required this.namaProduk,
    required this.jumlah,
    required this.keterangan,
    required this.tanggal,
  });
}