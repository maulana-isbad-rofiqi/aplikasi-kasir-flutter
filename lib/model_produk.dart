import 'package:hive/hive.dart';
part 'model_produk.g.dart';

@HiveType(typeId: 0)
class Produk extends HiveObject {
  @HiveField(0)
  String nama;
  @HiveField(1)
  int harga;
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
