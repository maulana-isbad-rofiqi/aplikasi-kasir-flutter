import 'package:hive/hive.dart';
part 'model_riwayat_stok.g.dart';

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