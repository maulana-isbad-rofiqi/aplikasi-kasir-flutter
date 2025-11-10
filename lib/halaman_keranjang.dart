import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'halaman_checkout.dart';

class HalamanKeranjang extends StatefulWidget {
  const HalamanKeranjang({super.key});

  @override
  State<HalamanKeranjang> createState() => _HalamanKeranjangState();
}

class _HalamanKeranjangState extends State<HalamanKeranjang> {
  final Box<KeranjangItem> _keranjangBox =
      Hive.box<KeranjangItem>('keranjangBox');
  final Box<Produk> _produkBox = Hive.box<Produk>('produkBox');

  void _tambahJumlah(KeranjangItem item) {
    final Produk? produkAsli = _produkBox.get(item.produkKey);
    if (produkAsli == null) return;

    if (produkAsli.stok > 0) {

      produkAsli.stok--;
      produkAsli.save();

      item.jumlah++;
      item.save();
    } else {

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stok produk sudah habis!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _kurangiJumlah(KeranjangItem item, int itemKey) {
    final Produk? produkAsli = _produkBox.get(item.produkKey);
    if (produkAsli != null) {
      produkAsli.stok++;
      produkAsli.save();
    }

    if (item.jumlah > 1) {
      item.jumlah--;
      item.save();
    } else {
      _keranjangBox.delete(itemKey);
    }
  }

  double _hitungTotalHarga() {
    double total = 0.0;
    for (var item in _keranjangBox.values) {
      total += (item.harga * item.jumlah);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0, name: 'Rp ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _keranjangBox.listenable(),
        builder: (context, Box<KeranjangItem> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('Keranjang Anda masih kosong.'),
            );
          }

          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final item = box.getAt(index)!;
              final int itemKey = box.keyAt(index) as int;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(item.imageUrl),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.error),
                    ),
                  ),
                  title: Text(item.nama),
                  subtitle: Text(formatCurrency.format(item.harga)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _kurangiJumlah(item, itemKey),
                      ),
                      Text(
                        item.jumlah.toString(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _tambahJumlah(item),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _keranjangBox.listenable(),
        builder: (context, Box<KeranjangItem> box, _) {
          if (box.values.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Harga:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)
                      ),
                    ),
                    Text(
                      formatCurrency.format(_hitungTotalHarga()),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HalamanCheckout(),
                      ),
                    );
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}