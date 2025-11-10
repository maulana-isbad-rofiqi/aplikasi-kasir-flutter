import 'package:hive/hive.dart';
part 'model_keranjang.g.dart';

@HiveType(typeId: 1)
class KeranjangItem extends HiveObject {
  @HiveField(0)
  final int produkKey;
  @HiveField(1)
  final String nama;
  @HiveField(2)
  final int harga;
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
