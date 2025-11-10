import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'models.dart';

class HalamanRiwayatStok extends StatelessWidget {
  const HalamanRiwayatStok({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<RiwayatStok> riwayatStokBox = Hive.box<RiwayatStok>('riwayatStokBox');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Stok'),
      ),
      body: ValueListenableBuilder(
        valueListenable: riwayatStokBox.listenable(),
        builder: (context, Box<RiwayatStok> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat penambahan stok.'),
            );
          }
          
          final List<RiwayatStok> riwayat = box.values.toList()
            ..sort((a, b) => b.tanggal.compareTo(a.tanggal));

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: riwayat.length,
            itemBuilder: (context, index) {
              final item = riwayat[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.add_shopping_cart_outlined),
                  title: Text('+${item.jumlah} ${item.namaProduk}'),
                  subtitle: Text(item.keterangan),
                  trailing: Text(
                    DateFormat('dd/MM/yy\nHH:mm').format(item.tanggal),
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}