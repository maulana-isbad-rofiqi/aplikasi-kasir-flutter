import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'halaman_struk.dart';

class HalamanRiwayatTransaksi extends StatelessWidget {
  const HalamanRiwayatTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<Transaksi> transaksiBox = Hive.box<Transaksi>('transaksiBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: ValueListenableBuilder(
        valueListenable: transaksiBox.listenable(),
        builder: (context, Box<Transaksi> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('Belum ada transaksi.'),
            );
          }

          final List<Transaksi> transaksi = box.values.toList()
            ..sort((a, b) => b.tanggal.compareTo(a.tanggal));

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: transaksi.length,
            itemBuilder: (context, index) {
              final item = transaksi[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_outlined),
                  title: Text('ID: ${item.id}'),
                  subtitle: Text(
                    DateFormat('dd MMMM yyyy, HH:mm').format(item.tanggal),
                  ),
                  trailing: Text(
                    'Rp ${item.totalHarga}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HalamanStruk(transaksi: item),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}