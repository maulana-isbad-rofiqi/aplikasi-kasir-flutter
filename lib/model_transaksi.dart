import 'package:hive/hive.dart';
import 'model_keranjang.dart';
part 'model_transaksi.g.dart';

@HiveType(typeId: 2)
class Transaksi extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<KeranjangItem> items;
  @HiveField(2)
  final int totalHarga;
  @HiveField(3)
  final String metodePembayaran;
  @HiveField(4)
  final DateTime tanggal;
  @HiveField(5)
  final int? uangBayar;
  @HiveField(6)
  final int? kembalian;

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