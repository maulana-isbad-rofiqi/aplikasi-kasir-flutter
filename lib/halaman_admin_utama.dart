import 'package:flutter/material.dart';
import 'halaman_admin_produk.dart';
import 'halaman_admin_pembayaran.dart';
import 'halaman_admin_toko.dart';
import 'halaman_riwayat_transaksi.dart';
import 'halaman_riwayat_stok.dart';

class HalamanAdminUtama extends StatelessWidget {
  const HalamanAdminUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Admin'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.storefront_outlined),
              title: const Text('Pengaturan Toko'),
              subtitle: const Text('Atur nama dan logo toko Anda'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HalamanAdminToko(),
                ));
              },
            ),
          ),
          
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Kelola Produk'),
              subtitle: const Text('Tambah, edit, hapus, dan atur stok'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HalamanAdminProduk(),
                  ),
                );
              },
            ),
          ),
          
          Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code_scanner_outlined),
              title: const Text('Kelola Pembayaran'),
              subtitle: const Text('Atur CASH, DANA dan gambar QRIS'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HalamanAdminPembayaran(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Riwayat Transaksi'),
              subtitle: const Text('Lihat semua struk/nota penjualan'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HalamanRiwayatTransaksi(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.history_outlined),
              title: const Text('Riwayat Stok'),
              subtitle: const Text('Lihat riwayat penambahan stok'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HalamanRiwayatStok(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}